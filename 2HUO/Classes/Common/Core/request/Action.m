//
//  Created by iURCoder on 11/3/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import "Action.h"
#import "TMCache.h"
/*! @brief 请求设置
 *
 */
@interface Action()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
/** 是否缓存 */
@property(nonatomic,assign)BOOL        cacheEnable;
/** 是否从缓存中取数据 */
@property(nonatomic,assign)BOOL        dataFromCache;
/** 服务端域名:端口 */
@property(nonatomic,retain)NSString  * HOST_URL;
/** 自定义客户端识别(app) */
@property(nonatomic,retain)NSString  * CLIENT;
/** 错误码key like:(error_code) */
@property(nonatomic,retain)NSString  * CODE_KEY;
/** 正确校验码 like:(0:YES 1:YES) */
@property(nonatomic,assign)NSUInteger  RIGHT_CODE;
/** 消息提示msg like:(message) */
@property(nonatomic,retain)NSString  * MSG_KEY;

@end

@implementation Action

DEF_SINGLETON(Action)
+ (void)actionConfigServer:(NSString *)host client:(NSString *)client codeKey:(NSString *)codeKey rightCode:(NSInteger)rightCode msgKey:(NSString *)msgKey{
    
    [Action sharedInstance].HOST_URL   = host;
    [Action sharedInstance].CLIENT     = client;
    [Action sharedInstance].CODE_KEY   = codeKey;
    [Action sharedInstance].RIGHT_CODE = rightCode;
    [Action sharedInstance].MSG_KEY    = msgKey;
    
}
+ (id)wAction{
    return [[[self class] alloc] initManager];
}
- (id)initManager
{
    self = [super init];
    if(self){
        _cacheEnable   = NO;
        _dataFromCache = NO;
        self.manager   = nil;
        self.manager   = [AFHTTPSessionManager manager];
        AFHTTPRequestSerializer* serializer = [AFHTTPRequestSerializer serializer];
        self.manager.requestSerializer      = serializer;
    }
    return self;
}
- (id)initWithCache
{
    self = [self initManager];
    _cacheEnable = YES;
    return self;
}
/*! @brief 使用缓存
 *
 */
- (void)useCache{
    _cacheEnable = YES;
}
/*! @brief 从缓存读取数据
 *
 */
- (void)readFromCache{
    _dataFromCache = YES;
}
/*! @brief 不从缓存读取数据
 *
 */
- (void)notReadFromCache{
    _dataFromCache = NO;
}

/**
 * 下载请求
 */
- (NSURLSessionTask *)Download:(BaseRequest *)req{
    return nil;
}

/**
 * 发送请求
 */
    
- (NSURLSessionDataTask *)Send:(BaseRequest *)req{
   
    if (req.requestSerializer       == 1){
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }else if(req.requestSerializer  == 2){
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }else if (req.requestSerializer == 3){
        self.manager.requestSerializer = [AFPropertyListRequestSerializer serializer];
    }else{
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    if (req.responseSerializer        == 1){
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }else if (req.responseSerializer  == 2){
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }else if (req.responseSerializer  == 3){
        self.manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    }else{
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    if([req.METHOD isEqualToString:@"GET"]){
        return [self GET:req];
    }else if([req.METHOD isEqualToString:@"POST"]){
        return [self POST:req];
    }else{
        return [self WCF:req];
    }
}
/**
 * WCF请求 （...待完善...）
 */
- (NSURLSessionDataTask *) WCF:(BaseRequest *)req
{
    NSURLSessionDataTask * op = nil;
    return op;
    
}
/**
 * GET请求
 */
- (NSURLSessionDataTask *) GET:(BaseRequest *)req
{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSessionDataTask * task = nil;
    if(req.httpHeaderFields.isNotEmpty){
        
        [req.httpHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
            [_manager.requestSerializer setValue:value forHTTPHeaderField:key];
        }];
    }
    
    if (req.timeoutInterval != 0) {
        self.manager.requestSerializer.timeoutInterval = req.timeoutInterval;
    }

    if (req.acceptableContentTypes.isNotEmpty) {
        self.manager.responseSerializer.acceptableContentTypes = req.acceptableContentTypes;
    }
    
    if (req.HOST && req.HOST.length>5) {
        req.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",req.HOST,req.PATH]];
    }else{
        req.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",self.manager.baseURL,req.PATH]];
    }
    [self sending:req];
    
    @weakify(req,self);
    task = [self.manager GET:req.url.absoluteString parameters:req.params progress:^(NSProgress * _Nonnull downloadProgress) {
        
        req.progress = downloadProgress.fractionCompleted;
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(req,self);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if(self.cacheEnable){
            // 缓存
            [[TMCache sharedCache] setObject:responseObject forKey:req.cacheKey block:^(TMCache *cache, NSString *key, id object) {
                FuckYou(@"%@ has cache!",req.url);
            }];
        }
        
        if (req.responseSerializer == wResponseSerializerHTTP) {
            req.outputData = responseObject;
        }
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            
            NSDictionary *dic = @{@"list":responseObject};
            req.output = dic;
            
        }else{
            req.output = responseObject;
        }
        
        [self checkCode:req];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        @strongify(req,self);
        req.error = error;
        [self failed:req];
    }];
    
    req.task = task;
    req.output = [[TMCache sharedCache] objectForKey:req.cacheKey];
    if (_dataFromCache == YES && req.output !=nil) {
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self checkCode:req];
        });
    }
    return task;
}

