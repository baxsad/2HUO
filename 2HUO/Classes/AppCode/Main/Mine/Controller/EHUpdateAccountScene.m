//
//  ILUpdateUserNickScene.m
//  Meifujia_iPhone
//
//  Created by Zongzhu on 15/3/14.
//  Copyright (c) 2015年 ilikelabs. All rights reserved.
//

#import "EHUpdateAccountScene.h"

@interface EHUpdateAccountScene () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *accountField;

@end

@implementation EHUpdateAccountScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    if (self.isAlipay) {
        self.title = @"支付宝";
    }
    if (self.isWeixin) {
        self.title = @"微信";
    }else{
        self.title = @"账户";
    }
    
    self.view.backgroundColor = BGCOLOR;
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:TEMCOLOR forState:UIControlStateNormal];
    [saveBtn setTitleColor:TEMCOLOR forState:UIControlStateDisabled];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [saveBtn sizeToFit];
    [self showBarButton:NAV_RIGHT button:saveBtn];
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(25);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.equalTo(@45);
    }];
    
    self.accountField = [[UITextField alloc] init];
    self.accountField.delegate = self;
    [self.accountField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.accountField];
    if (self.alipay.isNotEmpty) {
        self.accountField.text = self.alipay;
    }
    if (self.weixin.isNotEmpty) {
        self.accountField.text = self.weixin;
    }else{
        self.accountField.text = @"";
    }
    self.accountField.font = [UIFont systemFontOfSize:15];
    self.accountField.textColor = UIColorHex(0x515151);
    self.accountField.borderStyle = UITextBorderStyleNone;
    if (self.alipay.isNotEmpty) {
        self.accountField.placeholder = self.alipay;
    }
    if (self.weixin.isNotEmpty) {
        self.accountField.placeholder = self.weixin;
    }else{
        self.accountField.placeholder = @"请输入账号信息";
    }
    [self.accountField becomeFirstResponder];
    
    [self.accountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundView.mas_left).offset(10);
        make.bottom.equalTo(backgroundView.mas_bottom).offset(-10);
        make.right.equalTo(backgroundView.mas_right).offset(-10);
        make.top.equalTo(backgroundView.mas_top).offset(10);
        
    }];
    
    RAC(saveBtn,enabled) = [self.accountField.rac_textSignal map:^id(NSString* value) {
        return @(value.length > 0);
    }];
}
- (void)rightButtonTouch{
    if (self.accountField.text != self.alipay || self.accountField.text != self.weixin) {
        if (self.isAlipay) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateAliPayAccount" object:self.accountField.text];
        }
        if (self.weixin) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateWeixinAccount" object:self.accountField.text];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (textField == self.accountField) {
        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:10];
        }
    }
}
@end
