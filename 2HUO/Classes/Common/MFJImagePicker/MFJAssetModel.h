//
//  MFJAssetModel.h
//  2HUO
//
//  Created by iURCoder on 4/9/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    MFJAssetModelMediaTypePhoto = 0,
    MFJAssetModelMediaTypeLivePhoto,
    MFJAssetModelMediaTypeVideo,
    MFJAssetModelMediaTypeAudio
} MFJAssetModelMediaType;

@class PHAsset;
@interface MFJAssetModel : NSObject

@property (nonatomic, strong) id asset;             ///< PHAsset or ALAsset
@property (nonatomic, assign) BOOL isSelected;      ///< The select status of a photo, default is No
@property (nonatomic, assign) MFJAssetModelMediaType type;
@property (nonatomic, copy) NSString *timeLength;

/// Init a photo dataModel With a asset
/// 用一个PHAsset/ALAsset实例，初始化一个照片模型
+ (instancetype)modelWithAsset:(id)asset type:(MFJAssetModelMediaType)type;
+ (instancetype)modelWithAsset:(id)asset type:(MFJAssetModelMediaType)type timeLength:(NSString *)timeLength;

@end


@class PHFetchResult;
@interface MFJAlbumModel : NSObject

@property (nonatomic, strong) NSString *name;        ///< The album name
@property (nonatomic, assign) NSInteger count;       ///< Count of photos the album contain
@property (nonatomic, strong) id result;             ///< PHFetchResult<PHAsset> or ALAssetsGroup<ALAsset>

@end
