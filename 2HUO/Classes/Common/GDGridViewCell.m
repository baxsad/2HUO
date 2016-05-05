//
//  GDGridViewCell.m
//  2HUO
//
//  Created by iURCoder on 4/10/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "GDGridViewCell.h"
#import "GDAssetManager.h"

@implementation GDGridViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.contentView.translatesAutoresizingMaskIntoConstraints = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    __weak typeof(self) weakSelf = self;
    [self.selectButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf.selectBlock) {
            strongSelf.selectBlock(strongSelf);
        }
    }];
}

- (void)setAssetModel:(GDAssetModel *)assetModel
{
    
    _assetModel = assetModel;
}

@end
