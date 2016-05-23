//
//  EHOrderStatusView.m
//  2HUO
//
//  Created by iURCoder on 5/20/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHOrderStatusView.h"

@interface EHOrderStatusView ()

@property (nonatomic, weak) IBOutlet UILabel * orderStatusDesLable;
@property (nonatomic, weak) IBOutlet UILabel * orderPaySurplusTimeLable;
@property (nonatomic, weak) IBOutlet UIView  * TopBgView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * TopBgViewBottom;

@end

@implementation EHOrderStatusView


- (void)reloadTopViewInfoWithTitle:(NSString *)title Des:(NSString *)des
{
    self.TopBgViewBottom.constant = 0;
    self.orderStatusDesLable.text = title;
    if ([des isEqualToString:@""] || des == nil) {
        self.orderPaySurplusTimeLable.text = @"";
        self.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 60);
    }else{
        self.orderPaySurplusTimeLable.text = des;
    }
}

@end
