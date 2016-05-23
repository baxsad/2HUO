//
//  EHOrderInfoCell.m
//  2HUO
//
//  Created by iURCoder on 5/17/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHOrderInfoCell.h"
#import "OrderModel.h"
#import <YYWebImage/YYWebImage.h>

@interface EHOrderInfoCell ()

@property (nonatomic, weak) IBOutlet UIImageView * productImage;
@property (nonatomic, weak) IBOutlet UILabel * titleLable;
@property (nonatomic, weak) IBOutlet UILabel * contentLable;

@property (nonatomic, weak) IBOutlet UIView * transModelView;
@property (nonatomic, weak) IBOutlet UIView * salerView;
@property (nonatomic, weak) IBOutlet UIView * priceView;
@property (nonatomic, weak) IBOutlet UIView * shippingView;

@property (nonatomic, weak) IBOutlet UILabel * transModelLable;
@property (nonatomic, weak) IBOutlet UIImageView * salerImage;
@property (nonatomic, weak) IBOutlet UILabel * priceLable;
@property (nonatomic, weak) IBOutlet UILabel * shippingLable;
@property (nonatomic, weak) IBOutlet UILabel * totalLable;
@property (nonatomic, weak) IBOutlet UILabel * orgLable;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint * transModelLayout;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * salerLayout;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * priceLayout;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * shippingLayout;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint * line1Layout;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * line2Layout;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * line3Layout;

@property (nonatomic, strong) ProductInfo * model;

@end

@implementation EHOrderInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.transModelView.clipsToBounds = YES;
    self.salerView.clipsToBounds = YES;
    self.priceView.clipsToBounds = YES;
    self.shippingView.clipsToBounds = YES;
    self.productImage.clipsToBounds = YES;
    self.salerImage.clipsToBounds = YES;
    self.salerImage.layer.cornerRadius = 25.0/2.0;
    self.salerImage.layer.masksToBounds = YES;
    
    self.line1Layout.constant = 1.0/ScreenScale;
    self.line2Layout.constant = 1.0/ScreenScale;
    self.line3Layout.constant = 1.0/ScreenScale;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configModel:(ProductInfo *)model
{
    if (model) {
        _model = model;
        [self layoutWithTransModel:model.transactionMode];
        [self.productImage yy_setImageWithURL:[NSURL URLWithString:model.images[0]] options:YYWebImageOptionProgressiveBlur];
        self.titleLable.text = model.title;
        self.contentLable.text = model.content;
        self.transModelLable.text = [model.transactionMode isEqualToString:@"online"]?@"在线交易":@"线下交易";
        self.priceLable.text = [NSString stringWithFormat:@"%.2f",model.presentPrice].processingPrice;
        self.shippingLable.text = model.shippingCount != 0 ? [NSString stringWithFormat:@"%.2f",model.shippingCount].processingPrice : @"免运费";
        self.totalLable.text = [NSString stringWithFormat:@"%.2f",model.presentPrice+model.shippingCount].processingPrice;
        self.orgLable.text = [NSString stringWithFormat:@"原价：%@",[NSString stringWithFormat:@"%.2f",model.originalPrice].processingPrice];
    }
}

- (void)layoutWithTransModel:(NSString *)transModel
{
    if (transModel.isNotEmpty) {
        if ([transModel isEqualToString:@"online"]) {
            self.salerLayout.constant = 0;
            self.priceLayout.constant = 40;
            self.shippingLayout.constant = 40;
        }
        if ([transModel isEqualToString:@"outline"]) {
            self.salerLayout.constant = 40;
            self.priceLayout.constant = 0;
            self.shippingLayout.constant = 0;
            [self.salerImage yy_setImageWithURL:[NSURL URLWithString:self.model.images[0]] options:YYWebImageOptionProgressiveBlur];
        }
    }
}


@end
