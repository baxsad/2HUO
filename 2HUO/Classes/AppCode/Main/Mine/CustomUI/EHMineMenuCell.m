//
//  EHMineMenuCell.m
//  2HUO
//
//  Created by iURCoder on 5/3/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHMineMenuCell.h"


@interface EHMineMenuCell ()

@property (nonatomic, weak) IBOutlet UILabel *detailLable;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomline;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomlineLayout;

@end

@implementation EHMineMenuCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.detailLable.hidden = YES;
    self.titleLabel.textColor = UIColorHex(0x333333);
    self.bottomlineLayout.constant = 1.0/ScreenScale;
}

- (void)setIsLast:(BOOL)isLast
{
    _isLast = isLast;
    self.bottomline.hidden = isLast;
}

- (void)setTitle:(NSString *)title{
    _title = [title copy];
    self.titleLabel.text = title;
    
}

- (void)configWithDic:(NSDictionary *)dic{
    self.title = [dic objectForKey:@"title"];
    self.iconView.image = [UIImage imageNamed:[dic objectForKey:@"icon"]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
