//
//  EHTelRegScene.m
//  2HUO
//
//  Created by iURCoder on 5/19/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHTelRegScene.h"
#import "EHSMSCodeScene.h"

@interface EHTelRegScene ()

@property (nonatomic, weak) IBOutlet UITextField * phoneTextField;
@property (nonatomic, weak) IBOutlet UITextField * pwTextField;
@property (nonatomic, weak) IBOutlet UIButton * nextButton;
@property (nonatomic, weak) IBOutlet UIButton * sinaButton;
@property (nonatomic, weak) IBOutlet UIButton * weiChatButton;

@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *passWord;

@end

@implementation EHTelRegScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.title = @"注册";
    
    [self.nextButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        EHSMSCodeScene * scene = [[EHSMSCodeScene alloc] init];
        [GDHUD showUIBlockingIndicator];
        [[AccountCenter shareInstance] getSMSCode:self.phoneNumber complete:^(BOOL success) {
            if (success) {
                [GDHUD showMessage:@"验证码已发送" timeout:1];
                scene.passWord = self.passWord;
                scene.phoneNumber = self.phoneNumber;
                scene.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:scene animated:YES];
            }else{
                [GDHUD showMessage:@"手机好已经注册过了" timeout:1];
            }
        }];
    }];
    
    UITapGestureRecognizer * ger = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)];
    [self.view addGestureRecognizer:ger];
    
    [self.phoneTextField.rac_textSignal subscribeNext:^(id x) {
        self.phoneNumber = self.phoneTextField.text;
        if (_phoneNumber.length == 11 && _passWord.length>=6) {
            self.nextButton.userInteractionEnabled = YES;
            self.nextButton.alpha = 1;
        }else{
            self.nextButton.userInteractionEnabled = NO;
            self.nextButton.alpha = 0.7;
        }
    }];
    
    [self.pwTextField.rac_textSignal subscribeNext:^(id x) {
        self.passWord = self.pwTextField.text;
        if (_phoneNumber.length == 11 && _passWord.length>=6) {
            self.nextButton.userInteractionEnabled = YES;
            self.nextButton.alpha = 1;
        }else{
            self.nextButton.userInteractionEnabled = NO;
            self.nextButton.alpha = 0.7;
        }
    }];
    
    [self.phoneTextField becomeFirstResponder];
    
    
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
