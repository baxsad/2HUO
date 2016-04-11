//
//  GDGridViewController.m
//  2HUO
//
//  Created by iURCoder on 4/10/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "GDGridViewController.h"
#import "GDGridViewCell.h"

@implementation NSIndexSet (Convenience)
- (NSArray *)aapl_indexPathsFromIndexesWithSection:(NSUInteger)section {
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:idx inSection:section]];
    }];
    return indexPaths;
}
@end

@implementation UICollectionView (Convenience)
- (NSArray *)aapl_indexPathsForElementsInRect:(CGRect)rect {
    NSArray *allLayoutAttributes = [self.collectionViewLayout layoutAttributesForElementsInRect:rect];
    if (allLayoutAttributes.count == 0) { return nil; }
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:allLayoutAttributes.count];
    for (UICollectionViewLayoutAttributes *layoutAttributes in allLayoutAttributes) {
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}
@end

@interface GDGridViewController () <PHPhotoLibraryChangeObserver>
{
    CGFloat screenWidth;
    CGFloat screenHeight;
    UICollectionViewFlowLayout *portraitLayout;
    UICollectionViewFlowLayout *landscapeLayout;
}

@property (nonatomic, copy ) NSString      *assetsTitle;

@property (nonatomic,strong) PHFetchResult *assetsFetchResult;

@property (nonatomic, copy ) NSArray       *allAlbum;

@property (nonatomic) NSInteger colsInPortrait;
@property (nonatomic) NSInteger colsInLandscape;
@property (nonatomic) double minimumInteritemSpacing;
@property CGRect previousPreheatRect;

@end

static CGSize AssetGridThumbnailSize;
NSString * const GMGridViewCellIdentifier = @"GMGridViewCellIdentifier";

@implementation GDGridViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.prompt = @"";
    self.collectionView.backgroundColor = [UIColor whiteColor];
    if (!iOS7Later) {
        // support full screen on iOS 6
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        self.navigationController.toolbar.barStyle = UIBarStyleBlackTranslucent;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 5;//右边距
    UIBarButtonItem *barbutton = [[UIBarButtonItem alloc] initWithTitle:@"Cancle" style:UIBarButtonItemStyleBordered target:self action:@selector(leftButtonTouch)];
    [barbutton setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:95.0/255.0 green:95.0/255.0 blue:95.0/255.0 alpha:1]} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItems = @[fixedSpace,barbutton];
    if (iOS7Later) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }

    
    NSArray * mediaTypes = @[@(PHAssetMediaTypeAudio),
                             @(PHAssetMediaTypeVideo),
                             @(PHAssetMediaTypeImage)];
    
    [[GDAssetManager  manager] getAllAlbums:mediaTypes completion:^(NSArray<GDAlbumModel *> *models) {
        
        self.allAlbum = models;
        self.albumModel = models[1];
        self.assetsFetchResult = self.albumModel.result;
        self.assetsTitle = self.albumModel.title;
        self.navigationItem.prompt = self.assetsTitle;
        [self.collectionView reloadData];
        
    }];
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    [self resetCachedAssets];
    
    UIButton * selectAlbumButton = [[UIButton alloc] init];
    [selectAlbumButton setTitle:@"be a motherfucker" forState:UIControlStateNormal];
    [selectAlbumButton setTitleColor:UIColorHex(0x555555) forState:UIControlStateNormal];
    [selectAlbumButton sizeToFit];
    self.navigationItem.titleView = selectAlbumButton;
    
    UIButton * sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(0, 0, 55, 25);
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor colorWithRed:95.0/255.0 green:95.0/255.0 blue:95.0/255.0 alpha:1] forState:UIControlStateNormal];
    [sendButton setBackgroundColor:[UIColor whiteColor]];
    sendButton.layer.borderWidth = 1;
    sendButton.layer.borderColor = [UIColor colorWithRed:125.0/255.0 green:125.0/255.0 blue:125.0/255.0 alpha:1].CGColor;
    [sendButton addTarget:self action:@selector(postAction) forControlEvents:UIControlEventTouchUpInside];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:13];
    sendButton.layer.cornerRadius = 3;
    sendButton.layer.masksToBounds = YES;
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    
}

