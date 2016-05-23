//
//  MFUConfigScene.m
//  2HUO
//
//  Created by iURCoder on 3/23/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHHomeScene.h"
#import "WFLoopShowView.h"
#import "EHHomeHeaderView.h"
#import "BannerModel.h"
#import "EHCommunityCell.h"
#import "EHHomeSchoolCell.h"
#import "EHCategaryCell.h"
#import "EHNewPostCell.h"
#import "Communitys.h"
#import <YYWebImage/YYWebImage.h>
#import "EHUserButton.h"
#import "GDLocationManager.h"
#import "Area.h"
#import "School.h"
#import "GDImageButton.h"
#import "GDDropMenu.h"
#import "HomeModel.h"
#import "LGAlertView.h"
#import "Post.h"

typedef void(^ReloadBlock)();

@interface EHHomeScene ()<UITableViewDataSource,UITableViewDelegate,GDDropMenuDelegate>

@property (nonatomic, strong) UITableView          * tableView;
@property (nonatomic, strong) NSArray              * data;
@property (nonatomic, strong) GDImageButton        * titleButton;
@property (nonatomic, strong) WFLoopShowView       * bannerView;
@property (nonatomic, strong) Communitys           * communityData;
@property (nonatomic, strong) SchooData            * schoolData;
@property (nonatomic, strong) GDReq                * getCommunityListRequest;
@property (nonatomic, strong) EHUserButton         * userButton;
@property (nonatomic, strong) EHHomeHeaderView     * headerMenuView;
@property (nonatomic, strong) UIView               * selectMenuView;
@property (nonatomic, strong) UIButton             * typeButton;
@property (nonatomic, strong) UIButton             * locationButton;
@property (nonatomic, strong) UILabel              * selectMenuViewCountLable;
@property (nonatomic, assign) NSInteger              menuSelectIndex;
@property (nonatomic, strong) GDReq                * getAreaListRequest;
@property (nonatomic, strong) Areas                * areaData;
@property (nonatomic, strong) City                 * city;
@property (nonatomic, strong) GDReq                * getSchoolListRequest;
@property (nonatomic, assign) BOOL                   isFirstOpenThisController;
@property (nonatomic, strong) GDDropMenu           * locationMenu;
@property (nonatomic, strong) GDReq                * getHomeModelRequest;
@property (nonatomic,   copy) ReloadBlock            reloadAll;
@property (nonatomic,   copy) ReloadBlock            reloadSome;
@property (nonatomic,   copy) ReloadBlock            reloadBlock;
@property (nonatomic, strong) HomeModel            * homeModel;


@end

@implementation EHHomeScene

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.userButton) {
        if (ISLOGIN) {
            [self.userButton.userIcon yy_setImageWithURL:[NSURL URLWithString:USER.avatar] options:YYWebImageOptionProgressiveBlur];
        }else{
            [self.userButton.userIcon setImage:[UIImage imageNamed:@"tab_me"]];
        }
    }
    if (![USER.school.city isEqualToString:self.cityName]) {
        self.cityName = USER.school.city;
        self.cityName = self.cityName.isNotEmpty ? self.cityName : @"全部地区";
    }
}

#pragma mark 根据城市名字获取城市对象

