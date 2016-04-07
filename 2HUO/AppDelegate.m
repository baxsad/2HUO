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
#import <AVOSCloudSNS/AVOSCloudSNS.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    MFUHomeViewController * home = [[MFUHomeViewController alloc] init];
    self.window.rootViewController = home;
    [self.window makeKeyAndVisible];
    
    [MFJRouter sharedInstance].openException = YES;
    [[MFJRouter sharedInstance] reg];
    
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
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSSinaWeibo withAppKey:@"" andAppSecret:@"" andRedirectURI:@""];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}

@end
