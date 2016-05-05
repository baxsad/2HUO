//
//  ILTitleCell.m
//  Meifujia_iPhone
//
//  Created by Zongzhu on 15/3/2.
//  Copyright (c) 2015年 ilikelabs. All rights reserved.
//

#import "EHTitleCell.h"

@interface EHTitleCell ()

@property (nonatomic, strong) UIView * bottomLine;
@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;

@end

@implementation EHTitleCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(15, 49 - 1/ScreenScale, Screen_Width, 1/ScreenScale)];
    _bottomLine.backgroundColor = RGBA(242.0, 242.0, 242.0, 1);
    [self addSubview:_bottomLine];
}
- (void)setTitle:(NSString*)title
{
    self.contentTitle = title;
    self.titleLabel.text = title;
}
- (void)setTitleColor:(UIColor *)color{
    [self.titleLabel setTextColor:color];
}
- (void)setTitleFont:(UIFont *)font{
    self.titleLabel.font = font;
}
- (void)setContenAlignment:(NSTextAlignment)alignment{
    self.titleLabel.textAlignment = alignment;
    [self layoutIfNeeded];
}
- (void)setLeftMarginWith:(CGFloat)margin{
    self.leftMargin.constant = margin;
    [self layoutIfNeeded];
}





@end
