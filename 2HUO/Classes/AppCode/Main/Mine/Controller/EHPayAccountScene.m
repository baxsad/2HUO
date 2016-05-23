//
//  EHPayAccountScene.m
//  2HUO
//
//  Created by iURCoder on 5/22/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHPayAccountScene.h"

@interface EHPayAccountScene ()

@end

@implementation EHPayAccountScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BGCOLOR;
    self.title = @"账户设置";
    
    MFJSettingGroup * groupAlipay = [[MFJSettingGroup alloc] init];
    MFJSettingItem * alipay = [[MFJSettingItem alloc] init];
    alipay.title = @"支付宝";
    alipay.icon = @"alipay";
    alipay.type = MFJSettingItemTypeArrowSubTitle;
    alipay.itemHeight = 50;
    alipay.backGroundColor = UIColorHex(0xffffff);
    alipay.subTitle = USER.alipay ? USER.alipay : @"未设置";
    alipay.selected = ^{
        [[GDRouter sharedInstance] open:@"GD://setPayAccount" extraParams:@{@"alipay":USER.alipay? :@"",@"isAlipay":@(1)}];
    };
    groupAlipay.header = @"账号用来作为交易的收款账号，请认真核对账号信息确保信息正确以免造成不必要的损失，此账户信息只能设置、修改不能删除，发布宝贝之前必须设置了以上的其中任意一种账号！";
    groupAlipay.footer = @"支付宝账号邮箱或者手机号";
    groupAlipay.items = @[alipay];
    
    
    MFJSettingGroup * groupWexin = [[MFJSettingGroup alloc] init];
    
    MFJSettingItem * weixin = [[MFJSettingItem alloc] init];
    weixin.title = @"微信";
    weixin.icon = @"weixin";
    weixin.type = MFJSettingItemTypeArrowSubTitle;
    weixin.itemHeight = 50;
    weixin.backGroundColor = UIColorHex(0xffffff);
    weixin.subTitle = USER.weixin ? USER.weixin : @"未设置";
    weixin.selected = ^{
        [[GDRouter sharedInstance] open:@"GD://setPayAccount" extraParams:@{@"weixin":USER.weixin? :@"",@"isWeixin":@(1)}];
    };
    groupWexin.footer = @"微信帐号";
    groupWexin.items = @[weixin];
    
    
    self.allGroups = @[groupAlipay,groupWexin].mutableCopy;
    
    @weakify(self,alipay);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"UpdateAliPayAccount" object:nil] subscribeNext:^(id x) {
        NSNotification * noti = x;
        [[AccountCenter shareInstance] updateUserInfo:@{@"alipay":noti.object} complete:^(BOOL success) {
            @strongify(self,alipay);
            if (success) {
                FuckYou(@"更新支付宝成功");
                alipay.subTitle = USER.alipay;
                [self reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserInfo" object:nil];
            }
        }];
    }];
    
    @weakify(weixin);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"UpdateWeixinAccount" object:nil] subscribeNext:^(id x) {
        NSNotification * noti = x;
        [[AccountCenter shareInstance] updateUserInfo:@{@"weixin":noti.object} complete:^(BOOL success) {
            @strongify(self,weixin);
            if (success) {
                FuckYou(@"更新微信成功");
                weixin.subTitle = USER.weixin;
                [self reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserInfo" object:nil];
            }
        }];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
