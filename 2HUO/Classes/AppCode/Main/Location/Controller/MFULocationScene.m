//
//  MFUAnailticsScene.m
//  2HUO
//
//  Created by iURCoder on 3/23/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFULocationScene.h"
#import "MFJNetWorking.h"
#import "YDog.h"
#import <AVOSCloud/AVOSCloud.h>

@interface MFULocationScene ()

@property (nonatomic, strong) MFJReq * req;

@end

@implementation MFULocationScene

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.req start];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MFJReq * request = [[MFJReq alloc] initRequest];
    request.SCHEME = @"http";
    request.HOST = @"http://www.baomei.me/";
    request.PATH = @"appme/uploadImage.do";
    request.METHOD = MFJRequestMethodTypePOST;
    request.needCheckCode = NO;
    request.responseSerializer = MFJRequestSerializerTypeHTTP;
    UIImage * image = [UIImage imageNamed:@"home_like"];
    NSData * data = UIImageJPEGRepresentation(image, 0.5);;
    request.requestFiles = @{@"file":data};
    request.requestNeedActive = YES;
    [request listen:^(MFJReq *req) {
        if (req.succeed) {
            NSLog(@"ooooook%@",req.output);
        }
        if (req.failed) {
            NSLog(@"eeeeeer%@",req.error);
        }
    }];
    
    for (int i = 0; i<99; i++) {
        self.req.requestNeedActive = YES;
    }
    
    
    
    
}

@end
