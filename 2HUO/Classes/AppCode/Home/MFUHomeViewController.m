//
//  2HHomeViewController.m
//  2HUO
//
//  Created by iURCoder on 3/15/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFUHomeViewController.h"
#import "IHNavigationController.h"

#import "MFULocationScene.h"
#import "MFUMoreScene.h"
#import "MFUHomeScene.h"


@interface MFUHomeViewController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) UIView * colorFullView;

@end

@implementation MFUHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.tabBar.translucent = NO;
    self.selectedIndex = 0;
    self.tabBar.backgroundImage = [[UIImage alloc] init];
    [[UITextField appearance] setTintColor:UIColorHex(0xffb6b6)];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    [self addAllChildViewControllers];
    
    self.colorFullView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width/3, self.tabBar.bounds.size.height)];
    self.colorFullView.backgroundColor = [UIColor whiteColor];
    
    [self.tabBar addSubview:self.colorFullView];
    
    [[self class] customizeTabBarAppearance];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSInteger index = self.selectedIndex;
    self.colorFullView.frame = CGRectMake(index*(Screen_Width/3), 0, Screen_Width/3, self.tabBar.bounds.size.height);
}

- (void)addAllChildViewControllers
{
    MFUHomeScene * homeScene = [[MFUHomeScene alloc] init];
    [self addChildViewController:homeScene title:@"Home" image:@"home_normal" selectedImage:@"home_highlight"];
    
    MFULocationScene * locationScene = [[MFULocationScene alloc] init];
    [self addChildViewController:locationScene title:@"Location" image:@"mycity_normal" selectedImage:@"mycity_highlight"];
    
    MFUMoreScene * mineScene = [[MFUMoreScene alloc] init];
    [self addChildViewController:mineScene title:@"Mine" image:@"account_normal" selectedImage:@"account_highlight"];
}


- (void)addChildViewController:(UIViewController *)childController
                         title:(NSString *)title
                         image:(NSString *)normalImageName
                 selectedImage:(NSString *)selectedImageName
{
    childController.tabBarItem.title = title;
    childController.tabBarItem.image = [UIImage imageNamed:normalImageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0) {
        childController.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        childController.tabBarItem.selectedImage = selectedImage;
    }
    
    childController.title = title;
    IHNavigationController *nav = [[IHNavigationController alloc] initWithRootViewController:childController];
    [self addChildViewController:nav];
}

/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性
 */
+ (void)customizeTabBarAppearance {
    
    //去除 TabBar 自带的顶部阴影
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBarTintColor:NAVCOLOR];
    
    UIImage * topLineImage = [UIImage imageWithColor:UIColorHex(0xF9F7F4) size:CGSizeMake(1/ScreenScale, 1/ScreenScale)];
    [[UITabBar appearance] setShadowImage:topLineImage];
    
    
    // 普通状态下的文字属性
    NSDictionary *normalAttrs = @{NSForegroundColorAttributeName: UIColorHex(0x888888)};
    
    // 选中状态下的文字属性
    NSDictionary *selectedAttrs = @{NSForegroundColorAttributeName: UIColorHex(0xD2B203)};//255fff
    
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    [tabBar setTitlePositionAdjustment:UIOffsetMake(2, -2)];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
