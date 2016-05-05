//
//  ILOrderTextViewCell.m
//  Meifujia_iPhone
//
//  Created by Zongzhu on 15/10/21.
//  Copyright © 2015年 ilikelabs. All rights reserved.
//

#import "EHTextViewCell.h"

@interface EHTextViewCell ()

@end

@implementation EHTextViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
}
- (void)bindSignal:(RACSubject *)signal{
    NSParameterAssert(signal != nil);
    [[self.textView.rac_textSignal takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        [signal sendNext:x];
    }];
}
@end
