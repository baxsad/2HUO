//
//  EHCommentCell.m
//  2HUO
//
//  Created by iURCoder on 5/10/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHCommentCell.h"
#import "Comments.h"
#import <YYWebImage/YYWebImage.h>

@interface EHCommentCell ()

@property (nonatomic, weak) IBOutlet UIImageView * userIcon;
@property (nonatomic, weak) IBOutlet UILabel     * userName;
@property (nonatomic, weak) IBOutlet UILabel     * date;
@property (nonatomic, weak) IBOutlet UILabel     * content;
@property (nonatomic, weak) IBOutlet UILabel     * biddingPrice;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint     * bottomLineHeight;


@end

@implementation EHCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _userIcon.layer.cornerRadius = 25.0/2.0;
    _userIcon.layer.masksToBounds = YES;
    _bottomLineHeight.constant = 1.0/ScreenScale;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configModel:(Comment *)model
{
    if (model) {
        [_userIcon yy_setImageWithURL:[NSURL URLWithString:model.user.avatar] options:YYWebImageOptionProgressiveBlur];
        _userName.text = model.user.nick;
        _date.text = model.createdTime.timeAgo;
        NSString * content;
        if (model.atUser.isNotEmpty) {
            content = [NSString stringWithFormat:@"@%@ %@",model.atUser,model.content];
        }else{
            content = [NSString stringWithFormat:@"%@",model.content];
        }
        _content.text = content;
        if (model.biddingPrice !=0 ) {
            _biddingPrice.text = [NSString stringWithFormat:@"出价：¥%.2f",model.biddingPrice];
        }
        else
        {
            _biddingPrice.text = @"";
        }
    }
}

@end
