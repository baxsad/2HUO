//
//  Created by iURCoder on 11/3/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import "BaseRequest.h"

@implementation BaseRequest

///-------------------------------------------------------------
/// @brief 通过类方法构建request请求
///-------------------------------------------------------------
+(id)Request
{
    return [[self alloc] initRequest];
}

-(id)initRequest
{
    self = [super init];
    if(self){
        [self loadRequest];
    }
    return self;
}
///-------------------------------------------------------------
/// @brief 通过block构建request请求
///-------------------------------------------------------------
+(id)RequestWithBlock:(wRequestBlock)voidBlock
{
    return [[self alloc] initRequestWithBlock:voidBlock];
}

-(id)initRequestWithBlock:(wRequestBlock)voidBlock
{
    self = [super init];
    if(self){
        self.requestInActiveBlock = voidBlock;
        [self loadRequest];
    }
    return self;
}
///-------------------------------------------------------------
/// @brief 初始化请求
///-------------------------------------------------------------
-(void)loadRequest
{
    
    self.output         = nil;
    self.message        = @"";
    self.SCHEME         = @"";
    self.HOST           = @"";
    self.PATH           = @"";
    self.METHOD         = @"GET";
    self.needCheckCode  = NO;
    self.params         = [NSMutableDictionary dictionary];
    self.isFirstRequest = YES;
    self.isTimeout      = NO;
    [self loadActive];
    
}
///-------------------------------------------------------------
/// @brief 加载请求！
/// 通过监听 requestNeedActive 属性的变化来判断是否请求
///-------------------------------------------------------------
- (void)loadActive
{
    self.requestNeedActive = NO;
    @weakify(self);
    [[RACObserve(self,requestNeedActive)
      filter:^BOOL(NSNumber *active) {
          return [active boolValue];
      }]
     subscribeNext:^(NSNumber *active) {
         @strongify(self);
         if (self.requestInActiveBlock) {
             self.requestInActiveBlock();
         }
         self.requestNeedActive = NO;
     }];
    
    

    
}
///-------------------------------------------------------------
/// @brief 请求成功的话返回 yes （任何时候都可以调用来来判断请求状态）
///-------------------------------------------------------------
- (BOOL)succeed
{
    if(self.output == nil){
        return NO;
    }
    return wRequestStatusSuccess == self.status ? YES : NO;
}
///-------------------------------------------------------------
/// @brief 请求失败的话返回 yes （...）
///-------------------------------------------------------------
- (BOOL)failed
{
    return wRequestStatusFailed == self.status || wRequestStatusError == self.status ? YES : NO;
}
///-------------------------------------------------------------
/// @brief 还在请求过程中则返回 yes （...）
///-------------------------------------------------------------
- (BOOL)sending
{
    return wRequestStatusSending == self.status ? YES : NO;
}
///-------------------------------------------------------------
/// @brief 请求如果被取消则返回 yes （...）
///-------------------------------------------------------------
- (BOOL)cancled
{
    return wRequestStatusCancle == self.status ? YES : NO;
}
///-------------------------------------------------------------
/// @brief 请求如果超时 yes （...）
///-------------------------------------------------------------
- (BOOL)timeOut
{
    return wRequestStatusTimeOut == self.status ? YES : NO;
}
///-------------------------------------------------------------
/// @brief 请求不为空，没有完成，没有被取消，在执行的时候 才执行取消操作
///-------------------------------------------------------------
- (void)cancle
{
//    if(self.op.isNotEmpty && self.op.isExecuting && !self.op.isFinished && !self.op.isCancelled){
//        [self.op cancel];
//        if(self.op.isCancelled){
//            self.status = wRequestStatusCancle;
//        }
//    }
}
///-------------------------------------------------------------
/// @name 根据每一个请求的请求地址生成一个唯一的缓存标识符 key
///-------------------------------------------------------------
-(NSString *)cacheKey{
    NSAssert(self.url.isNotEmpty, @"url is empty");
    if([self.METHOD isEqualToString:@"GET"]){
        return self.url.absoluteString.MD5;
    }else if(self.params.isNotEmpty){
        return [NSString stringWithFormat:@"%@%@",self.url,[self.params joinToPath]].MD5;
    }else{
        return [NSString stringWithFormat:@"%@",self.url].MD5;
    }
}

@end
