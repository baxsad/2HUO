//
//  EHPostDetailCell.m
//  2HUO
//
//  Created by iURCoder on 5/10/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHPostDetailCell.h"
#import "Post.h"
#import <YYWebImage/YYWebImage.h>

@interface EHPostDetailCell ()

@property (nonatomic, weak) IBOutlet UIImageView * userIcon;
@property (nonatomic, weak) IBOutlet UILabel * userName;
@property (nonatomic, weak) IBOutlet UILabel * date;
@property (nonatomic, weak) IBOutlet UILabel * price;
@property (nonatomic, weak) IBOutlet UILabel * orzPrice;
@property (nonatomic, weak) IBOutlet UILabel * location;
@property (nonatomic, weak) IBOutlet UILabel * des;
@property (nonatomic, weak) IBOutlet UILabel * school;
@property (nonatomic, weak) IBOutlet UILabel * likeCount;

@end

@implementation EHPostDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _school.layer.cornerRadius = 2;
    _school.layer.masksToBounds = YES;
    _likeCount.layer.cornerRadius = 2;
    _likeCount.layer.masksToBounds = YES;
    _userIcon.layer.cornerRadius = 35.0/2.0;
    _userIcon.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configModel:(PostInfo *)model
{
    if (model) {
        [_userIcon yy_setImageWithURL:[NSURL URLWithString:model.user.avatar] options:YYWebImageOptionProgressiveBlur];
        _userName.text = model.user.nick;
        _date.text = [NSString stringWithFormat:@"%li",model.createTime].timeAgo;
        _price.text = [NSString stringWithFormat:@"¥%.2f",model.presentPrice];
        _orzPrice.text = [NSString stringWithFormat:@"¥%.2f",model.originalPrice];
        _des.text = model.content;
        _location.text = [NSString stringWithFormat:@"%@ %@",model.school.province,model.school.city];
        _school.text = [NSString stringWithFormat:@" %@ ",model.school.name];
        _likeCount.text = [NSString stringWithFormat:@" %li人喜欢 ",model.likeCount];
    }
}

@end
