//
//  AppDelegate.m
//  2HUO
//
//  Created by iURCoder on 3/15/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocial.h"
#import "UMSocialSinaSSOHandler.h"
#import "IQKeyboardManager.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "TMCache.h"
#import "MainScene.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    MainScene * home = [[MainScene alloc] init];
    self.window.rootViewController = home;
    [self.window makeKeyAndVisible];

    /* 注册路由 */
    [GDRouter sharedInstance].openException = YES;
    [[GDRouter sharedInstance] reg];
    
    /* 键盘管理器 */
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    
    [UMSocialData setAppKey:@"57074e7e67e58e35ca000c98"];
    [UMSocialConfig setFollowWeiboUids:@{UMShareToSina:@"521733123"}];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3390655125"
                                              secret:@"a27b0c2e581ffddb22e9a0b663ca7f93"
                                         RedirectURL:@"http://open.weibo.com/apps/3390655125/info/advanced"];

    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    
    [UMSocialWechatHandler setWXAppId:@"wx34395ba624fb9c7c" appSecret:@"589bc13601292147f9df4f84ace91b19" url:@"http://www.umeng.com/social"];
    
    /* 先从缓存取用户信息（注销或者未登录的话 user ＝ nil） */
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
