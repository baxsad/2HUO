//
//  ILOrderTextViewCell.h
//  Meifujia_iPhone
//
//  Created by Zongzhu on 15/10/21.
//  Copyright © 2015年 ilikelabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFJTextView.h"
@interface EHTextViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet MFJTextView *textView;

- (void)bindSignal:(RACSubject *)signal;

@end
