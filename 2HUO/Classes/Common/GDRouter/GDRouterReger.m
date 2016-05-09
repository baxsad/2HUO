//
//  GDRouter+Extent.m
//  2HUO
//
//  Created by iURCoder on 3/22/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "GDRouterReger.h"
#import "GDRouter.h"


@implementation GDRouterReger

+ (void)reg
{
    [[GDRouter sharedInstance] reg:@"GD://addPost" toClass:NSClassFromString(@"EHReleaseScene") navClass:NSClassFromString(@"IHNavigationController")];
    
    [[GDRouter sharedInstance] reg:@"GD://postList" toClass:NSClassFromString(@"EHCommunityPostsScene")];
    
    [[GDRouter sharedInstance] reg:@"GD://mine" toClass:NSClassFromString(@"EHMineScene") navClass:NSClassFromString(@"IHNavigationController")];
    
    [[GDRouter sharedInstance] reg:@"GD://selectType" toClass:NSClassFromString(@"EHCommunitySelectScene")];
    
    [[GDRouter sharedInstance] reg:@"GD://selectPrice" toClass:NSClassFromString(@"EHPriceSelectScene")];
    
    [[GDRouter sharedInstance] reg:@"GD://addressList" toClass:NSClassFromString(@"EHAddressListScene")];
    
    [[GDRouter sharedInstance] reg:@"GD://addAddress" toClass:NSClassFromString(@"EHUserInfoScene")];
    
    [[GDRouter sharedInstance] reg:@"GD://school" toClass:NSClassFromString(@"EHSchoolScene")];
    
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

+ (NSDictionary *)targetMap
{
    return @{@"temai":@"MFUHomeScene"};
}

+ (NSDictionary *)actionMap
{
    return @{@"add":@"rightButtonTouch"};
}

@end
