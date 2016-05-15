//
//  ILUpdateUserNickScene.m
//  Meifujia_iPhone
//
//  Created by Zongzhu on 15/3/14.
//  Copyright (c) 2015年 ilikelabs. All rights reserved.
//

#import "EHUpdateUserNickScene.h"

@interface EHUpdateUserNickScene () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *nickField;

@end

@implementation EHUpdateUserNickScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.title = @"昵称";
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
    
    self.nickField = [[UITextField alloc] init];
    self.nickField.delegate = self;
    [self.nickField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.nickField];
    self.nickField.text = USER.nick;
    self.nickField.font = [UIFont systemFontOfSize:15];
    self.nickField.textColor = UIColorHex(0x515151);
    self.nickField.borderStyle = UITextBorderStyleNone;
    self.nickField.placeholder = @"请输入新的昵称";
    [self.nickField becomeFirstResponder];
    
    [self.nickField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundView.mas_left).offset(10);
        make.bottom.equalTo(backgroundView.mas_bottom).offset(-10);
        make.right.equalTo(backgroundView.mas_right).offset(-10);
        make.top.equalTo(backgroundView.mas_top).offset(10);

    }];
    
    RAC(saveBtn,enabled) = [self.nickField.rac_textSignal map:^id(NSString* value) {
        return @(value.length > 0);
    }];
}
- (void)rightButtonTouch{
    if (self.nickField.text != USER.nick) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserNick" object:self.nickField.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (textField == self.nickField) {
        if (textField.text.length > 10) {
            textField.text = [textField.text substringToIndex:10];
        }
    }
}
@end
