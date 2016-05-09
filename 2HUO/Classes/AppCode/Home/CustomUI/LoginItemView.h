//
//  LoginItemView.h
//  Meifujia_iPhone
//
//  Created by Zongzhu on 15/8/3.
//  Copyright (c) 2015年 ilikelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginItemView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, copy) void (^login)();
+ (instancetype)nib;
@end