/**
 * POST请求
 */
- (NSURLSessionDataTask *)POST:(BaseRequest *)req{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURLSessionDataTask * task = nil;
    
    if(req.httpHeaderFields.isNotEmpty){
        
        [req.httpHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
            [_manager.requestSerializer setValue:value forHTTPHeaderField:key];
        }];
    }
    
    if (req.timeoutInterval != 0) {
        self.manager.requestSerializer.timeoutInterval = req.timeoutInterval;
    }
    
    if (req.acceptableContentTypes.isNotEmpty) {
        self.manager.responseSerializer.acceptableContentTypes = req.acceptableContentTypes;
    }
    @weakify(req,self);
    NSDictionary *file = req.requestFiles;
    
    if (req.HOST && req.HOST.length>5) {
        req.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",req.HOST,req.PATH]];
    }else{
        req.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",self.manager.baseURL,req.PATH]];
    }
    
    task = [self.manager POST:req.url.absoluteString parameters:req.params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if([file count]>0){
            for (NSString *key in [file allKeys]) {
                
                [formData appendPartWithFileData:[file objectForKey:key]
                                            name:key
                                        fileName:[NSString stringWithFormat:@"%@.jpg", key]
                                        mimeType:@"image/jpeg"];
                
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        req.progress = uploadProgress.fractionCompleted;
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(req,self);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if([file count] == 0 && _cacheEnable){
            // 缓存
            [[TMCache sharedCache] setObject:responseObject forKey:req.codeKey block:^(TMCache *cache, NSString *key, id object) {
                FuckYou(@"%@ has cache!",req.url);
            }];
        }
        if (req.responseSerializer == wResponseSerializerHTTP) {
            req.outputData = (NSData *)responseObject;
        }else{
            req.output = responseObject;
        }
        
        [self checkCode:req];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        @strongify(req,self);
        req.error = error;
        [self failed:req];
    }];
    
    req.task  = task;
    req.output = [[TMCache sharedCache] objectForKey:req.cacheKey];
    if (_dataFromCache == YES && req.output !=nil) {
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self checkCode:req];
        });
    }
    return task;
}

/**
 * 检查错误码
 */
- (void)checkCode:(BaseRequest *)req{
   // req.responseString = req.op.responseString;
    if (req.needCheckCode) {
        if ([req.output isKindOfClass:[NSData class]]) {//这里是判断返回的是data就转为字典
            req.output = ((NSData *)req.output).utf8String.jsonValueDecoded;
        }
        req.codeKey = [req.output objectAtPath:[Action sharedInstance].CODE_KEY];
        if([req.output objectAtPath:[Action sharedInstance].CODE_KEY] && [[req.output objectAtPath:[Action sharedInstance].CODE_KEY] intValue] == [Action sharedInstance].RIGHT_CODE){
            [self success:req];
        }else{
            
            if ([Action sharedInstance].MSG_KEY) {
                req.message = [req.output objectAtPath:[Action sharedInstance].MSG_KEY];
            }
            
            [self error:req];
        }
    }else{
        [self successAction:req];
    }
}

/**
 * 发送请求中
 */
- (void)sending:(BaseRequest *)req{
    req.status = wRequestStatusSending;
    if([self.aDelegaete respondsToSelector:@selector(handleActionMsg:)]){
        [self.aDelegaete handleActionMsg:req];
    }
}
/**
 * 请求成功
 */
- (void)success:(BaseRequest *)req{
    [self successAction:req];
}

- (void)successAction:(BaseRequest *)req{
    req.status = wRequestStatusSuccess;
    if([self.aDelegaete respondsToSelector:@selector(handleActionMsg:)]){
        [self.aDelegaete handleActionMsg:req];
    }
}
/**
 * 请求失败
 */
- (void)failed:(BaseRequest *)req{
    if(req.error.userInfo!= nil && [req.error.userInfo objectForKey:@"NSLocalizedDescription"]){
        req.message = [req.error.userInfo objectForKey:@"NSLocalizedDescription"];
        req.status = wRequestStatusFailed;
    }
    if (req.error.code == -1001) {
        req.isTimeout = YES;
        req.status = wRequestStatusTimeOut;
    }
    FuckYou(@"Url:%@ Request Failed:%@",req.url,req.message);
    if([self.aDelegaete respondsToSelector:@selector(handleActionMsg:)]){
        [self.aDelegaete handleActionMsg:req];
    }
}
/**
 * 请求错误
 */
- (void)error:(BaseRequest *)req{
    
    req.status = wRequestStatusError;
    if([self.aDelegaete respondsToSelector:@selector(handleActionMsg:)]){
        [self.aDelegaete handleActionMsg:req];
    }
}
/**
 * 加载进度
 */
- (void)progressing:(BaseRequest *)req{
    if([self.aDelegaete respondsToSelector:@selector(handleActionMsg:)]){
        [self.aDelegaete handleProgressMsg:req];
    }
}

@end
