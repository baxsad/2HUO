//
//  GDAssetManager.m
//  2HUO
//
//  Created by iURCoder on 4/10/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "GDAssetManager.h"

@implementation GDAlbumModel

- (instancetype)initWithResult:(PHFetchResult *)result title:(NSString *)title
{
    if (self = [super init]) {
        self.result = result;
        self.title = title;
        self.count = result.count;
    }
    return self;
}

@end

@implementation GDAssetModel

+ (instancetype)modelWithAsset:(id)asset
{
    GDAssetModel * obj = [[GDAssetModel alloc] init];
    if (obj && asset) {
        
        PHAsset *phasset = (PHAsset *)asset;
        obj.asset = phasset;
        obj.isSelected = NO;
        switch (phasset.mediaType) {
            case PHAssetMediaTypeUnknown:
                if (phasset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
                    obj.type = GDAssetModelMediaTypeLivePhoto;
                }
                if (phasset.mediaSubtypes == PHAssetMediaSubtypePhotoHDR) {
                    obj.type = GDAssetModelMediaTypePhotoHDR;
                }
                break;
            case PHAssetMediaTypeImage:
                obj.type = GDAssetModelMediaTypePhoto;
                break;
            case PHAssetMediaTypeAudio:
                obj.type = GDAssetModelMediaTypeAudio;
                break;
            case PHAssetMediaTypeVideo:
                obj.type = GDAssetModelMediaTypeVideo;
                break;
                
            default:
                break;
        }
        
        
    }else{
        return nil;
    }
    return obj;
}

@end

@interface GDAssetManager ()

@property (nonatomic,copy) NSArray *mediaTypes;
@property (nonatomic, strong) NSArray* customSmartCollections;
@property (nonatomic,strong) NSArray *collectionsFetchResults;
@property (nonatomic,strong) NSArray *collectionsLocalizedTitles;
@property (nonatomic,strong) NSArray *collectionsFetchResultsAssets;
@property (nonatomic,strong) NSArray *collectionsFetchResultsTitles;

@end

@implementation GDAssetManager

+ (instancetype)manager {
    static GDAssetManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        manager.cachingImageManager = [[PHCachingImageManager alloc] init];
        manager.customSmartCollections = @[@(PHAssetCollectionSubtypeSmartAlbumFavorites),
                                           @(PHAssetCollectionSubtypeSmartAlbumRecentlyAdded),
                                           @(PHAssetCollectionSubtypeSmartAlbumVideos),
                                           @(PHAssetCollectionSubtypeSmartAlbumSlomoVideos),
                                           @(PHAssetCollectionSubtypeSmartAlbumTimelapses),
                                           @(PHAssetCollectionSubtypeSmartAlbumBursts),
                                           @(PHAssetCollectionSubtypeSmartAlbumPanoramas)];
    });
    return manager;
}

- (void)getAllAlbums:(NSArray *)mediaTypes completion:(void (^)(NSArray<GDAlbumModel *> *models))completion
{
    self.mediaTypes = mediaTypes;
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    self.collectionsFetchResults = @[topLevelUserCollections, smartAlbums];
    self.collectionsLocalizedTitles = @[ @"Albums",@"Smart Albums"];
    [self updateFetchResultsCompletion:completion];
}

