//
//  identityCardCell.m
//  Meifujia_iPhone
//
//  Created by iURCoder on 1/8/16.
//  Copyright © 2016 ilikelabs. All rights reserved.
//

#import "identityCardCell.h"

@interface identityCardCell ()<UITextFieldDelegate>



@end

@implementation identityCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.delegate = self;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return YES;
}
@end
