//
//  EHOrderAddressCell.m
//  2HUO
//
//  Created by iURCoder on 5/17/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHOrderAddressCell.h"
#import "SellerModel.h"

@interface EHOrderAddressCell ()

@property (nonatomic, weak) IBOutlet UILabel *buyerInfoLable;
@property (nonatomic, weak) IBOutlet UILabel *addressLable;
@property (nonatomic, weak) IBOutlet UIImageView *tableViewArrow;

@end

@implementation EHOrderAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configModel:(SellerModel *)model
{
    if (model && model.phone.length > 0) {
        _buyerInfoLable.text = [NSString stringWithFormat:@"%@ %@",model.userName,model.phone];
        _addressLable.text = [NSString stringWithFormat:@"%@ %@",model.school.name,model.location];
    }else{
        self.buyerInfoLable.text = @"收货地址";
        self.addressLable.text = @"选择您的地址及联系方式";
    }
}

- (void)setArrowHiden:(BOOL)hiden
{
    self.tableViewArrow.hidden = hiden;
}

@end
