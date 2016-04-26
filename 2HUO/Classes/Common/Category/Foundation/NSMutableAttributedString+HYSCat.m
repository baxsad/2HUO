//
//  NSMutableAttributedString+HYSCat.m
//  2HUO
//
//  Created by iURCoder on 4/26/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "NSMutableAttributedString+HYSCat.h"
#import <CoreText/CoreText.h>
@implementation NSMutableAttributedString (HYSCat)
- (void)setAttributedWithFont:(UIFont *)font range:(NSRange)range{
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    if (fontRef) {
        [self addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:range];
        CFRelease(fontRef);
        
    }
}
- (void)setAttributedWithColor:(UIColor *)color range:(NSRange)range{
    [self addAttribute:NSForegroundColorAttributeName value:color range:range];
}
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string font:(UIFont *)font LineSpacing:(CGFloat)spacing fontColor:(UIColor *)color{
    NSMutableDictionary* att = [NSMutableDictionary dictionary];
    [att setObject:font forKey:NSFontAttributeName];
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:spacing];
    [att setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    if (color) {
        [att setObject:color forKey:NSForegroundColorAttributeName];
    }
    return [[NSMutableAttributedString alloc]initWithString:string attributes:att];
}

+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string font:(UIFont*)font LineSpacing:(CGFloat)spacing fontColor:(UIColor *)color lineBreakMode:(NSLineBreakMode)lineBreakMode{
    NSMutableDictionary* att = [NSMutableDictionary dictionary];
    [att setObject:font forKey:NSFontAttributeName];
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:spacing];
    [paragraphStyle setLineBreakMode:lineBreakMode];
    [att setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    if (color) {
        [att setObject:color forKey:NSForegroundColorAttributeName];
    }
    return [[NSMutableAttributedString alloc]initWithString:string attributes:att];
}

+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string font:(UIFont *)font LineSpacing:(CGFloat)spacing alignment:(NSTextAlignment)alignment fontColor:(UIColor *)color{
    NSMutableDictionary* att = [NSMutableDictionary dictionary];
    [att setObject:font forKey:NSFontAttributeName];
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:spacing];
    [paragraphStyle setAlignment:alignment];
    [att setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [att setObject:color forKey:NSForegroundColorAttributeName];
    return [[NSMutableAttributedString alloc]initWithString:string attributes:att];
}


+ (NSArray *)getSeparatedLinesWithFrame:(CGRect)rect Font:(UIFont *)font text:(NSString *)text attStr:(NSMutableAttributedString *)attStr
{
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    CGPathRelease(path);
    CFRelease(frameSetter);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    
    CFRelease(frame);
    
    return (NSArray *)linesArray;
}
- (int)getAttributedStringHeightWidthValue:(int)width maxLine:(int)line
{
    int total_height = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self);    //string 为要计算高度的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, width, 100000);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    
    if (line > linesArray.count) {
        CFRelease(textFrame);
        return -1;
    }
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[line-1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef lineRef = (__bridge CTLineRef) [linesArray objectAtIndex:line-1];
    CTLineGetTypographicBounds(lineRef, &ascent, &descent, &leading);
    
    total_height = 100000 - line_y + (int) descent +1;//+1为了纠正descent转换成int小数点后舍去的值
    
    CFRelease(textFrame);
    
    return total_height;
    
}

@end
