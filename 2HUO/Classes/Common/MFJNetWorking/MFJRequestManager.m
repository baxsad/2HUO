//
//  MFJRequestManager.m
//  2HUO
//
//  Created by iURCoder on 4/1/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFJRequestManager.h"
#import "MFJBaseRequest.h"

static dispatch_queue_t mfj_req_task_creation_queue() {
    static dispatch_queue_t mfj_req_task_creation_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mfj_req_task_creation_queue =
        dispatch_queue_create("me.iur.cool.networking.durandal.req.creation", DISPATCH_QUEUE_SERIAL);
    });
    return mfj_req_task_creation_queue;
}

static MFJRequestManager *sharedMFJREQManager       = nil;

@interface MFJRequestManager ()

@property (nonatomic, strong) NSCache *sessionManagerCache;
@property (nonatomic, strong) NSCache *sessionTasksCache;
@property (nonatomic, copy  ) listenCallBack listenBlock;

@end

@implementation MFJRequestManager

+ (nullable instancetype)sharedMFJREQManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMFJREQManager = [[self alloc] init];
    });
    return sharedMFJREQManager;
}

- (void)sendRequest:(nonnull MFJBaseRequest  *)req
{
    NSParameterAssert(req);
    dispatch_async(mfj_req_task_creation_queue(), ^{
        AFHTTPSessionManager *sessionManager = [self sessionManagerWithRequest:req];
        if (!sessionManager) {
            return;
        }
        if ([[NSThread currentThread] isMainThread]) {
            // not send
            [self requestNotStrat:req];
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                // not send
                [self requestNotStrat:req];
            });
        }
        [self _sendSingleRequest:req withSessionManager:sessionManager];
    });
}



- (void)cancelRequest:(nonnull MFJBaseRequest  *)req
{
    
}

- (NSDictionary *)requestParamsWithRequest:(MFJBaseRequest *)req
{
    return nil;
}

- (void)_sendSingleRequest:(MFJBaseRequest *)req withSessionManager:(AFHTTPSessionManager *)sessionManager {
    [self _sendSingleAPIRequest:req withSessionManager:sessionManager andCompletionGroup:nil];
}

- (void)_sendSingleAPIRequest:(MFJBaseRequest *)req
           withSessionManager:(AFHTTPSessionManager *)sessionManager
           andCompletionGroup:(dispatch_group_t)completionGroup {
    NSParameterAssert(req);
    NSParameterAssert(sessionManager);
    
    __weak typeof(self) weakSelf = self;
    if (!req.PATH) {
        req.PATH = @"";
    }
    NSString * requestUrlStr = req.PATH;
    id requestParams         = [self requestParamsWithRequest:req];
    
    req.url = [self requestUrl:req];
    
    NSString * hashKey       = [NSString stringWithFormat:@"%lu", (unsigned long)[req hash]];
    
    if ([self.sessionTasksCache objectForKey:hashKey]) {
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey : @"Request send too fast, please try again later"
                                   };
        NSError *cancelError = [NSError errorWithDomain:NSURLErrorDomain
                                                   code:NSURLErrorCancelled
                                               userInfo:userInfo];
//        [self callAPICompletion:api obj:nil error:cancelError];
        return;
    }
    
    void (^successBlock)(NSURLSessionDataTask *task, id responseObject)
    = ^(NSURLSessionDataTask * task, id responseObject) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        
        
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
    }
    
    if ([[NSThread currentThread] isMainThread]) {
        // send
        [self requestSending:req];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            // send
            [self requestSending:req];
        });
    }
}

- (NSURL *)requestUrl:(MFJBaseRequest *)req
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
- (AFHTTPSessionManager *)sessionManagerWithRequest:(MFJBaseRequest *)req {
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
- (NSString *)requestBaseUrlStringWithRequest:(MFJBaseRequest *)req {
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
    // 在某些情况下，一些用户会直接把整个url地址写进 baseUrl
    // 因此，还需要对baseUrl 进行一次切割
    NSURL *theUrl = [NSURL URLWithString:baseUrl];
    req.SCHEME = theUrl.scheme;
    req.HOST   = theUrl.host;
    return [NSString stringWithFormat:@"%@", theUrl.absoluteString];
}

- (AFHTTPResponseSerializer *)responseSerializerForRequest:(MFJBaseRequest *)req {
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
- (AFHTTPRequestSerializer *)requestSerializerForRequest:(MFJBaseRequest *)req {
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

- (void)cancelAPIRequest:(nonnull MFJBaseRequest *)req {
    dispatch_async(mfj_req_task_creation_queue(), ^{
        NSString *hashKey = [NSString stringWithFormat:@"%lu", (unsigned long)[req hash]];
        NSURLSessionDataTask *dataTask = [self.sessionTasksCache objectForKey:hashKey];
        [self.sessionTasksCache removeObjectForKey:hashKey];
        if (dataTask) {
            [dataTask cancel];
            [self requestCancle:req];
        }
    });
}

- (void)listenRequest:(MFJBaseRequest *)req
{
    if (self.listenBlock) {
        self.listenBlock(req);
    }
}

- (void)requestNotStrat:(MFJBaseRequest *)req
{
    req.status = MFJRequestStatusNotStart;
    [self listenRequest:req];
}

- (void)requestStartSend:(MFJBaseRequest *)req
{
    req.status = MFJRequestStatusStart;
    [self listenRequest:req];
    
}

- (void)requestSending:(MFJBaseRequest *)req
{
    req.status = MFJRequestStatusSending;
    [self listenRequest:req];
    
}

- (void)requestSucccess:(MFJBaseRequest *)req
{
    if (req.needCheckCode) {
        [self requestCheckCode:req];
    }
    req.status = MFJRequestStatusSuccess;
    [self listenRequest:req];
}

- (void)requestCancle:(MFJBaseRequest *)req
{
    req.status = MFJRequestStatusCancle;
    [self listenRequest:req];
}

- (void)requestFaild:(MFJBaseRequest *)req
{
    if(req.error.userInfo!= nil){
        req.message = [req.error.userInfo objectForKey:@"NSLocalizedDescription"];
        req.status = MFJRequestStatusError;
    }
    if (req.error.code == -1001) {
        req.isTimeout = YES;
        req.status = MFJRequestStatusTimeOut;
    }else{
        req.status = MFJRequestStatusError;
    }
    [self listenRequest:req];
}



- (void)requestError:(MFJBaseRequest *)req
{
    req.status = MFJRequestStatusError;
    [self listenRequest:req];
}

- (void)requestCheckCode:(MFJBaseRequest *)req
{
    NSString * rightKey = req.exactitudeKey;
    NSString * keyPath  = req.keyPath;
    if ([req.output isKindOfClass:[NSData class]]) {
        req.output = ((NSData *)req.output).utf8String.jsonValueDecoded;
    }
    req.codeKey = [req.output objectAtPath:keyPath];
    if([req.output objectAtPath:keyPath] && [[req.output objectAtPath:keyPath] intValue] == [rightKey integerValue]){
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
