//
//  MFJReqAction.m
//  2HUO
//
//  Created by iURCoder on 4/1/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFJReqAction.h"
#import "MFJReq.h"
#import "MFJGroupReq.h"

static dispatch_queue_t MFJ_req_task_creation_queue() {
    static dispatch_queue_t MFJ_req_task_creation_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MFJ_req_task_creation_queue =
        dispatch_queue_create("me.iur.cool.networking.durandal.req.creation", DISPATCH_QUEUE_SERIAL);
    });
    return MFJ_req_task_creation_queue;
}

static MFJReqAction *instance       = nil;

@interface MFJReqAction ()

@property (nonatomic, strong) NSCache *sessionManagerCache;
@property (nonatomic, strong) NSCache *sessionTasksCache;
@property (nonatomic, copy  ) listenCallBack listenBlock;

@end

@implementation MFJReqAction

+ (nonnull instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (nonnull instancetype)action
{
    return [[self alloc] init];
}

- (void)sendRequest:(nonnull MFJReq  *)req
{
    NSParameterAssert(req);
    dispatch_async(MFJ_req_task_creation_queue(), ^{
        AFHTTPSessionManager *sessionManager = [self sessionManagerWithRequest:req];
        if (!sessionManager) {
            return;
        }
        if ([[NSThread currentThread] isMainThread]) {
            [self requestNotStrat:req];
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self requestNotStrat:req];
            });
        }
        [self _sendSingleRequest:req withSessionManager:sessionManager];
    });
}

- (void)sendRequests:(nonnull MFJGroupReq *)groupreq
{
    NSParameterAssert(groupreq);
    
    NSAssert([[groupreq.requestsSet valueForKeyPath:@"hash"] count] == [groupreq.requestsSet count],
             @"Should not have same API");
    
    dispatch_group_t batch_api_group = dispatch_group_create();
    __weak typeof(self) weakSelf = self;
    [groupreq.requestsSet enumerateObjectsUsingBlock:^(id req, BOOL * stop) {
        dispatch_group_enter(batch_api_group);
        
        __strong typeof (weakSelf) strongSelf = weakSelf;
        AFHTTPSessionManager *sessionManager = [strongSelf sessionManagerWithRequest:req];
        if (!sessionManager) {
            *stop = YES;
            dispatch_group_leave(batch_api_group);
        }
        sessionManager.completionGroup = batch_api_group;
        
        [strongSelf _sendSingleAPIRequest:req
                       withSessionManager:sessionManager
                       andCompletionGroup:batch_api_group];
    }];
    dispatch_group_notify(batch_api_group, dispatch_get_main_queue(), ^{
        if (groupreq.delegate) {
            [groupreq.delegate groupRequestsDidFinished:groupreq];
        }
    });
}

- (void)cancelRequest:(nonnull MFJReq  *)req
{
    dispatch_async(MFJ_req_task_creation_queue(), ^{
        NSString *hashKey = [NSString stringWithFormat:@"%lu", (unsigned long)[req hash]];
        NSURLSessionDataTask *dataTask = [self.sessionTasksCache objectForKey:hashKey];
        [self.sessionTasksCache removeObjectForKey:hashKey];
        if (dataTask) {
            [dataTask cancel];
            [self requestCancle:req];
        }
    });
}

- (NSDictionary *)requestParamsWithRequest:(MFJReq *)req
{
    return nil;
}

- (void)_sendSingleRequest:(MFJReq *)req withSessionManager:(AFHTTPSessionManager *)sessionManager {
    [self _sendSingleAPIRequest:req withSessionManager:sessionManager andCompletionGroup:nil];
}

