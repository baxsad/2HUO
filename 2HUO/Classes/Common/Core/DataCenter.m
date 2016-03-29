//
//  DataCenter.m
//  BiHu_iPhone
//
//  Created by iURCoder on 1/23/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "DataCenter.h"
#import "MYREQUEST.h"

@implementation DataCenter

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static DataCenter* __singleton__;
    dispatch_once(&once, ^{
        __singleton__ = [[[self class] alloc] init];
    });
    __singleton__.action = [Action wAction];
    return __singleton__;
}

- (void)uploadPictureWithImage:(UIImage*)image with:(UploadPictureModel)model callBack:(void(^)(BOOL state,NSString *fileName))callBack
{
    self.uploadPictureRequest = [MYREQUEST uploadPictureModel:model];
    @weakify(self);
    self.uploadPictureRequest.requestInActiveBlock = ^{
        @strongify(self);
        [self.action Send:self.uploadPictureRequest];
    };
    
    if (image.size.width > 1080.0 || image.size.height > 1080.0) {
        image = [UIImage imageWithMaxSide:1080 sourceImage:image];
    }
    NSData* data = UIImageJPEGRepresentation(image, 0.9);
    self.uploadPictureRequest.requestFiles = @{ @"file" : data };
    self.uploadPictureRequest.timeoutInterval = 50;
    self.uploadPictureRequest.requestNeedActive = YES;
    
    [RACObserve(self.uploadPictureRequest, status) subscribeNext:^(id x) {
        if (self.uploadPictureRequest.succeed) {
            
            NSDictionary* response =
            [self.uploadPictureRequest.output objectAtPath:@"pid"];
            if (callBack) {
                callBack(YES,[NSString stringWithFormat:@"http://ww2.sinaimg.cn/large/%@",response]);
            }
        }
        else if (self.uploadPictureRequest.failed) {
            if (callBack) {
                callBack(NO,@"上传出错！");
            }
        }
    }];
}

@end
