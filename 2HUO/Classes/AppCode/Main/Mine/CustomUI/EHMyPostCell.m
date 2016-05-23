//
//  EHMyPostCell.m
//  2HUO
//
//  Created by iURCoder on 5/18/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHMyPostCell.h"
#import <YYWebImage/YYWebImage.h>
#import "Post.h"

@interface EHMyPostCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;

@end

@implementation EHMyPostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageV.clipsToBounds = YES;
}

- (void)configModel:(PostInfo*)model
{
    if (model) {
        [self.imageV yy_setImageWithURL:[NSURL URLWithString:model.images[0]] options:YYWebImageOptionProgressiveBlur];
        self.nameLabel.text = model.title;
        self.brandLabel.text = model.communityName;
    }
}

@end
