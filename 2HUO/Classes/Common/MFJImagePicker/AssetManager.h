//
//  AssetUtil.h
//  2HUO
//
//  Created by iURCoder on 4/9/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "UIView+Asset.h"

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@class MFJAlbumModel,MFJAssetModel;

@interface AssetManager : NSObject

@property (nonatomic, strong) PHCachingImageManager *cachingImageManager;

+ (instancetype)manager;

@property (nonatomic, assign) BOOL shouldFixOrientation;

/// Return YES if Authorized 返回YES如果得到了授权
- (BOOL)authorizationStatusAuthorized;

/// Get Album 获得相册/相册数组
- (void)getCameraRollAlbum:(BOOL)allowPickingVideo completion:(void (^)(MFJAlbumModel *model))completion;
- (void)getAllAlbums:(BOOL)allowPickingVideo completion:(void (^)(NSArray<MFJAlbumModel *> *models))completion;

/// Get Assets 获得Asset数组
- (void)getAssetsFromFetchResult:(id)result allowPickingVideo:(BOOL)allowPickingVideo completion:(void (^)(NSArray<MFJAssetModel *> *models))completion;
- (void)getAssetFromFetchResult:(id)result atIndex:(NSInteger)index allowPickingVideo:(BOOL)allowPickingVideo completion:(void (^)(MFJAssetModel *model))completion;

/// Get photo 获得照片
- (void)getPostImageWithAlbumModel:(MFJAlbumModel *)model completion:(void (^)(UIImage *postImage))completion;

- (void)getPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion;

- (void)getPhotoWithAsset:(id)asset photoSize:(CGSize)size completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion;

- (void)getOriginalPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo,NSDictionary *info))completion;

/// Get video 获得视频
- (void)getVideoWithAsset:(id)asset completion:(void (^)(AVPlayerItem * playerItem, NSDictionary * info))completion;

/// Get photo bytes 获得一组照片的大小
- (void)getPhotosBytesWithArray:(NSArray *)photos completion:(void (^)(NSString *totalBytes))completion;

@end
