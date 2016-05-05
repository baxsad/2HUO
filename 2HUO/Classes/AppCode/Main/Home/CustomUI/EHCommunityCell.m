//
//  EHCommunityCell.m
//  2HUO
//
//  Created by iURCoder on 4/26/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHCommunityCell.h"
#import "Communitys.h"
#import <YYWebImage/YYWebImage.h>

@interface EHCommunityCell ()

@property (nonatomic, weak) IBOutlet UIImageView * icon;
@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *des;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomLineHeight;

@end

@implementation EHCommunityCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bottomLineHeight.constant = 1.0/ScreenScale;
}

- (void)configModel:(Community *)model
{
    if (model) {
        [self.icon yy_setImageWithURL:[NSURL URLWithString:model.c_icon] options:YYWebImageOptionProgressiveBlur];
        self.name.text = model.c_name;
        self.des.text = model.c_des;
    }
}

@end
