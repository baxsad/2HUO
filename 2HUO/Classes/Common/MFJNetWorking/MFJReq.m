//
//  MFJReq.m
//  2HUO
//
//  Created by iURCoder on 3/31/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFJReq.h"
#import "MFJReqAction.h"

@interface MFJReq ()

@property (nonatomic, strong) MFJReqAction * action;

@end

@implementation MFJReq

+ (nonnull instancetype)Request
{
    return [self RequestWithMethod:@"GET"];
}

+ (nonnull instancetype)RequestWithMethod:(nonnull NSString *)method
{
    return [[self alloc] initWithRequestMethod:method];
}

- (nonnull instancetype)initRequest
{
    return [self initWithRequestMethod:@"GET"];
}

- (nonnull instancetype)initWithRequestMethod:(nonnull NSString *)method
{
    self = [super init];
    if(self){
        [self loadRequest];
        self.METHOD = method;
    }
    return self;
}

- (void)loadRequest
{
    self.securityPolicy         = [self reqSecurityPolicy];
    self.cachePolicy            = MFJRequestCachePolicyNoCache;
    self.output                 = nil;
    self.params                 = [NSMutableDictionary dictionary];
    self.responseString         = nil;
    self.error                  = nil;
    self.status                 = MFJRequestStatusNotStart;
    self.url                    = nil;
    self.message                = nil;
    self.codeKey                = nil;
    self.exactitudeKey          = MFJ_REQUEST_RIGHT_CODE;
    self.exactitudeKeyPath      = MFJ_ERROR_CODE_PATH;
    self.SCHEME                 = nil;
    self.HOST                   = nil;
    self.PATH                   = @"";
    self.STATICPATH             = @"";
    self.needCheckCode          = NO;
    self.responseSerializer     = MFJResponseSerializerTypeJSON;
    self.timeoutInterval        = MFJ_API_REQUEST_TIME_OUT;
    self.isFirstRequest         = YES;
    self.isTimeout              = NO;
    self.acceptableContentTypes = [self responseAcceptableContentTypes];
    self.httpHeaderFields       = [self requestHTTPHeaderField];
    self.action                 = [MFJReqAction action];
    [self loadActive];
    
}

- (void)loadActive
{
    self.requestNeedActive = NO;
}

- (void)setRequestNeedActive:(BOOL)requestNeedActive
{
    if (self.requestNeedActive == requestNeedActive) {
        return;
    }else{
        if (requestNeedActive == YES) {
            [self start];
            _requestNeedActive = NO;
        }else{
            return;
        }
    }
}

- (BOOL)succeed
{
    if(self.output == nil){
        return NO;
    }
    return MFJRequestStatusSuccess == self.status ? YES : NO;
}

- (BOOL)sending
{
    return MFJRequestStatusSending == self.status ? YES : NO;
}

- (BOOL)failed
{
    return (MFJRequestStatusFailed == self.status
            || MFJRequestStatusError == self.status)
    ? YES : NO;
}

- (BOOL)Error
{
    return MFJRequestStatusError == self.status ? YES : NO;
}

- (BOOL)cancled
{
    return MFJRequestStatusCancle == self.status ? YES : NO;
}

- (BOOL)timeOut
{
    return MFJRequestStatusTimeOut == self.status ? YES : NO;
}

- (void)start
{
    if (self.action) {
        [self.action Send:self];
    }
}

- (void)cancle
{
    if (self.action) {
        [self.action cancelRequest:self];
    }
}

- (void)listen:(nonnull listenCallBack)block
{
    if (block && self.action) {
        [self.action listen:block];
    }
}

- (NSURLRequestCachePolicy)RequestCachePolicy {
    return NSURLRequestUseProtocolCachePolicy;
}

- (nullable MFJSecurityPolicy *)reqSecurityPolicy {
    MFJSecurityPolicy *securityPolicy;
#ifdef DEBUG
    securityPolicy = [MFJSecurityPolicy policyWithPinningMode:MFJSSLPinningModeNone];
#else
    securityPolicy = [MFJSecurityPolicy policyWithPinningMode:MFJSSLPinningModePublicKey];
#endif
    return securityPolicy;
}

- (nullable NSDictionary *)requestHTTPHeaderField {
    return @{
             @"Content-Type" : @"application/json; charset=utf-8",
             };
}

- (nullable NSSet *)responseAcceptableContentTypes{
    return [NSSet setWithObjects:@"text/plain" ,
            @"application/json",
            @"text/json",
            @"text/javascript",
            @"text/html",
            @"image/png",
            @"image/jpeg",
            @"application/rtf",
            @"image/gif",
            @"application/zip",
            @"audio/x-wav",
            @"image/tiff",
            @" 	application/x-shockwave-flash",
            @"application/vnd.ms-powerpoint",
            @"video/mpeg",
            @"video/quicktime",
            @"application/x-javascript",
            @"application/x-gzip",
            @"application/x-gtar",
            @"application/msword",
            @"text/css",
            @"video/x-msvideo",
            @"text/xml", nil];
}

-(NSString *)appendPathInfo{
    __block NSString *pathInfo = self.pathInfo;
    if(pathInfo.isNotEmpty){
        [self.params enumerateKeysAndObjectsUsingBlock:^(NSString* key, id value, BOOL *stop) {
            NSString *par = [NSString stringWithFormat:@"(\\{%@\\})",key];
            NSString *str = [NSString stringWithFormat:@"%@",value];
            
            pathInfo = [[[NSRegularExpression alloc] initWithPattern:par options:0 error:nil] stringByReplacingMatchesInString:pathInfo options:0 range:NSMakeRange(0, pathInfo.length) withTemplate:str];
        }];
    }
    return pathInfo;
}

-(NSString *)pathInfo{
    return nil;
}

- (nullable NSString*)requestID{
    NSAssert(self.url.isNotEmpty, @"url is empty");
    if (_requestID) {
        return _requestID;
    }
    NSString * ID = @"";
    if([self.METHOD isEqualToString:@"GET"]){
        ID = self.url.absoluteString.MD5;
    }else if(self.params.isNotEmpty){
        ID = [NSString stringWithFormat:@"%@%@",self.url,[self.params joinToPath]].MD5;
    }else{
        ID = [NSString stringWithFormat:@"%@",self.url].MD5;
    }
    _requestID = ID;
    return ID;
}


@end
