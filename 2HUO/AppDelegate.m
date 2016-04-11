//
//  AppDelegate.m
//  2HUO
//
//  Created by iURCoder on 3/15/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "AppDelegate.h"
#import "MFUHomeViewController.h"
#import "MFJRouter.h"
#import <AVOSCloud/AVOSCloud.h>
#import "UMSocial.h"
#import "UMSocialSinaSSOHandler.h"
#import "IQKeyboardManager.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "TMCache.h"
#import "FPSLable.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    MFUHomeViewController * home = [[MFUHomeViewController alloc] init];
    self.window.rootViewController = home;
    [self.window makeKeyAndVisible];
    
//    FPSLable *fps = [FPSLable new];
//    fps.centerY = 25;
//    [self.window addSubview:fps];
    
    [MFJRouter sharedInstance].openException = YES;
    [[MFJRouter sharedInstance] reg];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:UIColorHex(0x333333)};
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    UIImage *backButtonImage = [[UIImage imageNamed:@"arrow_left"] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, 0, 0)]; ;
    backButtonImage = [backButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [[UINavigationBar appearance] setBackIndicatorImage:backButtonImage];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backButtonImage];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [UINavigationBar appearance].layer.opacity = 1;
    [[UINavigationBar appearance] setBarTintColor:UIColorHex(0xF9F7F4)];
    [[UINavigationBar appearance] setTintColor:UIColorHex(0xF9F7F4)];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    [AVOSCloud setApplicationId:@"FM9OAvPJzXtzIVFp8G39AdCG-gzGzoHsz"
                      clientKey:@"bSnxSKtyJaKCocdbXCum4XfR"];
    
    [UMSocialData setAppKey:@"57074e7e67e58e35ca000c98"];
    [UMSocialConfig setFollowWeiboUids:@{UMShareToSina:@"521733123"}];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3390655125"
                                              secret:@"a27b0c2e581ffddb22e9a0b663ca7f93"
                                         RedirectURL:@"http://open.weibo.com/apps/3390655125/info/advanced"];

    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    
    
    [UMSocialWechatHandler setWXAppId:@"wx34395ba624fb9c7c" appSecret:@"589bc13601292147f9df4f84ace91b19" url:@"http://www.umeng.com/social"];
    
    id obj = [[TMCache sharedCache] objectForKey:kUSERCACHE];
    NSDictionary *dic = [obj toDictionary];
    User * user = [[User alloc] initWithDictionary:dic error:NULL];
    [[AccountCenter shareInstance] save:user];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}

@end
