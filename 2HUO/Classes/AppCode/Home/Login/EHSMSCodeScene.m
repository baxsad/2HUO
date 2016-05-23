//
//  EHSMSCodeScene.m
//  2HUO
//
//  Created by iURCoder on 5/20/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHSMSCodeScene.h"

@interface EHSMSCodeScene ()

@property (nonatomic, weak) IBOutlet UITextField * codeTextField;
@property (nonatomic, weak) IBOutlet UIButton * nextButton;

@property (nonatomic, copy) NSString * codeNumber;

@end

@implementation EHSMSCodeScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.title = @"验证码";
    
    UITapGestureRecognizer * ger = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)];
    [self.view addGestureRecognizer:ger];
    
    [self.codeTextField becomeFirstResponder];
    [self.codeTextField.rac_textSignal subscribeNext:^(id x) {
        self.codeNumber = self.codeTextField.text;
        if (_phoneNumber.length == 11 && _passWord.length>=6) {
            self.nextButton.userInteractionEnabled = YES;
            self.nextButton.alpha = 1;
        }else{
            self.nextButton.userInteractionEnabled = NO;
            self.nextButton.alpha = 0.7;
        }
    }];
    
    [self.nextButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        [GDHUD showUIBlockingIndicator];
        [[AccountCenter shareInstance] regWithParams:@{@"code":self.codeNumber,@"phone":self.phoneNumber,@"pw":self.passWord} complete:^(BOOL success) {
            if (success) {
                [GDHUD showMessage:@"注册成功" timeout:1];
            }else{
                [GDHUD showMessage:@"注册失败" timeout:1];
            }
        }];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeKeyBoard
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

@end
