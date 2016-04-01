//
//  MFUHomeMenuCell.m
//  2HUO
//
//  Created by iURCoder on 3/29/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFUHomeMenuCell.h"

@interface MFUHomeMenuCell ()


@end

@implementation MFUHomeMenuCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    for (UIButton * btn in self.contentView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    NSArray * menuInfoArray = @[@[@"title",@""],
                                @[@"title",@""],
                                @[@"title",@""],
                                @[@"title",@""],
                                @[@"title",@""],
                                @[@"title",@""],
                                @[@"title",@""],
                                @[@"title",@""],];
    
    [self setUpMenu:menuInfoArray];
}

- (void)menuButtonClick:(UIButton *)sender
{
    NSLog(@"%li",sender.tag);
}

- (void)setUpMenu:(NSArray *)menuInfoArray
{
    for (UIButton * btn in self.contentView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            
            CGSize btnSize = btn.size;
            UIImageView * icon  = [[UIImageView alloc] init];
            icon.backgroundColor = UIColorHex(0x333333);
            UILabel     * title = [[UILabel alloc] init];
            [btn addSubview:icon];
            [btn addSubview:title];
            NSArray     * cfg   = menuInfoArray[btn.tag];
            icon.image = [UIImage imageNamed:cfg[1]];
            title.text = cfg[0];
            CGSize iconSize = CGSizeMake(btnSize.width/3, btnSize.width/3);
            CGPoint iconCenter = CGPointMake(btnSize.width/2, btnSize.width/3);
            icon.size = iconSize;
            icon.center = iconCenter;
        }
    }
}

@end
