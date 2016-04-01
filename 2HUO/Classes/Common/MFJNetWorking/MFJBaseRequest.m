//
//  MFJBaseRequest.m
//  2HUO
//
//  Created by iURCoder on 3/31/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFJBaseRequest.h"
#import "MFJRequestManager.h"

@implementation MFJBaseRequest

+ (instancetype)Request
{
    return [[self alloc] initRequest];
}

- (instancetype)initRequest
{
    self = [super init];
    if(self){
        [self loadRequest];
    }
    return self;
}

- (void)loadRequest
{
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
    self.exactitudeKey      = RightKey;
    self.keyPath            = kEYPath;
    self.SCHEME             = nil;
    self.HOST               = nil;
    self.PATH               = nil;
    self.METHOD             = MFJRequestMethodTypeGET;
    self.needCheckCode      = NO;
    self.requestSerializer  = MFJRequestSerializerTypeHTTP;
    self.responseSerializer = MFJResponseSerializerTypeJSON;
    self.timeoutInterval    = 60;
    self.isFirstRequest     = YES;
    self.isTimeout          = NO;
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
    return MFJRequestStatusFailed == self.status ? YES : NO;
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
    [[MFJRequestManager sharedMFJREQManager] sendRequest:self];
}

- (void)cancle
{
    [[MFJRequestManager sharedMFJREQManager] cancelRequest:self];
}

- (NSURLRequestCachePolicy)RequestCachePolicy {
    return NSURLRequestUseProtocolCachePolicy;
}

- (NSUInteger)hash {
    NSAssert(self.url.isNotEmpty, @"url is empty");
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
