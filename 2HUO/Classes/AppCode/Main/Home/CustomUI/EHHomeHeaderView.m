//
//  EHHomeHeaderView.m
//  2HUO
//
//  Created by iURCoder on 5/13/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHHomeHeaderView.h"
#import <YYWebImage/YYWebImage.h>
#import "BannerModel.h"

@interface EHHomeHeaderView ()

@property (nonatomic, weak) IBOutlet UIImageView * leftMenuImage;
@property (nonatomic, weak) IBOutlet UIImageView * rightMenuImage;

@end

@implementation EHHomeHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.leftMenuImage.clipsToBounds = YES;
    self.rightMenuImage.clipsToBounds = YES;
    self.leftMenuImage.userInteractionEnabled = YES;
    self.rightMenuImage.userInteractionEnabled = YES;
    [self.leftMenuImage whenTapped:^{
        if (self.handleAction) {
            self.handleAction(1);
        }
    }];
    [self.rightMenuImage whenTapped:^{
        if (self.handleAction) {
            self.handleAction(2);
        }
    }];
}

- (void)configModels:(NSArray *)array
{
    if (array && array.count==2) {
        Banner * b1 = array[0];
        Banner * b2 = array[1];
        [_leftMenuImage yy_setImageWithURL:[NSURL URLWithString:b1.image] options:YYWebImageOptionProgressiveBlur];
        [_rightMenuImage yy_setImageWithURL:[NSURL URLWithString:b2.image] options:YYWebImageOptionProgressiveBlur];
    }
}

@end