- (void)postAction
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateCachedAssets];
}

- (void)dealloc
{
    [self resetCachedAssets];
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)leftButtonTouch
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (instancetype)init;
{
    CGRect rect = [UIScreen mainScreen].bounds;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        screenWidth = CGRectGetWidth(rect);
        screenHeight = CGRectGetHeight(rect);
    }
    else
    {
        if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
        {
            screenHeight = CGRectGetWidth(rect);
            screenWidth = CGRectGetHeight(rect);
        }
        else
        {
            screenWidth = CGRectGetWidth(rect);
            screenHeight = CGRectGetHeight(rect);
        }
    }
    
    _colsInPortrait = 3;
    _colsInLandscape = 5;
    _minimumInteritemSpacing = 2.0;
    
    UICollectionViewFlowLayout *layout = [self collectionViewFlowLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
    if (self = [super initWithCollectionViewLayout:layout])
    {
        //Compute the thumbnail pixel size:
        CGFloat scale = [UIScreen mainScreen].scale;
        //NSLog(@"This is @%fx scale device", scale);
        AssetGridThumbnailSize = CGSizeMake(layout.itemSize.width * scale, layout.itemSize.height * scale);
        
        self.collectionView.allowsMultipleSelection = YES;
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"GDGridViewCell" bundle:nil] forCellWithReuseIdentifier:GMGridViewCellIdentifier];
        
        self.collectionView.contentInset = UIEdgeInsetsMake(_minimumInteritemSpacing, 0, 0, 0);
        
    }
    return self;
}

#pragma mark - Collection View Layout

- (UICollectionViewFlowLayout *)collectionViewFlowLayoutForOrientation:(UIInterfaceOrientation)orientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if(!portraitLayout)
        {
            portraitLayout = [[UICollectionViewFlowLayout alloc] init];
            portraitLayout.minimumInteritemSpacing = self.minimumInteritemSpacing;
            int cellTotalUsableWidth = screenWidth - (self.colsInPortrait-1)*self.minimumInteritemSpacing;
            portraitLayout.itemSize = CGSizeMake(cellTotalUsableWidth/self.colsInPortrait, cellTotalUsableWidth/self.colsInPortrait);
            double cellTotalUsedWidth = (double)portraitLayout.itemSize.width*self.colsInPortrait;
            double spaceTotalWidth = (double)screenWidth-cellTotalUsedWidth;
            double spaceWidth = spaceTotalWidth/(double)(self.colsInPortrait-1);
            portraitLayout.minimumLineSpacing = spaceWidth;
        }
        return portraitLayout;
    }
    else
    {
        if(UIInterfaceOrientationIsLandscape(orientation))
        {
            if(!landscapeLayout)
            {
                landscapeLayout = [[UICollectionViewFlowLayout alloc] init];
                landscapeLayout.minimumInteritemSpacing = self.minimumInteritemSpacing;
                int cellTotalUsableWidth = screenHeight - (self.colsInLandscape-1)*self.minimumInteritemSpacing;
                landscapeLayout.itemSize = CGSizeMake(cellTotalUsableWidth/self.colsInLandscape, cellTotalUsableWidth/self.colsInLandscape);
                double cellTotalUsedWidth = (double)landscapeLayout.itemSize.width*self.colsInLandscape;
                double spaceTotalWidth = (double)screenHeight-cellTotalUsedWidth;
                double spaceWidth = spaceTotalWidth/(double)(self.colsInLandscape-1);
                landscapeLayout.minimumLineSpacing = spaceWidth;
            }
            return landscapeLayout;
        }
        else
        {
            if(!portraitLayout)
            {
                portraitLayout = [[UICollectionViewFlowLayout alloc] init];
                portraitLayout.minimumInteritemSpacing = self.minimumInteritemSpacing;
                int cellTotalUsableWidth = screenWidth - (self.colsInPortrait-1)*self.minimumInteritemSpacing;
                portraitLayout.itemSize = CGSizeMake(cellTotalUsableWidth/self.colsInPortrait, cellTotalUsableWidth/self.colsInPortrait);
                double cellTotalUsedWidth = (double)portraitLayout.itemSize.width*self.colsInPortrait;
                double spaceTotalWidth = (double)screenWidth-cellTotalUsedWidth;
                double spaceWidth = spaceTotalWidth/(double)(self.colsInPortrait-1);
                portraitLayout.minimumLineSpacing = spaceWidth;
            }
            return portraitLayout;
        }
    }
}


