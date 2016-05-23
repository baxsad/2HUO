//
//  EHUpdateUserDesScene.m
//  2HUO
//
//  Created by iURCoder on 5/13/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHUpdateUserDesScene.h"
#import "MFJTextView.h"

@interface EHUpdateUserDesScene ()

@property (nonatomic, strong) MFJTextView *textView;

@end

@implementation EHUpdateUserDesScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.view.backgroundColor = BGCOLOR;
    
    self.title = @"简介";
    self.view.backgroundColor = BGCOLOR;
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:TEMCOLOR forState:UIControlStateNormal];
    [saveBtn setTitleColor:TEMCOLOR forState:UIControlStateDisabled];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [saveBtn sizeToFit];
    [self showBarButton:NAV_RIGHT button:saveBtn];
    
    UIView * bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColorHex(0xffffff);
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(25);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.equalTo(@120);
    }];
    
    self.textView = [[MFJTextView alloc] init];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.textColor = UIColorHex(0x515151);
    self.textView.placeholder = @"请描述下你自己～";
    self.textView.text = USER.desc;
    
    [bgView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightButtonTouch
{
    if (_textView.text.length == 0 || _textView.text.length>37) {
        [GDHUD showMessage:@"字数不能为空，且不能超过37个字" timeout:1];
        return;
    }
    if ([USER.desc isEqualToString:_textView.text]) {
        [[GDRouter sharedInstance] pop];
    }else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserDesc" object:self.textView.text];
        [[GDRouter sharedInstance] pop];
    }
    
}

@end
