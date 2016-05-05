//
//  MFUConfigScene.m
//  2HUO
//
//  Created by iURCoder on 3/23/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHHomeScene.h"
#import "WFLoopShowView.h"
#import "BannerModel.h"
#import "EHCommunityCell.h"
#import "Communitys.h"


@interface EHHomeScene ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView          * tableView;
@property (nonatomic, strong) NSArray              * data;
@property (nonatomic, strong) WFLoopShowView       * bannerView;
@property (nonatomic, strong) Communitys           * communityData;
@property (nonatomic, strong) GDReq                * getCommunityListRequest;

@end

@implementation EHHomeScene

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"我是%@,今年%li岁,%@,%@",self.name,self.age,self.image,self.girls);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showBarButton:NAV_LEFT imageName:@"mycity_highlight"];
    self.title = @"二货";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"EHCommunityCell" bundle:nil] forCellReuseIdentifier:@"EHCommunityCell"];
    [self.view addSubview:self.tableView];
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
    }];
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.00001)];
    self.tableView.tableHeaderView = headerView;
    
    [[YDog shareInstance] selectFrom:@"Banner" type:SearchTypeEqualTo where:@"name" is:@"_homeBanner" page:@"1" complete:^(NSArray *objects, NSError *error) {
        
        BannerModel * model = [[BannerModel alloc] initWithDictionary:@{@"list":objects} error:nil];
        [self.bannerView loadImagesWithModel:model];
        
    }];
    
    self.getCommunityListRequest = [GDRequest getCommunityListRequest];
    self.getCommunityListRequest.requestNeedActive = YES;
    self.getCommunityListRequest.cachePolicy = GDRequestCachePolicyReadCache;
    [self.getCommunityListRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            Communitys * model = [[Communitys alloc] initWithDictionary:req.output error:nil];
            self.communityData = model;
            [[TMCache sharedCache] setObject:model forKey:@"Community"];
            [self.tableView reloadData];
        }
    }];
}

- (void)leftButtonTouch
{
    [[GDRouter sharedInstance] show:@"GD://mine" animated:YES completion:nil];
}


#pragma mark - UITableViewDelegate and UITableViewDataScore



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section ? self.communityData.data.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        EHCommunityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EHCommunityCell"];
        Community * model = self.communityData.data[indexPath.row];
        [cell configModel:model];
        return cell;
    }else{
        return  nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? Screen_Width/5*3 : 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return section == 0 ? self.bannerView : [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 0.001)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        Community * model = self.communityData.data[indexPath.row];
        NSString * url = [NSString stringWithFormat:@"GD://postList/?cid=%li",model.cid];
        [[GDRouter sharedInstance] open:url animated:YES extraParams:nil];
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (WFLoopShowView *)bannerView
{
    if (!_bannerView) {
        CGRect rect = CGRectMake(0, 0, Screen_Width, Screen_Width/5*3);
        _bannerView = [[WFLoopShowView alloc] initWithFrame:rect image:nil animationDuration:4.7];
        
    }
    return _bannerView;
}


@end