-(void)updateFetchResultsCompletion:(void (^)(NSArray<GDAssetModel *> *models))completion
{
    //What I do here is fetch both the albums list and the assets of each album.
    //This way I have acces to the number of items in each album, I can load the 3
    //thumbnails directly and I can pass the fetched result to the gridViewController.
    
    self.collectionsFetchResultsAssets=nil;
    self.collectionsFetchResultsTitles=nil;
    
    //Fetch PHAssetCollections:
    PHFetchResult *topLevelUserCollections = [self.collectionsFetchResults objectAtIndex:0];
    PHFetchResult *smartAlbums = [self.collectionsFetchResults objectAtIndex:1];
    
    //All album: Sorted by descending creation date.
    NSMutableArray *allFetchResultArray = [[NSMutableArray alloc] init];
    NSMutableArray *allFetchResultLabel = [[NSMutableArray alloc] init];
    {
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.predicate = [NSPredicate predicateWithFormat:@"mediaType in %@", self.mediaTypes];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsWithOptions:options];
        [allFetchResultArray addObject:assetsFetchResult];
        [allFetchResultLabel addObject:@"All photos"];
    }
    
    //User albums:
    NSMutableArray *userFetchResultArray = [[NSMutableArray alloc] init];
    NSMutableArray *userFetchResultLabel = [[NSMutableArray alloc] init];
    for(PHCollection *collection in topLevelUserCollections)
    {
        if ([collection isKindOfClass:[PHAssetCollection class]])
        {
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            options.predicate = [NSPredicate predicateWithFormat:@"mediaType in %@", self.mediaTypes];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            
            //Albums collections are allways PHAssetCollectionType=1 & PHAssetCollectionSubtype=2
            
            PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
            [userFetchResultArray addObject:assetsFetchResult];
            [userFetchResultLabel addObject:collection.localizedTitle];
        }
    }
    
    
    //Smart albums: Sorted by descending creation date.
    NSMutableArray *smartFetchResultArray = [[NSMutableArray alloc] init];
    NSMutableArray *smartFetchResultLabel = [[NSMutableArray alloc] init];
    for(PHCollection *collection in smartAlbums)
    {
        if ([collection isKindOfClass:[PHAssetCollection class]])
        {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            
            //Smart collections are PHAssetCollectionType=2;
            if(self.customSmartCollections && [self.customSmartCollections containsObject:@(assetCollection.assetCollectionSubtype)])
            {
                PHFetchOptions *options = [[PHFetchOptions alloc] init];
                options.predicate = [NSPredicate predicateWithFormat:@"mediaType in %@", self.mediaTypes];
                options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
                
                PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
                if(assetsFetchResult.count>0)
                {
                    [smartFetchResultArray addObject:assetsFetchResult];
                    [smartFetchResultLabel addObject:collection.localizedTitle];
                }
            }
        }
    }
    
    self.collectionsFetchResultsAssets= @[allFetchResultArray,userFetchResultArray,smartFetchResultArray];
    self.collectionsFetchResultsTitles= @[allFetchResultLabel,userFetchResultLabel,smartFetchResultLabel];
    
    if (completion) {
        
        NSMutableArray * models = [NSMutableArray array];
        
        for (int i = 0; i < self.collectionsFetchResultsAssets.count; i++) {
            
            NSArray * assets = self.collectionsFetchResultsAssets[i];
            NSArray * titles = self.collectionsFetchResultsTitles[i];
            for (int k = 0; k < assets.count; k++) {
                
                GDAlbumModel * model = [[GDAlbumModel alloc] initWithResult:assets[k] title:titles[k]];
                [models addObject: model];
                
            }
            
        }
        
        completion(models);
        
    }
}


- (void)getPhotoWithAsset:(id)asset requestPhtotType:(GDPhotoRequestType)type targetSize:(CGSize)size options:(PHImageRequestOptions *)options completion:(void (^)(UIImage *photo,NSDictionary *info))completion
{
    
    [[GDAssetManager manager].cachingImageManager requestImageForAsset:asset
                                        targetSize:size
                                       contentMode:PHImageContentModeAspectFill
                                           options:options
                                     resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                         
                                         // 排除取消，错误，低清图三种情况，即已经获取到了高清图
                                         BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                                         
                                         if (result && downloadFinined) {
                                             if (completion) completion(result,info);
                                         }
                                         
                                         
                                     }];
}

- (void)getThumbnailPhotoWithAsset:(id)asset size:(CGSize)size completion:(void (^)(UIImage *photo,NSDictionary *info))completion
{
    PHImageRequestOptions * option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    [self getPhotoWithAsset:asset
           requestPhtotType:GDPhotoRequestTypeThumbnail
                 targetSize:size
                    options:option
                 completion:completion];
}

- (void)getOriginlPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo,NSDictionary *info))completion
{
    PHImageRequestOptions * option = [[PHImageRequestOptions alloc] init];
    option.synchronous = NO;
    
    [self getPhotoWithAsset:asset
           requestPhtotType:GDPhotoRequestTypeOriginl
                 targetSize:PHImageManagerMaximumSize
                    options:option
                 completion:completion];
}

- (void)getPreviewlPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo,NSDictionary *info))completion
{
    PHImageRequestOptions * option = [[PHImageRequestOptions alloc] init];
    option.synchronous = NO;
    CGSize previewSize = [UIScreen mainScreen].bounds.size;
    
    [self getPhotoWithAsset:asset
           requestPhtotType:GDPhotoRequestTypeThumbnail
                 targetSize:previewSize
                    options:option
                 completion:completion];
}

@end
