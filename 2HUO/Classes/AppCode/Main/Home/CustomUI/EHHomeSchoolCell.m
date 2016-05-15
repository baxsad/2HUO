//
//  EHHomeSchoolCell.m
//  2HUO
//
//  Created by iURCoder on 5/11/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHHomeSchoolCell.h"
#import "School.h"
#import <YYWebImage/YYWebImage.h>

@interface EHHomeSchoolCell ()

@property (nonatomic, weak) IBOutlet UIImageView * icon;
@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *des;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomLineHeight;
@property (nonatomic, weak) IBOutlet UILabel *count;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *countWidth;

@end

@implementation EHHomeSchoolCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bottomLineHeight.constant = 1.0/ScreenScale;
    _count.layer.cornerRadius = 25.0/2.0;
    _count.layer.masksToBounds = YES;
}


- (void)configModel:(School *)model
{
    if (model) {
        [self.icon yy_setImageWithURL:[NSURL URLWithString:model.icon] options:YYWebImageOptionProgressiveBlur];
        self.name.text = model.name;
        if (model.campus) {
            self.des.text = model.campus;
        }else
        {
            self.des.text = [NSString stringWithFormat:@"%@  %@",model.type,model.nature];
        }
        if (model.count == 0) {
            _count.hidden = YES;
        }
        else
        {
            _count.hidden = NO;
            _count.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%li",model.count]];
            CGFloat width = [_count.text widthForFont:[UIFont systemFontOfSize:14]];
            self.countWidth.constant = width+20;
        }
        
    }
}


@end
