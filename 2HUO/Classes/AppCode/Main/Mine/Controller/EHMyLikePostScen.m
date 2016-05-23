//
//  EHMyLikePostScen.m
//  2HUO
//
//  Created by iURCoder on 5/18/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHMyLikePostScen.h"
#import "EHMyPostCell.h"
#import "Post.h"

@interface EHMyLikePostScen ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) NSMutableArray *list;
@property (nonatomic, strong) GDReq * getMyLikePostRequest;

@end

@implementation EHMyLikePostScen

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BGCOLOR;
    self.collectionView.backgroundColor = BGCOLOR;
    _list = [NSMutableArray array];
    if (self.myPost && [self.myPost isEqualToString:@"1"]) {
        self.title = @"我发布的";
    }else
    {
        self.title = @"我喜欢的";
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(Screen_Width*0.5-22.5, Screen_Width*0.5+42.5);
    layout.sectionInset = UIEdgeInsetsMake(15, 15, 0, 15);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 15;
    _collectionView.collectionViewLayout = layout;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"EHMyPostCell" bundle:nil] forCellWithReuseIdentifier:@"EHMyPostCell"];
    
    
    
    self.getMyLikePostRequest = [GDRequest getMyLikePostListRequest];
    if (self.myPost && [self.myPost isEqualToString:@"1"]) {
        [self.getMyLikePostRequest.params setValue:@"1" forKey:@"myPost"];
    }
    [self.getMyLikePostRequest.params setValue:USER.uid forKey:@"uid"];
    [self.getMyLikePostRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            Post * model = [[Post alloc] initWithDictionary:req.output error:nil];
            if ([self.collectionView.mj_header isRefreshing]) {
                [self.list removeAllObjects];
                [self.list addObjectsFromArray:model.data];
            }
            if ([self.collectionView.mj_footer isRefreshing]) {
                [self.list addObjectsFromArray:model.data];
            }
            [self.collectionView reloadData];
            if ([self.collectionView.mj_header isRefreshing]) {
                [self.collectionView.mj_header endRefreshing];
            }
            if ([self.collectionView.mj_footer isRefreshing]) {
                [self.collectionView.mj_footer endRefreshing];
            }
        }
        if (req.failed) {
            if ([self.collectionView.mj_header isRefreshing]) {
                [self.collectionView.mj_header endRefreshing];
            }
            if ([self.collectionView.mj_footer isRefreshing]) {
                [self.collectionView.mj_footer endRefreshing];
            }
        }
    }];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.collectionView setDefaultGifRefreshWithHeader:header];
    self.collectionView.mj_header = header;
    [self.collectionView.mj_header beginRefreshing];
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.collectionView setDefaultGifRefreshWithFooter:footer];
    self.collectionView.mj_footer = footer;
    
}

- (void)loadNewData
{
    [self.getMyLikePostRequest.params removeObjectForKey:@"lastId"];
    self.getMyLikePostRequest.requestNeedActive = YES;
}

- (void)loadMoreData
{
    PostInfo * post = self.list.firstObject;
    [self.getMyLikePostRequest.params setValue:@(post.pid) forKey:@"lastId"];
    self.getMyLikePostRequest.requestNeedActive = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EHMyPostCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EHMyPostCell" forIndexPath:indexPath];
    [cell configModel:self.list[indexPath.item]];
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _list.count;
}

@end
