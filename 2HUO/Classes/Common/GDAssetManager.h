//
//  GDAssetManager.h
//  2HUO
//
//  Created by iURCoder on 4/10/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define TOOL_BAR_HEIGHT 45

typedef NS_ENUM(NSUInteger, GDPhotoRequestType) {
    GDPhotoRequestTypeOriginl     = 0,
    GDPhotoRequestTypeThumbnail   = 1 << 0
};

typedef enum : NSUInteger {
    GDAssetModelMediaTypePhoto = 0,
    GDAssetModelMediaTypeLivePhoto,
    GDAssetModelMediaTypeVideo,
    GDAssetModelMediaTypeAudio,
    GDAssetModelMediaTypePhotoHDR
} GDAssetModelMediaType;

@interface GDAlbumModel : NSObject

@property (nonatomic, strong) PHFetchResult * result;
@property (nonatomic, copy  ) NSString      * title;
@property (nonatomic, assign) NSInteger       count;

- (instancetype)initWithResult:(PHFetchResult *)result title:(NSString *)title;

@end

@interface GDAssetModel : NSObject

@property (nonatomic, strong) id asset;   
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) GDAssetModelMediaType type;
@property (nonatomic,   copy) NSString *timeLength;

+ (instancetype)modelWithAsset:(id)asset;

@end

@interface GDAssetManager : NSObject

@property (nonatomic, strong) PHCachingImageManager *cachingImageManager;

@property (nonatomic, assign) BOOL shouldFixOrientation;

+ (instancetype)manager;
/**
 *  请求所有相册列表
 *
 *  @param mediaTypes  相册内容的类型包括图片，视频等
 *  @param completion 完成请求后调用的 block
 *
 *  @return no return
 */
- (void)getAllAlbums:(NSArray *)mediaTypes completion:(void (^)(NSArray<GDAlbumModel *> *models))completion;
/**
 *  异步请求 Asset 的缩略图，不会产生网络请求
 *
 *  @param asset PHAsset资源
 *  @param size  指定返回的缩略图的大小
 *  @param completion 完成请求后调用的 block
 *
 *  @return no return
 */
- (void)getThumbnailPhotoWithAsset:(id)asset size:(CGSize)size completion:(void (^)(UIImage *photo,NSDictionary *info))completion;
/**
 *  异步请求 Asset 的原图，不会产生网络请求
 *
 *  @param asset PHAsset资源
 *  @param completion 完成请求后调用的 block
 *
 *  @return no return
 */
- (void)getOriginlPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo,NSDictionary *info))completion;
/**
 *  异步请求 Asset 的预览图，不会产生网络请求
 *
 *  @param asset PHAsset资源
 *  @param completion 完成请求后调用的 block
 *
 *  @return no return
 */
- (void)getPreviewlPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo,NSDictionary *info))completion;

@end

