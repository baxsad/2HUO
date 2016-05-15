//
//  EHPostDetailIamgeCell.m
//  2HUO
//
//  Created by iURCoder on 5/10/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHPostDetailIamgeCell.h"
#import <YYWebImage/YYWebImage.h>

@interface EHPostDetailIamgeCell ()

@property (nonatomic, weak) IBOutlet UIImageView * postImage;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * postImageHeight;

@end

@implementation EHPostDetailIamgeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configModel:(NSString *)model
{
    if (model) {
        [_postImage yy_setImageWithURL:[NSURL URLWithString:model] placeholder:nil options:YYWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            
            if (stage == YYWebImageStageFinished && image) {
                self.postImage.image = image;
                CGSize size = image.size;
                CGFloat w = size.width;
                CGFloat h = size.height;
                self.postImageHeight.constant = Screen_Width*h/w;
            }
            
        }];
    }
}

@end
