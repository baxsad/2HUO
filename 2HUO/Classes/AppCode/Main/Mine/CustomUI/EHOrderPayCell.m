//
//  EHOrderPayCell.m
//  2HUO
//
//  Created by iURCoder on 5/22/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHOrderPayCell.h"

@interface EHOrderPayCell ()

@property (nonatomic, weak) IBOutlet UIImageView * icon;
@property (nonatomic, weak) IBOutlet UILabel * title;
@property (nonatomic, weak) IBOutlet UIImageView * selectIcon;

@end

@implementation EHOrderPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setIsSelect:(BOOL)isSelect
{
    
    _isSelect = isSelect;
    if (isSelect) {
        [self.selectIcon setImage:[UIImage imageNamed:@"payselected"]];
    }else{
        [self.selectIcon setImage:[UIImage imageNamed:@"payselect"]];
    }
}

- (void)configModel:(NSString *)model
{
    if ([model isEqualToString:@"alipay"]) {
        [self.icon setImage:[UIImage imageNamed:@"alipay"]];
        self.title.text = @"支付宝";
    }
    if ([model isEqualToString:@"weixin"]) {
        [self.icon setImage:[UIImage imageNamed:@"weixin"]];
        self.title.text = @"微信";
    }
}

@end
