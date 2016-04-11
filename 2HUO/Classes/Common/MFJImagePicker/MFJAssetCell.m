//
//  MFJAssetCell.m
//  2HUO
//
//  Created by iURCoder on 4/9/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFJAssetCell.h"
#import "MFJAssetModel.h"
#import "AssetManager.h"

@interface MFJAssetCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;       // The photo / 照片
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *timeLength;

@end

@implementation MFJAssetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.imageView clipsToBounds];
    self.timeLength.font = [UIFont boldSystemFontOfSize:11];
    [self.selectPhotoButton addTarget:self action:@selector(selectPhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setModel:(MFJAssetModel *)model {
    
    
    CGFloat itemWH = (SCREEN_WIDTH - 2 * 2) / 3 ;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize AssetGridThumbnailSize = CGSizeMake(itemWH * scale, itemWH * scale);
    
    [[AssetManager manager] getPhotoWithAsset:model.asset photoSize:AssetGridThumbnailSize completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        
        self.imageView.image = photo;
        
    }];

    self.selectPhotoButton.selected = model.isSelected;
    self.selectImageView.image = self.selectPhotoButton.isSelected ? [UIImage imageNamed:@"photo_sel_photoPickerVc"] : [UIImage imageNamed:@"photo_def_photoPickerVc"];
    self.type = MFJAssetCellTypePhoto;
    if (model.type == MFJAssetModelMediaTypeLivePhoto)      self.type = MFJAssetCellTypeLivePhoto;
    else if (model.type == MFJAssetModelMediaTypeAudio)     self.type = MFJAssetCellTypeAudio;
    else if (model.type == MFJAssetModelMediaTypeVideo) {
        self.type = MFJAssetCellTypeVideo;
        self.timeLength.text = model.timeLength;
    }
    
}

- (void)setType:(MFJAssetCellType)type {
    _type = type;
    if (type == MFJAssetCellTypePhoto || type == MFJAssetCellTypeLivePhoto) {
        _selectImageView.hidden = NO;
        _selectPhotoButton.hidden = NO;
        _bottomView.hidden = YES;
    } else {
        _selectImageView.hidden = YES;
        _selectPhotoButton.hidden = YES;
        _bottomView.hidden = NO;
    }
}

- (void)selectPhotoButtonClick:(UIButton *)sender {
    
    self.model.isSelected = !_model.isSelected;
    sender.selected = self.model.isSelected;
    
    if (self.didSelectPhotoBlock) {
        self.didSelectPhotoBlock(sender.isSelected);
    }
    
    self.selectImageView.image = sender.isSelected ? [UIImage imageNamed:@"photo_sel_photoPickerVc"] : [UIImage imageNamed:@"photo_def_photoPickerVc"];
    if (sender.isSelected) {
        [UIView showOscillatoryAnimationWithLayer:_selectImageView.layer type:MFJscillatoryAnimationToBigger];
    }
}

@end
