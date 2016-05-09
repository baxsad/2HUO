//
//  EHSignScene.m
//  2HUO
//
//  Created by iURCoder on 5/6/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHSignScene.h"

#import "RZTransitionInteractionControllerProtocol.h"
#import "RZTransitionsInteractionControllers.h"
#import "RZTransitionsAnimationControllers.h"
#import "RZRectZoomAnimationController.h"
#import "RZTransitionsManager.h"

#import "LoginItemView.h"
#import "WXApi.h"
#import "AccountCenter.h"

#import "EHTelLoginScene.h"
#import "IHNavigationController.h"

@interface EHSignScene ()

@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *dismissBtn;
@property (weak, nonatomic) IBOutlet UILabel *illustrateLabel;

@property (weak, nonatomic) LoginItemView *wechatView;
@property (weak, nonatomic) LoginItemView *weiboView;
@property (weak, nonatomic) LoginItemView *telView;

@end

@implementation EHSignScene

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = NAVCOLOR;
    
    
    self.dismissBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        if (self.signStatus) {
            self.signStatus(NO);
        }
        if (self.dissMiss) {
            self.dissMiss(NO);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        return [RACSignal empty];
    }];
    
    if ([WXApi isWXAppInstalled]) {
        [self.view addSubview:self.wechatView];
        [self.view addSubview:self.weiboView];
        [self.view addSubview:self.telView];
        
        [self.wechatView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_trailing).multipliedBy(1/5.0);
            make.top.equalTo(self.illustrateLabel).offset(140);
            
        }];
        [self.weiboView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_trailing).multipliedBy(1/2.0);
            make.top.equalTo(self.illustrateLabel).offset(140);
            
        }];
        [self.telView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_trailing).multipliedBy(4/5.0);
            make.top.equalTo(self.illustrateLabel).offset(140);
            
            
        }];
        
    }else{
        [self.view addSubview:self.weiboView];
        [self.view addSubview:self.telView];
        [self.weiboView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_trailing).multipliedBy(1/3.0);
            make.top.equalTo(self.illustrateLabel).offset(140);
            
            
        }];
        [self.telView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_trailing).multipliedBy(2/3.0);
            make.top.equalTo(self.illustrateLabel).offset(140);
            
        }];
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (LoginItemView *)weiboView{
    if (!_weiboView) {
        _weiboView = [LoginItemView nib];
        _weiboView.iconView.image = [UIImage imageNamed:@"login_weibo"];
        _weiboView.titleLabel.text = @"微博";
        _weiboView.backgroundColor = NAVCOLOR;
        _weiboView.login = ^{
            [[AccountCenter shareInstance] login:UMSocialSnsTypeSina viewController:self complete:^(BOOL success) {
                if (success) {
                    if (self.dissMiss) {
                        self.dissMiss(success);
                    }
                    [self dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [GDHUD showMessage:@"登录失败" timeout:1];
                }
            }];
        };
    }
    return _weiboView;
}
- (LoginItemView *)telView{
    if (!_telView) {
        _telView = [LoginItemView nib];
        _telView.iconView.image = [UIImage imageNamed:@"login_phone"];
        _telView.titleLabel.text = @"手机登录";
        _telView.backgroundColor = NAVCOLOR;
        _telView.login = ^{
            EHTelLoginScene * telLogin = [[EHTelLoginScene alloc] init];
            IHNavigationController * nav = [[IHNavigationController alloc] initWithRootViewController:telLogin];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        };
    }
    return _telView;
}
- (LoginItemView *)wechatView{
    if (!_wechatView) {
        _wechatView = [LoginItemView nib];
        _wechatView.iconView.image = [UIImage imageNamed:@"login_wechat"];
        _wechatView.titleLabel.text = @"微信";
        _wechatView.backgroundColor = NAVCOLOR;
        _wechatView.login = ^{
            
            [[AccountCenter shareInstance] login:UMSocialSnsTypeWechatSession viewController:self complete:^(BOOL success) {
                if (success) {
                    if (self.dissMiss) {
                        self.dissMiss(success);
                    }
                    [self dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [GDHUD showMessage:@"登录失败" timeout:1];
                }
            }];
            
        };
    }
    return _wechatView;
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