- (void)_sendSingleAPIRequest:(MFJReq *)req
           withSessionManager:(AFHTTPSessionManager *)sessionManager
           andCompletionGroup:(dispatch_group_t)completionGroup {
    
    NSParameterAssert(req);
    NSParameterAssert(sessionManager);
    
    __weak typeof(self) weakSelf = self;
    
    NSString * requestUrlStr = req.PATH;
    
    id requestParams         = [self requestParamsWithRequest:req];
    
    req.url = [self requestUrl:req];
    
    NSString * hashKey       = [NSString stringWithFormat:@"%lu", (unsigned long)[req hash]];
    
    if ([self.sessionTasksCache objectForKey:hashKey]) {
        // 请求正在执行中
        return;
    }
    
    void (^successBlock)(NSURLSessionDataTask *task, id responseObject)
    = ^(NSURLSessionDataTask * task, id responseObject) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        [self requestComplete:req obj:responseObject];
        
        [strongSelf.sessionTasksCache removeObjectForKey:hashKey];
        [self requestSucccess:req];
        if (completionGroup) {
            dispatch_group_leave(completionGroup);
        }
    };
    
    
    void (^failureBlock)(NSURLSessionDataTask * task, NSError * error)
    = ^(NSURLSessionDataTask * task, NSError * error) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        req.error = error;
        [self requestFaild:req];
        [strongSelf.sessionTasksCache removeObjectForKey:hashKey];
        if (completionGroup) {
            dispatch_group_leave(completionGroup);
        }
    };
    
    void (^requestProgressBlock)(NSProgress *progress)
    = req.requestProgressBlock ?
    ^(NSProgress *progress) {
        if (progress.totalUnitCount <= 0) {
            return;
        }
        req.requestProgressBlock(progress);
    } : nil;
    
    if ([[NSThread currentThread] isMainThread]) {
        // will send
        [self requestStartSend:req];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            // will send
            [self requestStartSend:req];
        });
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURLSessionDataTask *dataTask;
    switch ([req METHOD]) {
        case MFJRequestMethodTypeGET:
        {
            dataTask =
            [sessionManager GET:requestUrlStr
                     parameters:requestParams
                       progress:requestProgressBlock
                        success:successBlock
                        failure:failureBlock];
        }
            break;
        case MFJRequestMethodTypeDELETE:
        {
            dataTask =
            [sessionManager DELETE:requestUrlStr
                        parameters:requestParams
                           success:successBlock
                           failure:failureBlock];
        }
            break;
        case MFJRequestMethodTypePATCH:
        {
            dataTask =
            [sessionManager PATCH:requestUrlStr
                       parameters:requestParams
                          success:successBlock
                          failure:failureBlock];
        }
            break;
        case MFJRequestMethodTypePUT:
        {
            dataTask =
            [sessionManager PUT:requestUrlStr
                     parameters:requestParams
                        success:successBlock
                        failure:failureBlock];
        }
            break;
        case MFJRequestMethodTypeHEAD:
        {
            dataTask =
            [sessionManager HEAD:requestUrlStr
                      parameters:requestParams
                         success:^(NSURLSessionDataTask * _Nonnull task) {
                             if (successBlock) {
                                 successBlock(task, nil);
                             }
                         }
                         failure:failureBlock];
        }
            break;
        case MFJRequestMethodTypePOST:
        {
            NSDictionary *file = req.requestFiles;
            if (!file.count>0) {
                dataTask =
                [sessionManager POST:req.PATH
                          parameters:requestParams
                            progress:requestProgressBlock
                             success:successBlock
                             failure:failureBlock];
            } else {
                void (^block)(id <AFMultipartFormData> formData)
                = ^(id <AFMultipartFormData> formData) {
                    
                    if([file count]>0){
                        for (NSString *key in [file allKeys]) {
                            [formData appendPartWithFileData:[file objectForKey:key]
                                                        name:key
                                                    fileName:[NSString stringWithFormat:@"%@.jpg", key]
                                                    mimeType:@"image/jpeg"];
                            
                        }
                    }
                    
                };
                dataTask =
                [sessionManager POST:requestUrlStr
                          parameters:requestParams
           constructingBodyWithBlock:block
                            progress:requestProgressBlock
                             success:successBlock
                             failure:failureBlock];
            }
        }
            break;
        default:
            dataTask =
            [sessionManager GET:requestUrlStr
                     parameters:requestParams
                       progress:requestProgressBlock
                        success:successBlock
                        failure:failureBlock];
            break;
    }
    if (dataTask) {
        [self.sessionTasksCache setObject:dataTask forKey:hashKey];
        req.task = dataTask;
    }
    
    if ([[NSThread currentThread] isMainThread]) {
        [self requestSending:req];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self requestSending:req];
        });
    }
}

- (NSURL *)requestUrl:(MFJReq *)req
{
    if (req.METHOD == MFJRequestMethodTypePOST) {
        if ([req.PATH hasPrefix:@"/"]) {
            req.PATH = [req.PATH substringFromIndex:0];
        }
        NSString * urlString = [NSString stringWithFormat:@"%@://%@/%@",req.SCHEME,req.HOST,req.PATH];
        return [NSURL URLWithString:urlString];
    }else{
        NSString * urlString = [NSString stringWithFormat:@"%@://%@/%@/?%@",req.SCHEME,req.HOST,req.PATH,[req.params joinToPath]];
        return [NSURL URLWithString:urlString];
    }
}

