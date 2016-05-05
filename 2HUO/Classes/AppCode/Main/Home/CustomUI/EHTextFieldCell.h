//
//  ILOrderTextField.h
//  Meifujia_iPhone
//
//  Created by Zongzhu on 15/10/21.
//  Copyright © 2015年 ilikelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHTextFieldCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (copy, nonatomic) NSString *placeholder;
@property (copy, nonatomic) NSString *text;
- (void)bindSignal:(RACSubject *)signal;
- (void)setKeyBoardType:(UIKeyboardType)type;
@end
