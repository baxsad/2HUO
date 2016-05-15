//
//  EHSchoolCell.m
//  2HUO
//
//  Created by iURCoder on 5/5/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHSchoolCell.h"
#import "School.h"

@interface EHSchoolCell ()

@property (nonatomic, weak) IBOutlet UILabel * name;
@property (nonatomic, weak) IBOutlet UILabel * subName;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomLineHeight;

@end

@implementation EHSchoolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bottomLineHeight.constant = 1.0/ScreenScale;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configModel:(School *)model
{
    if (model) {
        self.name.text = model.name;
        self.subName.text = model.campus;
    }
}

@end
