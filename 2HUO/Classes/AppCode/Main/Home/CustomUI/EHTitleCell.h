//
//  ILTitleCell.h
//  Meifujia_iPhone
//
//  Created by Zongzhu on 15/3/2.
//  Copyright (c) 2015年 ilikelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHTitleCell : UITableViewCell
@property (nonatomic, copy) NSString* contentTitle;

- (void)setTitle:(NSString *)title;
- (void)setTitleColor:(UIColor *)color;
- (void)setTitleFont:(UIFont *)font;
- (void)setContenAlignment:(NSTextAlignment)alignment;
- (void)setLeftMarginWith:(CGFloat)margin;


@end