- (void)getMyArea
{
    for (Area * area in self.areaData.data) {
        for (City * city in area.city) {
            
            if ([self.cityName hasPrefix:city.cityNameCH] || [self.cityName.lowercaseString hasPrefix:city.cityNameEN.lowercaseString])
            {
                self.city = city;
                return;
            }
        }
    }
    self.city = nil;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.view.backgroundColor = BGCOLOR;
    _isFirstOpenThisController = YES;
    
    _titleButton = [[GDImageButton alloc] initWithFrame:CGRectMake(0, 0, 0, 44) title:@"定位中..." image:@"down_arrow"];
    _titleButton.imageSize = CGSizeMake(14, 8);
    _titleButton.FontSize = 17;
    _titleButton.titleColor = UIColorHex(0x888888);
    [_titleButton showInController:self];
    [_titleButton whenTapped:^{
        if (self.menuSelectIndex == 0) {
            [self.locationMenu show];
        }
    }];
    
    
    // 获取地区数据
    self.getAreaListRequest = [GDRequest getAreaListRequest];
    self.getAreaListRequest.requestNeedActive = YES;
    [self.getAreaListRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            self.areaData = [[Areas alloc] initWithDictionary:req.output error:nil];
            if (self.cityName.isNotEmpty) {
                [self getMyArea];
            }
        }
        if (req.failed) {
            self.areaData = self.areaData;
            if (self.cityName.isNotEmpty) {
                [self getMyArea];
            }
        }
    }];
    
    /** 定位当前位置 （暂时舍弃）
    [[GDLocationManager manager] startUpdatingLocation:^(BOOL sucess, GDLocationManager *manager) {
        if (sucess) {
            self.cityName = manager.city;
        }else{
            self.cityName = @"郑州";
        }
        if (self.areaData.isNotEmpty) {
            [self getMyArea];
        }
    }];
     */
    
    // 根据地区获取学校列表
    self.getSchoolListRequest = [GDRequest getSchoolListRequest];
    [self.getSchoolListRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            SchooData * data = [[SchooData alloc] initWithDictionary:req.output error:nil];
            
            if (_tableView.mj_header.isRefreshing || self.schoolData.data.count == 0) {
                self.schoolData = data;
                [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
            }
            if (_tableView.mj_footer.isRefreshing) {
                
                NSMutableArray<School> * newData = @[].mutableCopy;
                [newData addObjectsFromArray:self.schoolData.data];
                NSInteger lastRow = self.schoolData.data.count - 1;
                [newData addObjectsFromArray:data.data];
                NSInteger newRowCount = data.data.count;
                self.schoolData.data = newData;
                
                if (newRowCount>0) {
                    NSMutableArray *indexPaths = @[].mutableCopy;
                    for (int i = 0; i<newRowCount; i++) {
                        NSIndexPath * indexpath = [NSIndexPath indexPathForRow:lastRow+(i+1) inSection:1];
                        [indexPaths addObject:indexpath];
                    }
                    
                    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                }
            }
            
            
            if (_menuSelectIndex == 0) {
                self.selectMenuViewCountLable.text = [NSString stringWithFormat:@"共有%li所学校",self.schoolData.data.count];
            }else{
                self.selectMenuViewCountLable.text = [NSString stringWithFormat:@"共有%li个分类",self.communityData.data.count];
            }
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            if (_tableView.mj_footer.isRefreshing) {
                [_tableView.mj_footer endRefreshing];
            }
        }
        if (req.failed) {
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            if (_tableView.mj_footer.isRefreshing) {
                [_tableView.mj_footer endRefreshing];
            }
        }
    }];
    
    [RACObserve(self, cityName) subscribeNext:^(id x) {
        if (self.cityName.isNotEmpty) {
            [self getMyArea];
        }
    }];
    
    // 监听地区变化
    [RACObserve(self, city) subscribeNext:^(id x) {
        if (self.city == nil) {
            [self.getSchoolListRequest.params setValue:@(0) forKey:@"lastId"];
            [self.getSchoolListRequest.params removeObjectForKey:@"cityId"];
            [self.tableView.mj_header beginRefreshing];
            [self.titleButton reloadTitle:@"全部地区"];
        }else{
            [self.getSchoolListRequest.params setValue:@(0) forKey:@"lastId"];
            [self.getSchoolListRequest.params setValue:@(self.city.cityId) forKey:@"cityId"];
            [self.tableView.mj_header beginRefreshing];
            [self.titleButton reloadTitle:self.city.cityNameCH];
        }
    }];
    
    [self showBarButton:NAV_LEFT button:self.userButton];
    [self showBarButton:NAV_RIGHT imageName:@"add_post"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"EHCommunityCell" bundle:nil] forCellReuseIdentifier:@"EHCommunityCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EHHomeSchoolCell" bundle:nil] forCellReuseIdentifier:@"EHHomeSchoolCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EHCategaryCell" bundle:nil] forCellReuseIdentifier:@"EHCategaryCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EHNewPostCell" bundle:nil] forCellReuseIdentifier:@"EHNewPostCell"];
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
    
    // 获取首页大数据
    self.getHomeModelRequest = [GDRequest gethomeModelRequest];
    self.getHomeModelRequest.requestNeedActive = YES;
    [self.getHomeModelRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            HomeModel * model = [[HomeModel alloc] initWithDictionary:req.output error:nil];
            self.homeModel = model;
            [self.bannerView loadImagesWithModel:self.homeModel];
            [self.headerMenuView configModels:self.homeModel.homeFooterMenu];
            [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
    
    // 获取全部分类（缓存数据）
    self.getCommunityListRequest = [GDRequest getCommunityListRequest];
    self.getCommunityListRequest.cachePolicy = GDRequestCachePolicyReadCache;
    [self.getCommunityListRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            Communitys * model = [[Communitys alloc] initWithDictionary:req.output error:nil];
            self.communityData = model;
            if (_menuSelectIndex == 0) {
                self.selectMenuViewCountLable.text = [NSString stringWithFormat:@"共有%li所学校",self.schoolData.data.count];
            }else{
                self.selectMenuViewCountLable.text = [NSString stringWithFormat:@"共有%li个分类",self.communityData.data.count];
            }
            [[TMCache sharedCache] setObject:model forKey:@"Community"];
            
            [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
            
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
        }
        if (req.failed) {
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
        }
    }];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView setDefaultGifRefreshWithHeader:header];
    self.tableView.mj_header = header;
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableView setDefaultGifRefreshWithFooter:footer];
    self.tableView.mj_footer = footer;
    
    
    // 监听学校和分类按钮的点击
    [RACObserve(self, menuSelectIndex) subscribeNext:^(id x) {
        
        if (_isFirstOpenThisController == YES) {
            _isFirstOpenThisController = NO;
            return ;
        }
        
        if (_menuSelectIndex == 0) {
            if (self.schoolData.isNotEmpty) {
                self.selectMenuViewCountLable.text = [NSString stringWithFormat:@"共%li所学校",self.schoolData.data.count];
                [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationFade];
            }else{
                self.getSchoolListRequest.requestNeedActive = YES;
            }
        }
        if (_menuSelectIndex == 1) {
            if (self.communityData.isNotEmpty) {
                self.selectMenuViewCountLable.text = [NSString stringWithFormat:@"共%li个分类",self.communityData.data.count];
                [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationFade];
            }else{
                self.getCommunityListRequest.requestNeedActive = YES;
            }
        }
    }];
    
}

