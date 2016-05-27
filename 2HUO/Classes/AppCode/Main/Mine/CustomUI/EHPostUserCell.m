//
//  EHPostUserCell.m
//  2HUO
//
//  Created by iURCoder on 5/24/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHPostUserCell.h"
#import "User.h"
#import <YYWebImage/YYWebImage.h>

@interface EHPostUserCell ()

@property (nonatomic, weak) IBOutlet UIImageView * userIcon;
@property (nonatomic, weak) IBOutlet UILabel * userNick;

@end

@implementation EHPostUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configModel:(User *)model
{
    if (model) {
        [self.userIcon yy_setImageWithURL:[NSURL URLWithString:model.avatar] options:YYWebImageOptionProgressiveBlur];
        self.userNick.text = model.nick;
    }
}

@end
