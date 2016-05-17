//
//  EHAddressCell.m
//  2HUO
//
//  Created by iURCoder on 5/6/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHAddressCell.h"
#import "SellerModel.h"
#import "School.h"

@interface EHAddressCell ()

@property (nonatomic, weak) IBOutlet UILabel *nameLable;
@property (nonatomic, weak) IBOutlet UILabel *addressLable;
@property (nonatomic, strong) UIView *separateLine;
@property (weak, nonatomic) IBOutlet UILabel *telephoneNum;

@property (weak, nonatomic) IBOutlet UIImageView *selectImage;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (nonatomic, strong) SellerModel * model;

@end

@implementation EHAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _separateLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 1/ScreenScale)];
    _separateLine.backgroundColor = UIColorHex(0xf2f2f2);
    [self.selectButton addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_separateLine];
    
    self.selectImage.layer.cornerRadius = 10;
    self.selectImage.layer.masksToBounds = YES;
}

- (void)selectAction
{
    if (self.selectCallBack) {
        self.selectCallBack(self.model,(int)self.model.aid,self.model.defaultAddress);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadAddressInfo:(SellerModel *)model
{
    _model = model;
    self.nameLable.text = model.userName;
    self.addressLable.text = [NSString stringWithFormat:@"%@ %@",model.school.name,model.location];
    self.telephoneNum.text = model.phone;
    if (model.defaultAddress) {
        self.selectImage.backgroundColor = UIColorHex(0xff5a5f);
    }else{
        self.selectImage.backgroundColor = UIColorHex(0xf2f2f2);
    }
}

@end
