//
//  MFUMoreScene.m
//  2HUO
//
//  Created by iURCoder on 3/23/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFUMoreScene.h"
#import "AccountCenter.h"


@implementation MFUMoreScene

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.第0组：3个
    [self add0SectionItems];
//    [[AccountCenter shareInstance] logoutWithType:UMSocialSnsTypeSina];
    
}

#pragma mark 添加第0组的模型数据
- (void)add0SectionItems
{
    __weak typeof(self) weakSelf = self;
    // 1.1.推送和提醒
    MFJSettingItem *push = [MFJSettingItem itemWithIcon:@"wallhaven" title:@"first" subTitle:@"" type:MFJSettingItemTypeArrow];
    //cell点击事件
    push.selected = ^{
        [[AccountCenter shareInstance] logoutWithType:UMSocialSnsTypeWechatSession complete:^(BOOL success) {
            if (success) {
                [O2HUD showMessage:@"退出成功" timeout:1];
            }else{
                [O2HUD showMessage:@"退出失败" timeout:1];
            }
        }];
    };
    
    // 1.2.声音提示
    MFJSettingItem *shake = [MFJSettingItem itemWithIcon:@"" title:@"two" subTitle:@"" type:MFJSettingItemTypeSwitch];
    
    //开关事件
    shake.switchBlock = ^(BOOL on) {
        NSLog(@"声音提示%zd",on);
    };
    
    // 1.2.声音提示
    MFJSettingItem *hehe = [MFJSettingItem itemWithIcon:@"sound_Effect" title:@"three" subTitle:@"ddd" type:MFJSettingItemTypeArrowSubTitle];
    
    // 1.1.推送和提醒
    MFJSettingItem *ff = [MFJSettingItem itemWithIcon:@"" title:@"ff" subTitle:@"" type:MFJSettingItemTypeNone];
    //cell点击事件
    ff.selected = ^{
        
        if (ISLOGIN) {
            [O2HUD showMessage:@"已经登陆" timeout:1];
            NSLog(@"%@",[AccountCenter shareInstance].user);
            return ;
        }
        
        [[AccountCenter shareInstance] loginWithType:UMSocialSnsTypeWechatSession viewController:self data:^(BOOL success, User * user) {
            if (success && user) {
                [[AccountCenter shareInstance] save:user];
            }
        }];
    };
    
    MFJSettingGroup *group = [[MFJSettingGroup alloc] init];
    group.header = @"基本设置";
    group.footer = @"Stack Overflow is a community of 4.7 million programmers, just like you, helping each other. Join them; it only takes a minute: Sign up Join";
    group.items = @[push, shake,hehe,ff];
    [self.allGroups addObject:group];
}


@end

