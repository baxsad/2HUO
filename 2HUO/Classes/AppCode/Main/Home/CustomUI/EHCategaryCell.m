//
//  EHCategaryCell.m
//  2HUO
//
//  Created by iURCoder on 5/12/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHCategaryCell.h"

@interface EHCategaryCell ()

@end

@implementation EHCategaryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
