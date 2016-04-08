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
    [[MFJRouter sharedInstance] reg:@"mfj://addProduct" toClass:NSClassFromString(@"MFUReleaseProductScene") navClass:NSClassFromString(@"IHNavigationController")];
    
    
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
