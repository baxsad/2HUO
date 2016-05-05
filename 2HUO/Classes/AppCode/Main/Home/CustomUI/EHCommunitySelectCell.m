//
//  EHCommunitySelectCell.m
//  2HUO
//
//  Created by iURCoder on 5/4/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHCommunitySelectCell.h"
#import "Communitys.h"

@interface EHCommunitySelectCell ()

@property (nonatomic, weak) IBOutlet UILabel * name;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomLineHeight;

@end

@implementation EHCommunitySelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bottomLineHeight.constant = 1.0/ScreenScale;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configModel:(Community *)model
{
    if (model) {
        self.name.text = model.c_name;
    }
}

@end