#pragma mark - 下拉刷新

- (void)loadNewData
{
    if (self.menuSelectIndex == 0) {
        [self.getSchoolListRequest.params setValue:@(0) forKey:@"lastId"];
        self.getSchoolListRequest.requestNeedActive = YES;
    }else{
        self.getCommunityListRequest.requestNeedActive = YES;
    }
}

#pragma mark - 上拉加载

- (void)loadMoreData
{
    if (self.menuSelectIndex == 0) {
        School * school = self.schoolData.data.lastObject;
        [self.getSchoolListRequest.params setValue:@(school.id) forKey:@"lastId"];
        self.getSchoolListRequest.requestNeedActive = YES;
    }else{
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - leftButton touch action

- (void)leftButtonTouch
{
    if (!ISLOGIN) {
        [self showSignScene];
        return;
    }
    [[GDRouter sharedInstance] show:@"GD://mine" animated:YES completion:nil];
}

#pragma mark - rightButton touch action

- (void)rightButtonTouch
{
    if (LOGINandSETSCHOOLandSETPAYACCOUNT) {
        [[GDRouter sharedInstance] show:@"mfj://addPost" extraParams:@{@"needSelectType":@(1)} completion:nil];
    }else{
        if (!ISLOGIN) {
            [self showSignScene];
        }else if (!ISSETSCHOOL){
            [[[LGAlertView alloc] initWithTitle:@"提示"
                                        message:@"请到个人信息页完善学校信息\n才能发布哦！"
                                          style:LGAlertViewStyleAlert
                                   buttonTitles:nil
                              cancelButtonTitle:@"确定"
                         destructiveButtonTitle:nil
                                  actionHandler:nil
                                  cancelHandler:nil
                             destructiveHandler:nil] showAnimated:YES completionHandler:nil];
        }else if (!ISSETPAYACCOUNT){
            [[[LGAlertView alloc] initWithTitle:@"提示"
                                        message:@"请到用户信息页填写账户信息\n才能发布哦！"
                                          style:LGAlertViewStyleAlert
                                   buttonTitles:nil
                              cancelButtonTitle:@"确定"
                         destructiveButtonTitle:nil
                                  actionHandler:nil
                                  cancelHandler:nil
                             destructiveHandler:nil] showAnimated:YES completionHandler:nil];
        }
    }
}


#pragma mark - UITableViewDelegate and UITableViewDataScore

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section ? (self.menuSelectIndex == 0 ? self.schoolData.data.count : self.communityData.data.count) : self.homeModel.post.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        if (self.menuSelectIndex == 1) {
            EHCommunityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EHCommunityCell"];
            Community * model = self.communityData.data[indexPath.row];
            [cell configModel:model];
            return cell;
        }
        else
        {
            EHHomeSchoolCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EHHomeSchoolCell"];
            School * model = self.schoolData.data[indexPath.row];
            [cell configModel:model];
            return cell;
        }
    }else{
        if (indexPath.row<self.homeModel.post.count) {
            EHNewPostCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EHNewPostCell"];
            [cell configModel:self.homeModel.post[indexPath.row]];
            return cell;
        }else{
            EHCategaryCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EHCategaryCell"];
            return  cell;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        return 60;
    }else{
        if (indexPath.row<self.homeModel.post.count) {
            return 60;
        }else{
            return 50;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 110 : 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return section == 0 ? self.bannerView : self.selectMenuView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 70;
    }else
    {
        return 0.000001;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return self.headerMenuView;
    }else{
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 0.001)];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        if (self.menuSelectIndex == 1) {
            Community * model = self.communityData.data[indexPath.row];
            NSString * url = [NSString stringWithFormat:@"GD://postList/?cid=%li",model.cid];
            [[GDRouter sharedInstance] open:url animated:YES extraParams:@{@"ptitle":model.c_name}];
        }
        else
        {
            School * model = self.schoolData.data[indexPath.row];
            NSString * url = [NSString stringWithFormat:@"GD://postList/?sid=%li",model.id];
            [[GDRouter sharedInstance] open:url animated:YES extraParams:@{@"ptitle":model.name}];
        }
    }
    if (indexPath.section == 0) {
        if (indexPath.row<self.homeModel.post.count) {
            PostInfo * post = [self.homeModel.post objectAtIndex:indexPath.row];
            [[GDRouter sharedInstance] open:@"GD://postDetail" extraParams:@{@"post":post}];
        }
    }
}

