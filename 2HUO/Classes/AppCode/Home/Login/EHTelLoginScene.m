//
//  EHTelLoginScene.m
//  2HUO
//
//  Created by iURCoder on 5/6/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHTelLoginScene.h"
#import "WXApi.h"
#import "EHTelRegScene.h"

@interface EHTelLoginScene ()

@property (weak, nonatomic) IBOutlet UIButton *dismissBtn;
@property (weak, nonatomic) IBOutlet UITextField *telephoneField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UIButton *WeiboSignIn;
@property (weak, nonatomic) IBOutlet UIButton *WeixinSignIn;

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *passWord;

@end

@implementation EHTelLoginScene


- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    [self showBarButton:NAV_RIGHT title:@"注册" fontColor:TEMCOLOR];
    
    if (![WXApi isWXAppInstalled]) {
        self.WeixinSignIn.hidden = YES;
    }else{
        self.WeixinSignIn.hidden = NO;
        
    }
    
    UITapGestureRecognizer * ger = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)];
    [self.view addGestureRecognizer:ger];
    
    self.title = @"登录";
    
    self.dismissBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input){
        [self dismissViewControllerAnimated:YES completion:nil];
        return [RACSignal empty];
    }];
    
    //登录按钮（用户名和密码都符合规范的时候，才可以点击登录按钮）
    RACSignal* enble = [RACSignal combineLatest:@[ self.telephoneField.rac_textSignal, self.pwdField.rac_textSignal ] reduce:^id(NSString* phoneNum, NSString* password) {
        self.phone = phoneNum;
        self.passWord = password;
        return @(phoneNum.length == 11 && password.length >= 6);
    }];
    
    self.signInBtn.rac_command = [[RACCommand alloc] initWithEnabled:enble signalBlock:^RACSignal*(UIButton* input) {
        
        [[AccountCenter shareInstance] loginWithParams:@{@"phone":self.phone,@"pw":self.passWord} complete:^(BOOL success) {
            if (success) {
                [self dismissViewControllerAnimated:YES completion:^{
                    if (self.LoginSuccessBlock) {
                        self.LoginSuccessBlock();
                    }
                }];
            }else
            {
                [GDHUD showMessage:@"登录失败" timeout:1];
            }
            
        }];
        
        return [RACSignal empty];
    }];
    
    //微博登录
    [self.WeiboSignIn setBackgroundImage:[UIImage imageNamed:@"btn-shadow"] forState:UIControlStateNormal];
    self.WeiboSignIn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        return [RACSignal empty];
    }];
    
    
    //微信登录
    [self.WeixinSignIn setBackgroundImage:[UIImage imageNamed:@"btn-shadow"] forState:UIControlStateNormal];
    self.WeixinSignIn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        return [RACSignal empty];
    }];
    
    [self.telephoneField becomeFirstResponder];
    
}

- (void)closeKeyBoard
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
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

- (void)rightButtonTouch
{
    EHTelRegScene * reg = [[EHTelRegScene alloc] init];
    reg.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:reg animated:YES];
}

@end
