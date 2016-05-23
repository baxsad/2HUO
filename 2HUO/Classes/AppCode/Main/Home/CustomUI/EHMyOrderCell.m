//
//  EHMyOrderCell.m
//  2HUO
//
//  Created by iURCoder on 5/18/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHMyOrderCell.h"
#import <YYWebImage/YYWebImage.h>
#import "OrderListModel.h"

@interface EHMyOrderCell ()

@property (nonatomic, weak) IBOutlet UILabel       * goodsPayStatusLable;// 支付状态
@property (nonatomic, weak) IBOutlet UILabel       * goodsTitleLable;// 标题
@property (nonatomic, weak) IBOutlet UILabel       * goodsTotalLable;// 总价
@property (nonatomic, weak) IBOutlet UILabel       * goodsPriceLable;// 单价
@property (nonatomic, weak) IBOutlet UILabel       * shippingCountLable;// 支付状态
@property (nonatomic, weak) IBOutlet UIImageView   * goodsIcon;// 商品图片
@property (nonatomic, weak) IBOutlet UIButton      * LogisticsOrPayButton;// 物流or支付按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidthConstraint;

@property (strong, nonatomic) UIView *topLine;
@property (strong, nonatomic) UIView *bottomLine;

@end

@implementation EHMyOrderCell

- (void)awakeFromNib{
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 55, Screen_Width, 1/ScreenScale)];
    _topLine.backgroundColor = RGBA(242.0, 242.0, 242.0, 1);
    [self addSubview:_topLine];
    
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 155, Screen_Width, 1/ScreenScale)];
    _bottomLine.backgroundColor = RGBA(242.0, 242.0, 242.0, 1);
    [self addSubview:_bottomLine];
    
    self.goodsIcon.clipsToBounds = YES;
    
}


- (void)configModel:(Order *)model
{
    if (model) {
        
        self.goodsPayStatusLable.text = [self statusString:model.status];
        self.goodsTitleLable.text = model.productInfo.title;
        self.goodsPriceLable.text = [NSString stringWithFormat:@"%.2f",model.productInfo.presentPrice].processingPrice;
        self.shippingCountLable.text = model.productInfo.shippingCount !=0 ? [NSString stringWithFormat:@"%.2f",model.productInfo.shippingCount].processingPrice : @"免运费";
        self.goodsTotalLable.text = [NSString stringWithFormat:@"%.2f",model.productInfo.presentPrice+model.productInfo.shippingCount].processingPrice;
        [self.goodsIcon yy_setImageWithURL:[NSURL URLWithString:model.productInfo.images[0]] options:YYWebImageOptionProgressiveBlur];
        
        [self configButton:model.status];
    }
}

- (void)configButton:(NSInteger)status
{
    self.LogisticsOrPayButton.hidden = NO;
    switch (status) {
        case 1001:
        {
            [self.LogisticsOrPayButton setTitle:@"确认订单" forState:UIControlStateNormal];
        }
            break;
            
        case 1002:
        {
            [self.LogisticsOrPayButton setTitle:@"取消订单" forState:UIControlStateNormal];
        }
            break;
            
        case 1003:
        {
            self.LogisticsOrPayButton.hidden = YES;
        }
            break;
            
        case 1004:
        {
            [self.LogisticsOrPayButton setTitle:@"查看订单" forState:UIControlStateNormal];
        }
            break;
            
        case 1005:
        {
            [self.LogisticsOrPayButton setTitle:@"查看进度" forState:UIControlStateNormal];
        }
            break;
            
        case 1006:
        {
            self.LogisticsOrPayButton.hidden = YES;
        }
            break;
            
        default:
            break;
    }
}

- (NSString *)statusString:(NSInteger)status
{
    switch (status) {
        case 1001:
            return @"等待确认";
            break;
            
        case 1002:
            return @"正在交易";
            break;
            
        case 1003:
            return @"已取消";
            break;
            
        case 1004:
            return @"交易完成";
            break;
            
        case 1005:
            return @"售后处理中";
            break;
            
        case 1006:
            return @"超时未处理";
            break;
            
        default:
            break;
    }
    return @"";
}

@end
