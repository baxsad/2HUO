//
//  MFJAssetCell.h
//  2HUO
//
//  Created by iURCoder on 4/9/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MFJAssetModel;

typedef enum : NSUInteger {
    MFJAssetCellTypePhoto = 0,
    MFJAssetCellTypeLivePhoto,
    MFJAssetCellTypeVideo,
    MFJAssetCellTypeAudio,
} MFJAssetCellType;

@interface MFJAssetCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectPhotoButton;
@property (nonatomic, copy) void (^didSelectPhotoBlock)(BOOL);
@property (nonatomic, strong) MFJAssetModel *model;
@property (nonatomic, assign) MFJAssetCellType type;


@end
