//
//  LoginItemView.m
//  Meifujia_iPhone
//
//  Created by Zongzhu on 15/8/3.
//  Copyright (c) 2015年 ilikelabs. All rights reserved.
//

#import "LoginItemView.h"

@interface LoginItemView ()

@end
@implementation LoginItemView
+ (instancetype)nib{
    LoginItemView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    return view;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.login) {
        self.login();
    }
}
@end