#pragma mark - AFSessionManager
- (AFHTTPSessionManager *)sessionManagerWithRequest:(MFJReq *)req {
    NSParameterAssert(req);
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerForRequest:req];
    if (!requestSerializer) {
        // Serializer Error, just return;
        return nil;
    }
    
    // Response Part
    AFHTTPResponseSerializer *responseSerializer = [self responseSerializerForRequest:req];
    
    NSString *baseUrlStr = [self requestBaseUrlStringWithRequest:req];
    
    // AFHTTPSession
    AFHTTPSessionManager *sessionManager;
    sessionManager = [self.sessionManagerCache objectForKey:baseUrlStr];
    if (!sessionManager) {
        sessionManager = [self newSessionManagerWithBaseUrlStr:baseUrlStr];
        [self.sessionManagerCache setObject:sessionManager forKey:baseUrlStr];
    }
    
    sessionManager.requestSerializer     = requestSerializer;
    sessionManager.responseSerializer    = responseSerializer;
    // ssl安全之类的
    // sessionManager.securityPolicy        = [self securityPolicyWithAPI:api];
    
    return sessionManager;
}

- (AFHTTPSessionManager *)newSessionManagerWithBaseUrlStr:(NSString *)baseUrlStr {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    sessionConfig.HTTPMaximumConnectionsPerHost = MAX_HTTP_CONNECTION_PER_HOST;
    return [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrlStr]
                                    sessionConfiguration:sessionConfig];
}

#pragma mark - Request Invoke Organize
- (NSString *)requestBaseUrlStringWithRequest:(MFJReq *)req {
    NSParameterAssert(req);
    
    // 如果定义了自定义的Url, 则直接定义RequestUrl
    if ([req HOST]) {
        if (![req SCHEME]) {
            req.SCHEME = @"http";
        }
        if ([req.HOST componentsSeparatedByString:@"://"].count == 2) {
            NSString * host = [req.HOST componentsSeparatedByString:@"://"][1];
            if (![host hasSuffix:@"/"]) {
                host = [host stringByAppendingString:@"/"];
            }
            req.HOST = host;
        }
        NSURL *url  = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@",req.SCHEME,req.HOST]];
        return [NSString stringWithFormat:@"%@", url.absoluteString];
    }
    
    NSAssert(kHostPath != nil,
             @"api baseURL can't be nil together");
    
    NSString *baseUrl = kHostPath;
    if (![baseUrl hasPrefix:@"http"]) {
        baseUrl = [@"http://" stringByAppendingString:baseUrl];
    }
    
    NSURL *theUrl = [NSURL URLWithString:baseUrl];
    req.SCHEME = theUrl.scheme;
    req.HOST   = theUrl.host;
    return [NSString stringWithFormat:@"%@", theUrl.absoluteString];
}

- (AFHTTPResponseSerializer *)responseSerializerForRequest:(MFJReq *)req {
    NSParameterAssert(req);
    AFHTTPResponseSerializer *responseSerializer;
    if ([req responseSerializer] == MFJResponseSerializerTypeHTTP) {
        responseSerializer = [AFHTTPResponseSerializer serializer];
    } else {
        responseSerializer = [AFJSONResponseSerializer serializer];
    }
    responseSerializer.acceptableContentTypes = [req acceptableContentTypes];
    return responseSerializer;
}

