//
//  ILOrderTextField.m
//  Meifujia_iPhone
//
//  Created by Zongzhu on 15/10/21.
//  Copyright © 2015年 ilikelabs. All rights reserved.
//

#import "EHTextFieldCell.h"

@interface EHTextFieldCell ()
@property (nonatomic, strong) UIView *bottomLine;

@end
@implementation EHTextFieldCell

- (void)awakeFromNib{
    [super awakeFromNib];
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(15, 49 - 1/ScreenScale, Screen_Width, 1/ScreenScale)];
    _bottomLine.backgroundColor = RGBA(242.0, 242.0, 242.0, 1);
    [self addSubview:_bottomLine];
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = [placeholder copy];
    self.textField.placeholder = _placeholder;
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
    self.textField.text = _text;
    
}
- (void)setKeyBoardType:(UIKeyboardType)type{
    self.textField.keyboardType = type;
}

- (void)bindSignal:(RACSubject *)signal{
    NSParameterAssert(signal != nil);
    [[self.textField.rac_textSignal takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        [signal sendNext:x];
    }];
}
@end
