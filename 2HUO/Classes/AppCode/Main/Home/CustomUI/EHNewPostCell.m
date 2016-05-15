//
//  EHNewPostCell.m
//  2HUO
//
//  Created by iURCoder on 5/12/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHNewPostCell.h"
#import "Post.h"
#import <YYWebImage/YYWebImage.h>
#import "School.h"

@interface EHNewPostCell()

@property (nonatomic, weak) IBOutlet UIImageView * postImage;
@property (nonatomic, weak) IBOutlet UILabel * title;
@property (nonatomic, weak) IBOutlet UILabel * des;

@end

@implementation EHNewPostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.postImage.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configModel:(PostInfo *)model
{
    if (model) {
        [self.postImage yy_setImageWithURL:[NSURL URLWithString:model.images[0]] options:YYWebImageOptionUseNSURLCache];
        self.title.text = model.title;
        NSString * createTime = [NSString stringWithFormat:@"%li",model.createTime];
        self.des.text = [NSString stringWithFormat:@"%@ 来自 %@",createTime.timeAgo,model.school.name];
    }
}

@end
