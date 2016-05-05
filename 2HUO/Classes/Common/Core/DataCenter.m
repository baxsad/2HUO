//
//  DataCenter.m
//  2HUO
//
//  Created by iURCoder on 5/4/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "DataCenter.h"

@interface DataCenter ()

@property (nonatomic, strong) GDReq * uploadImageRequest;

@end

@implementation DataCenter

+ (instancetype)defaultCenter
{
    static DataCenter *center;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[[self class] alloc] init];
        center.uploadImageRequest = [GDReq Request];
        center.uploadImageRequest.METHOD = @"POST";
        center.uploadImageRequest.responseSerializer = GDResponseSerializerTypeJSON;
        center.uploadImageRequest.STATICPATH = @"http://x.mouto.org/wb/x.php?up";
    });
    return center;
}

- (void)uploadPicture:(UIImage *)image progress:(void (^)(float progress))progress response:(void (^)(NSString *image))response
{
    if (image == nil) {
        return;
    }
    self.uploadImageRequest.requestFiles = @{@"file":image};
    self.uploadImageRequest.requestNeedActive = YES;
    self.uploadImageRequest.requestProgressBlock = ^(NSProgress * Progress){
        if (progress) {
            progress(Progress.fractionCompleted);
        }
    };
    [self.uploadImageRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            if (response) {
                NSString * imageName = [NSString stringWithFormat:@"http://ww2.sinaimg.cn/large/%@",[req.output objectAtPath:@"pid"]];
                response(imageName);
            }
        }
        if (req.failed) {
            if (response) {
                response(nil);
            }
        }
    }];
}

@end