#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    // Call might come on any background queue. Re-dispatch to the main queue to handle it.
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // check if there are changes to the assets (insertions, deletions, updates)
        PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.assetsFetchResult];
        if (collectionChanges) {
            
            // get the new fetch result
            self.assetsFetchResult = [collectionChanges fetchResultAfterChanges];
            
            UICollectionView *collectionView = self.collectionView;
            
            if (![collectionChanges hasIncrementalChanges] || [collectionChanges hasMoves]) {
                // we need to reload all if the incremental diffs are not available
                [collectionView reloadData];
                
            } else {
                // if we have incremental diffs, tell the collection view to animate insertions and deletions
                [collectionView performBatchUpdates:^{
                    NSIndexSet *removedIndexes = [collectionChanges removedIndexes];
                    if ([removedIndexes count]) {
                        [collectionView deleteItemsAtIndexPaths:[removedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                    }
                    NSIndexSet *insertedIndexes = [collectionChanges insertedIndexes];
                    if ([insertedIndexes count]) {
                        [collectionView insertItemsAtIndexPaths:[insertedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                        if (1+1 == /* DISABLES CODE */ (3)) {
                            for (NSIndexPath *path in [insertedIndexes aapl_indexPathsFromIndexesWithSection:0]) {
                                [self collectionView:collectionView didSelectItemAtIndexPath:path];
                            }
                        }
                    }
                    NSIndexSet *changedIndexes = [collectionChanges changedIndexes];
                    if ([changedIndexes count]) {
                        [collectionView reloadItemsAtIndexPaths:[changedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                    }
                } completion:NULL];
            }
            
            [self resetCachedAssets];
        }
    });
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateCachedAssets];
}

#pragma mark - Asset Caching

- (void)resetCachedAssets
{
    [[GDAssetManager manager].cachingImageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GDGridViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GMGridViewCellIdentifier
                                                                     forIndexPath:indexPath];
    
    // Increment the cell's tag
    NSInteger currentTag = cell.tag + 1;
    cell.tag = currentTag;
    
    PHAsset *asset = self.assetsFetchResult[indexPath.item];
    
    
    {
        
        [[GDAssetManager manager] getThumbnailPhotoWithAsset:asset
                                                        size:AssetGridThumbnailSize
                                                  completion:^(UIImage *photo, NSDictionary *info) {
                                                      if (cell.tag == currentTag) {
                                                          [cell.imageView setImage:photo];
                                                      }
                                                  }];
        
    }
    
    
    
    return cell;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = self.assetsFetchResult.count;
    return count;
}


- (void)updateCachedAssets
{
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
    if (!isViewVisible) { return; }
    
    // The preheat window is twice the height of the visible rect
    CGRect preheatRect = self.collectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));
    
    // If scrolled by a "reasonable" amount...
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(self.collectionView.bounds) / 3.0f) {
        
        // Compute the assets to start caching and to stop caching.
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self.collectionView aapl_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self.collectionView aapl_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        
        [[GDAssetManager manager].cachingImageManager startCachingImagesForAssets:assetsToStartCaching
                                            targetSize:AssetGridThumbnailSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil];
        [[GDAssetManager manager].cachingImageManager stopCachingImagesForAssets:assetsToStopCaching
                                           targetSize:AssetGridThumbnailSize
                                          contentMode:PHImageContentModeAspectFill
                                              options:nil];
        
        self.previousPreheatRect = preheatRect;
    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler
{
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths
{
    if (indexPaths.count == 0) { return nil; }
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        PHAsset *asset = self.assetsFetchResult[indexPath.item];
        [assets addObject:asset];
    }
    return assets;
}



@end
