//
//  EHOrderNumberCellTableViewCell.m
//  2HUO
//
//  Created by iURCoder on 5/20/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHOrderNumberCell.h"
#import "OrderModel.h"

@interface EHOrderNumberCell ()

@property (nonatomic, weak) IBOutlet UILabel *orderIdLable;
@property (nonatomic, weak) IBOutlet UILabel *orderCreatedTimeLable;

@end

@implementation EHOrderNumberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadOrderNumber:(OrderModel *)model
{
    self.orderIdLable.text = model.orderNumber;
    self.orderCreatedTimeLable.text = model.createdTime.timeInvalueToDateString;
}

@end
