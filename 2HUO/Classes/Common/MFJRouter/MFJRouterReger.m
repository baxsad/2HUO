//
//  MFJRouter+Extent.m
//  2HUO
//
//  Created by iURCoder on 3/22/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFJRouterReger.h"
#import "MFJRouter.h"

@implementation MFJRouterReger

+ (void)reg
{
    [[MFJRouter sharedInstance] reg:@"mfj://demo" toClass:NSClassFromString(@"DemoVC")];
    [[MFJRouter sharedInstance] reg:@"mfj://test" toClass:NSClassFromString(@"testViewController") navClass:NSClassFromString(@"IHNavigationController")];// 这样注册的话，模态跳转的时候带导航控制器
    
    
}

+ (void)clearCache
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    Class cls = NSClassFromString(@"UPRouter");
    id target  = [[cls alloc] init];
    SEL selector = NSSelectorFromString(@"cacheClear");
    if ([target respondsToSelector:selector]) {
        [target performSelector:selector];
    }
#pragma clang diagnostic pop
    
}

@end
