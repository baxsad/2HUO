//
//  NSMutableAttributedString+HYSCat.h
//  2HUO
//
//  Created by iURCoder on 4/26/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (HYSCat)
- (void)setAttributedWithFont:(UIFont *)font range:(NSRange)range;
- (void)setAttributedWithColor:(UIColor *)color range:(NSRange)range;
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string font:(UIFont*)font LineSpacing:(CGFloat)spacing fontColor:(UIColor *)color;
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string font:(UIFont *)font LineSpacing:(CGFloat)spacing alignment:(NSTextAlignment)alignment fontColor:(UIColor *)color;
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string font:(UIFont*)font LineSpacing:(CGFloat)spacing fontColor:(UIColor *)color lineBreakMode:(NSLineBreakMode)lineBreakMode;
+ (NSArray *)getSeparatedLinesWithFrame:(CGRect)rect Font:(UIFont *)font text:(NSString *)text attStr:(NSMutableAttributedString *)attStr;
- (int)getAttributedStringHeightWidthValue:(int)width maxLine:(int)line;
@end
