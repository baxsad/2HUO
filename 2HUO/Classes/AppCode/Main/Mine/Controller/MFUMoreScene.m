//
//  MFUMoreScene.m
//  2HUO
//
//  Created by iURCoder on 3/23/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFUMoreScene.h"

@implementation MFUMoreScene

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.第0组：3个
    [self add0SectionItems];
    
    
}

#pragma mark 添加第0组的模型数据
- (void)add0SectionItems
{
    __weak typeof(self) weakSelf = self;
    // 1.1.推送和提醒
    MFJSettingItem *push = [MFJSettingItem itemWithIcon:@"wallhaven" title:@"first" subTitle:@"" type:MFJSettingItemTypeArrow];
    //cell点击事件
    push.selected = ^{
        UIViewController *helpVC = [[UIViewController alloc] init];
        helpVC.view.backgroundColor = [UIColor grayColor];
        helpVC.title = @"帮助";
        helpVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:helpVC animated:YES];
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
        UIViewController *helpVC = [[UIViewController alloc] init];
        helpVC.view.backgroundColor = [UIColor grayColor];
        helpVC.title = @"帮助";
        helpVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:helpVC animated:YES];
    };
    
    MFJSettingGroup *group = [[MFJSettingGroup alloc] init];
    group.header = @"基本设置";
    group.footer = @"Stack Overflow is a community of 4.7 million programmers, just like you, helping each other. Join them; it only takes a minute: Sign up Join";
    group.items = @[push, shake,hehe,ff];
    [self.allGroups addObject:group];
}


@end

