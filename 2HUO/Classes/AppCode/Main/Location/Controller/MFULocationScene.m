//
//  MFUAnailticsScene.m
//  2HUO
//
//  Created by iURCoder on 3/23/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFULocationScene.h"
#import "MFJNetWorking.h"

@interface MFULocationScene ()

@property (nonatomic, strong) MFJBaseRequest * req;

@end

@implementation MFULocationScene

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.req.requestNeedActive = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.req = [[MFJBaseRequest alloc] initRequest];
    
    self.req.requestNeedActive = YES;
    [[MFJRequestManager sharedMFJREQManager] listen:^(MFJBaseRequest *req) {
        NSLog(@"%li",req.status);
    }];
    
}

@end