#pragma mark - typeButton did select Action!

- (void)typeSelectAction:(UIButton *)sender

{
    [self.typeButton setTitleColor:TEMCOLOR forState:UIControlStateNormal];
    [self.locationButton setTitleColor:UIColorHex(0x888888) forState:UIControlStateNormal];
    self.menuSelectIndex = 0;
}

- (void)locationSelectAction:(UIButton *)sender

{
    [self.typeButton setTitleColor:UIColorHex(0x888888) forState:UIControlStateNormal];
    [self.locationButton setTitleColor:TEMCOLOR forState:UIControlStateNormal];
    self.menuSelectIndex = 1;
}

#pragma mark - getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BGCOLOR;
    }
    return _tableView;
}

- (WFLoopShowView *)bannerView
{
    if (!_bannerView) {
        
        CGRect rect = CGRectMake(0, 0, Screen_Width, 110);
        _bannerView = [[WFLoopShowView alloc] initWithFrame:rect image:nil animationDuration:4.7];
        
    }
    return _bannerView;
}

- (EHUserButton *)userButton
{
    if (!_userButton) {
        _userButton = [[EHUserButton alloc] init];
        _userButton.frame = CGRectMake(0, 0, 30, 30);
        _userButton.layer.cornerRadius = 15;
        _userButton.layer.masksToBounds = YES;
        _userButton.clipsToBounds = YES;
        
        UIImageView * userIcon = [[UIImageView alloc] initWithFrame:_userButton.bounds];
        [_userButton addSubview:userIcon];
        _userButton.userIcon = userIcon;
        
        if (ISLOGIN) {
            [_userButton.userIcon yy_setImageWithURL:[NSURL URLWithString:USER.avatar] options:YYWebImageOptionProgressiveBlur];
        }else{
            [_userButton.userIcon setImage:[UIImage imageNamed:@"tab_me"]];
        }
        
    }
    return _userButton;
}

