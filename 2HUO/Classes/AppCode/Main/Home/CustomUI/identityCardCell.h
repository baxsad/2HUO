//
//  identityCardCell.h
//  Meifujia_iPhone
//
//  Created by iURCoder on 1/8/16.
//  Copyright © 2016 ilikelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface identityCardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (copy, nonatomic) NSString *placeholder;
@property (copy, nonatomic) NSString *text;
- (void)bindSignal:(RACSubject *)signal;
- (void)setKeyBoardType:(UIKeyboardType)type;

@end
