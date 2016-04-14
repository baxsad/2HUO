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
    request.HOST = @"https://x.mouto.org/";
    request.PATH = @"/wb/x.php?up";
    request.METHOD = @"POST";
    request.STATICPATH = @"https://www.baidu.com";
    request.needCheckCode = NO;
    request.responseSerializer = MFJResponseSerializerTypeHTTP;
    UIImage * image = [UIImage imageNamed:@"home_like"];
    
    request.requestFiles = @{@"filenamevbb":image};
    request.requestNeedActive = YES;
    request.requestProgressBlock = ^(NSProgress * s){
        NSLog(@"%f",s.fractionCompleted);
    };
    [request listen:^(MFJReq *req) {
        if (req.succeed) {
            NSLog(@"ooooook%@",((NSData*)req.output).utf8String);
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