- (UIView *)selectMenuView
{
    if (!_selectMenuView) {
        _selectMenuView = [[UIView alloc] init];
        _selectMenuView.frame = CGRectMake(0, 0, Screen_Width, 80);
        
        UIButton * typeButton = [[UIButton alloc] init];
        self.typeButton = typeButton;
        UIButton * locationButton = [[UIButton alloc] init];
        self.locationButton = locationButton;
        typeButton.frame = CGRectMake(0, 0, Screen_Width/2.0, 45);
        typeButton.backgroundColor = [UIColor whiteColor];
        [typeButton setTitle:@"学校" forState:UIControlStateNormal];
        [typeButton setTitleColor:TEMCOLOR forState:UIControlStateNormal];
        typeButton.titleLabel.font = [UIFont systemFontOfSize:21];
        [_selectMenuView addSubview:typeButton];
        
        locationButton.frame = CGRectMake(Screen_Width/2.0, 0, Screen_Width/2.0, 45);
        locationButton.backgroundColor = [UIColor whiteColor];
        [locationButton setTitle:@"分类" forState:UIControlStateNormal];
        [locationButton setTitleColor:UIColorHex(0x888888) forState:UIControlStateNormal];
        locationButton.titleLabel.font = [UIFont systemFontOfSize:21];
        [_selectMenuView addSubview:locationButton];
        
        UILabel * countLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, Screen_Width, 35)];
        countLable.text = @"";
        countLable.textAlignment = NSTextAlignmentCenter;
        countLable.font = [UIFont fontWithName:@"Marker Felt" size:14];
        
        countLable.textColor = UIColorHex(0x887977);
        [_selectMenuView addSubview:countLable];
        self.selectMenuViewCountLable = countLable;
        
        [typeButton addTarget:self action:@selector(typeSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [locationButton addTarget:self action:@selector(locationSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _selectMenuView;
}


- (GDDropMenu *)locationMenu
{
    if (!_locationMenu) {
        
        _locationMenu = [[GDDropMenu alloc] initOrg:CGPointMake(0, 0) inView:self.view];
        _locationMenu.delegate = self;
        
    }
    return _locationMenu;
}

- (EHHomeHeaderView *)headerMenuView
{
    if (!_headerMenuView) {
        _headerMenuView = [EHHomeHeaderView viewFromNib];
    }
    return _headerMenuView;
}

#pragma mark - GDDropMenuDelegate

- (NSInteger)menu:(GDDropMenu *)menu numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        Area * aera = self.areaData.data[section-1];
        return aera.city.count;
    }
}

- (NSString *)menu:(GDDropMenu *)menu titleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return @"全部";
    }
    else
    {
        Area * aera = self.areaData.data[indexPath.section-1];
        City * city = aera.city[indexPath.row];
        return city.cityNameCH;
    }
}

- (NSInteger)numberOfSectionsInMenu:(GDDropMenu *)menu
{
    return self.areaData.data.count+1;
}

- (NSString *)menu:(GDDropMenu *)menu titleForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        Area * aera = self.areaData.data[section-1];
        return aera.provinceNameCH;
    }else{
        return nil;
    }
}

- (void)menu:(GDDropMenu *)menu didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        [self.getSchoolListRequest.params removeObjectForKey:@"cityId"];
        self.city = nil;
        [self.titleButton reloadTitle:@"全部地区"];
    }
    else
    {
        Area * aera = self.areaData.data[indexPath.section-1];
        City * city = aera.city[indexPath.row];
        self.city = city;
        [self.titleButton reloadTitle:city.cityNameCH];
        
    }
}

@end
