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
    return [self RequestWithMethod:MFJRequestMethodTypeGET];
}

+ (nonnull instancetype)RequestWithMethod:(MFJRequestMethodType)method
{
    return [[self alloc] initWithRequestMethod:method];
}

- (nonnull instancetype)initRequest
{
    return [self initWithRequestMethod:MFJRequestMethodTypeGET];
}

- (nonnull instancetype)initWithRequestMethod:(MFJRequestMethodType)method
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
    self.cachePolicy        = MFJRequestCachePolicyNoCache;
    self.outputData         = nil;
    self.output             = nil;
    self.params             = [NSMutableDictionary dictionary];
    self.soapMessage        = nil;
    self.responseString     = nil;
    self.error              = nil;
    self.status             = MFJRequestStatusNotStart;
    self.url                = nil;
    self.message            = nil;
    self.codeKey            = nil;
    self.exactitudeKey      = MFJ_REQUEST_RIGHT_CODE;
    self.exactitudeKeyPath  = MFJ_ERROR_CODE_PATH;
    self.SCHEME             = nil;
    self.HOST               = nil;
    self.PATH               = @"";
    self.STATICPATH         = @"";
    self.METHOD             = MFJRequestMethodTypeGET;
    self.needCheckCode      = NO;
    self.requestSerializer  = MFJRequestSerializerTypeHTTP;
    self.responseSerializer = MFJResponseSerializerTypeJSON;
    self.timeoutInterval    = MFJ_API_REQUEST_TIME_OUT;
    self.isFirstRequest     = YES;
    self.isTimeout          = NO;
    self.action             = [MFJReqAction action];
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
        [self.action sendRequest:self];
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

- (NSUInteger)hash {
    NSAssert(self.url.absoluteString.length>0, @"url is empty");
    NSMutableString *hashStr = nil;
    if (self.params) {
        hashStr = [NSMutableString stringWithFormat:@"%li%@",
                                    [self METHOD], [self url]];
    }else{
        hashStr = [NSMutableString stringWithFormat:@"%li%@%@",
                                    [self METHOD], [self url], [self joinToPath]];
    }
    return [hashStr hash];
}

- (NSString *)joinToPath{
    NSMutableArray *array = [NSMutableArray array];
    [self.params enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        NSString *str = [NSString stringWithFormat:@"%@=%@",key,value];
        [array addObject:str];
    }];
    return [array componentsJoinedByString:@"&"];
}

@end