#pragma mark - Serializer
- (AFHTTPRequestSerializer *)requestSerializerForRequest:(MFJReq *)req {
    NSParameterAssert(req);
    AFHTTPRequestSerializer *requestSerializer;
    if ([req requestSerializer] == MFJRequestSerializerTypeJSON) {
        requestSerializer = [AFJSONRequestSerializer serializer];
    } else {
        requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    
    requestSerializer.cachePolicy          = [req RequestCachePolicy];
    requestSerializer.timeoutInterval      = [req timeoutInterval];
    NSDictionary *requestHeaderFieldParams = req.httpHeaderFields;
    if (requestHeaderFieldParams) {
        [requestHeaderFieldParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    return requestSerializer;
}

- (NSCache *)sessionTasksCache {
    if (!_sessionTasksCache) {
        _sessionTasksCache = [[NSCache alloc] init];
    }
    return _sessionTasksCache;
}

- (void)requestComplete:(MFJReq *)req obj:(id)responseobject
{
    if (responseobject == nil) {
        req.output     = nil;
        req.outputData = nil;
    }
    if ([responseobject isKindOfClass:[NSString class]]) {
        req.outputData = [((NSString *)responseobject) dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        id output = [NSJSONSerialization JSONObjectWithData:req.outputData options:kNilOptions error:&error];
        if (error) {
            NSLog(@"url:%@ response error:%@",req.url, error);
        }
        req.output = output;
        req.responseString = [[NSString alloc] initWithData:req.outputData encoding:NSUTF8StringEncoding];
    }
    if ([responseobject isKindOfClass:[NSData class]]) {
        req.outputData = responseobject;
        NSError *error = nil;
        id output = [NSJSONSerialization JSONObjectWithData:req.outputData options:kNilOptions error:&error];
        if (error) {
            NSLog(@"url:%@ response error:%@",req.url, error);
        }
        req.output = output;
        req.responseString = [[NSString alloc] initWithData:req.outputData encoding:NSUTF8StringEncoding];
    }
    if ([responseobject isKindOfClass:[NSArray class]]) {
        req.outputData = [NSKeyedArchiver archivedDataWithRootObject:responseobject];
        req.output     = @{@"data":responseobject};
        req.responseString = [[NSString alloc] initWithData:req.outputData encoding:NSUTF8StringEncoding];
    }
    if ([responseobject isKindOfClass:[NSDictionary class]]) {
        req.outputData = [NSKeyedArchiver archivedDataWithRootObject:responseobject];
        req.output     = responseobject;
        req.responseString = [[NSString alloc] initWithData:req.outputData encoding:NSUTF8StringEncoding];
    }
}

- (void)listenRequest:(MFJReq *)req
{
    if (self.listenBlock) {
        self.listenBlock(req);
    }
}

- (void)requestNotStrat:(MFJReq *)req
{
    req.status = MFJRequestStatusNotStart;
    [self listenRequest:req];
}

- (void)requestStartSend:(MFJReq *)req
{
    req.status = MFJRequestStatusStart;
    [self listenRequest:req];
    
}

- (void)requestSending:(MFJReq *)req
{
    req.status = MFJRequestStatusSending;
    [self listenRequest:req];
    
}

- (void)requestSucccess:(MFJReq *)req
{
    if (req.needCheckCode) {
        [self requestCheckCode:req];
    }
    req.status = MFJRequestStatusSuccess;
    [self listenRequest:req];
}

- (void)requestCancle:(MFJReq *)req
{
    req.status = MFJRequestStatusCancle;
    [self listenRequest:req];
}

- (void)requestFaild:(MFJReq *)req
{
    if(req.error.userInfo!= nil){
        req.message = [req.error.userInfo objectForKey:@"NSLocalizedDescription"];
        req.status  = MFJRequestStatusFailed;
    }
    if (req.error.code == -1001) {
        req.isTimeout = YES;
        req.status    = MFJRequestStatusTimeOut;
    }else{
        req.status = MFJRequestStatusFailed;
    }
    [self listenRequest:req];
}



- (void)requestError:(MFJReq *)req
{
    req.status = MFJRequestStatusError;
    [self listenRequest:req];
}

- (void)requestCheckCode:(MFJReq *)req
{
    NSString * exactitudeKey      = req.exactitudeKey;
    NSString * exactitudeKeyPath  = req.exactitudeKeyPath;
    if ([req.output isKindOfClass:[NSData class]]) {
        NSError *error = nil;
        id output = [NSJSONSerialization JSONObjectWithData:(NSData *)req.output options:kNilOptions error:&error];
        if (error) {
            NSLog(@"url:%@ response error:%@",req.url, error);
            [self requestError:req];
            return;
        }
        req.output = output;
    }
    req.codeKey = [req.output objectForKey:exactitudeKeyPath];
    if([req.output objectForKey:exactitudeKeyPath] && [[req.output objectForKey:exactitudeKeyPath] intValue] == [exactitudeKey integerValue]){
        req.status = MFJRequestStatusSuccess;
        [self listenRequest:req];
    }else{
        [self requestError:req];
    }
    
}

- (void)listen:(listenCallBack)block
{
    if (block) {
        self.listenBlock = block;
    }
}

@end
