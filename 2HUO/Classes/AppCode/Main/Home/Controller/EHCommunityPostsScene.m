//
//  EHCommunityPostsScene.m
//  2HUO
//
//  Created by iURCoder on 4/26/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHCommunityPostsScene.h"
#import "EHPostCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MFJActionSheet.h"
#import "MFJPhotoGroupView.h"
#import "Post.h"
#import "JSDropDownMenu.h"
#import "Communitys.h"
#import "Area.h"
#import "AeraAndSchool.h"
#import "LGAlertView.h"

@interface EHCommunityPostsScene ()<UITableViewDataSource,UITableViewDelegate,EHPostCellDelegate,JSDropDownMenuDataSource,JSDropDownMenuDelegate>

{
    NSInteger aeraSelectIndex;
    NSInteger schoolSelectIndex;
    NSInteger typeSelectIndex;
}

@property (nonatomic, strong) UITableView          * tableView;
@property (nonatomic, strong) NSArray              * data;
@property (nonatomic, strong) MFJActionSheet       * sheet;
@property (nonatomic, strong) Post                 * postModel;
@property (nonatomic, strong) GDReq                * getPostListRequest;
@property (nonatomic, strong) GDReq                * likePostRequest;
@property (nonatomic, strong) JSDropDownMenu       * dropMenu;

@property (nonatomic, strong) GDReq                * getCommunitysRequest;
@property (nonatomic, strong) GDReq                * getAllCityAndSchoolsRequest;
@property (nonatomic, strong) Communitys           * communitys;
@property (nonatomic, strong) AeraAndSchools       * aeraAndSchool;

@property (nonatomic, strong) UIButton * sendPostButton;

@end

@implementation EHCommunityPostsScene

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"cid:%li",self.cid);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.view.backgroundColor = UIColorHex(0xf2f2f2);
    [self showBarButton:NAV_RIGHT title:@"Edit" fontColor:UIColorHex(0xD2B203)];
    self.title = self.ptitle;
    
    [self.view addSubview:self.sendPostButton];
    [self.sendPostButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(@45);
    }];
    
    UIView * topLine = [[UIView alloc] init];
    topLine.backgroundColor = UIColorHex(0xebebeb);
    [self.sendPostButton addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sendPostButton.mas_top).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(@(1/ScreenScale));
    }];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EHPostCell class]) bundle:nil] forCellReuseIdentifier:@"EHPostCell"];
    [self.view addSubview:self.tableView];
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.sendPostButton.mas_top).offset(0);
        make.right.equalTo(self.view).offset(0);
    }];
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.00001)];
    self.tableView.tableHeaderView = headerView;
    
    self.getPostListRequest = [GDRequest getPostListRequest];
    if (self.cid != 0) {
        [self.getPostListRequest.params setValue:@(self.cid) forKey:@"cid"];
    }
    if (self.sid != 0){
        [self.getPostListRequest.params setValue:@(self.sid) forKey:@"sid"];
    }
    if (ISLOGIN) {
        [self.getPostListRequest.params setValue:USER.uid forKey:@"uid"];
    }else{
        [self.getPostListRequest.params removeObjectForKey:@"uid"];
    }
    [self.getPostListRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            self.postModel = [[Post alloc] initWithDictionary:req.output error:nil];
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
            }
        }
        if (req.failed) {
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
            }
        }
    }];
    
    [RACObserve(self, postModel) subscribeNext:^(id x) {
        [self.tableView reloadData];
    }];
    
    self.likePostRequest = [GDRequest likePostRequest];
    [self.likePostRequest.params setValue:USER.uid forKey:@"uid"];
    [self.likePostRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            NSLog(@"喜欢?不喜欢?成功");
        }
        if (req.failed) {
            NSLog(@"喜欢?不喜欢?失败");
        }
    }];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView setDefaultGifRefreshWithHeader:header];
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ReloadPost" object:nil] subscribeNext:^(id x) {
        self.getPostListRequest.requestNeedActive = YES;
    }];
    
    //** 获取分类 **//
    
    self.getCommunitysRequest = [GDRequest getCommunityListRequest];
    self.getCommunitysRequest.cachePolicy = GDRequestCachePolicyReadCache;
    [self.getCommunitysRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            Communitys * model = [[Communitys alloc] initWithDictionary:req.output error:nil];
            self.communitys = model;
            [[TMCache sharedCache] setObject:model forKey:@"Community"];
            
        }
        if (req.failed) {
            
        }
    }];
    
    self.communitys = [[TMCache sharedCache] objectForKey:@"Community"];
    self.getCommunitysRequest.requestNeedActive = YES;
    
    //** 获取地区和学校 **//
    
    self.getAllCityAndSchoolsRequest = [GDRequest getAreaAndSchoolListRequest];
    [self.getAllCityAndSchoolsRequest listen:^(GDReq * _Nonnull req) {
        if(req.succeed)
        {
            AeraAndSchools * model = [[AeraAndSchools alloc] initWithDictionary:req.output error:nil];
            self.aeraAndSchool = model;
            [[TMCache sharedCache] setObject:model forKey:@"AeraAndSchools"];
        }
    }];
    self.aeraAndSchool = [[TMCache sharedCache] objectForKey:@"AeraAndSchools"];
    self.getAllCityAndSchoolsRequest.requestNeedActive = YES;
}

- (void)loadNewData
{
    self.getPostListRequest.requestNeedActive = YES;
}

-(void)postAction{
    
    if (LOGINandSETSCHOOL) {
        [[GDRouter sharedInstance] show:@"mfj://addPost" extraParams:@{@"cid":@(self.cid),@"sid":@(self.sid)} completion:nil];
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
                                  actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                                      NSLog(@"actionHandler, %@, %lu", title, (long unsigned)index);
                                  }
                                  cancelHandler:^(LGAlertView *alertView) {
                                      NSLog(@"cancelHandler");
                                  }
                             destructiveHandler:^(LGAlertView *alertView) {
                                 NSLog(@"destructiveHandler");
                             }] showAnimated:YES completionHandler:nil];
        }
    }
    
}

#pragma mark - UITableViewDelegate and UITableViewDataScore

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.postModel.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EHPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EHPostCell"];
    cell.delegate = self;
    [cell configModel:[self.postModel.data objectAtIndex:indexPath.row]];
    NSString * rowStr = [NSString stringWithFormat:@"%li%li",indexPath.section+1,indexPath.row];
    cell.row = [rowStr integerValue];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"EHPostCell" cacheByIndexPath:indexPath configuration:^(EHPostCell * cell) {
        [cell configModel:[self.postModel.data objectAtIndex:indexPath.row]];
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 0.001)];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostInfo * post = [self.postModel.data objectAtIndex:indexPath.row];
    [[GDRouter sharedInstance] open:@"GD://postDetail" extraParams:@{@"post":post}];
}

#pragma mark - EHPostCellDelegate

- (void)EHPostCell:(EHPostCell *)cell moreButtonDidSelect:(PostInfo *)model
{
    
    [self.sheet showInView:[UIApplication sharedApplication].keyWindow animated:YES];
    
}

- (void)EHPostCell:(EHPostCell *)cell likeButtonDidSelect:(PostInfo *)model IsLike:(BOOL)like likeCount:(NSInteger)count
{
    if (!ISLOGIN) {
        [self showSignScene];
        return;
    }
    [self.likePostRequest.params setValue:@(model.pid) forKey:@"pid"];
    [self.likePostRequest.params setValue:@(like) forKey:@"isLike"];
    self.likePostRequest.requestNeedActive = YES;
}

#pragma mark - getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorHex(0xf2f2f2);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (MFJActionSheet *)sheet
{
    if (!_sheet) {
        
        MFJActionSheetSection * s1 = [MFJActionSheetSection sectionWithTitle:@"我是第一个分组！" message:@"button列表" buttonTitles:@[@"Report",@"Share to WeiBo",@"Copy Share Url",@"Turn On Post Notifications"] buttonStyle:MFJActionSheetButtonStyleInstagram];
        
        MFJActionSheetSection * s2 = [MFJActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Cancle"] buttonStyle:MFJActionSheetButtonStyleYellow];
        
        
        
        
        [s1 setButtonStyle:MFJActionSheetButtonStyleInstagramRed forButtonAtIndex:0];
        
        
        _sheet = [[MFJActionSheet alloc] initWithSections:@[s1,s2]];
        
        _sheet.buttonClickBlock = ^(MFJActionSheet * sheet , NSIndexPath * indexPath){
            NSLog(@"click:%li,%li",indexPath.section,indexPath.row);
        };
        
    }
    return _sheet;
}

- (JSDropDownMenu *)dropMenu
{
    if (!_dropMenu) {
        _dropMenu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, -1) andHeight:35];
        _dropMenu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
        _dropMenu.separatorColor = [UIColor clearColor];
        _dropMenu.backgroundColor = NAVCOLOR;
        _dropMenu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
        _dropMenu.dataSource = self;
        _dropMenu.delegate = self;
    }
    return _dropMenu;
}

- (UIButton *)sendPostButton
{
    if (!_sendPostButton) {
        _sendPostButton = [[UIButton alloc] init];
        _sendPostButton.backgroundColor = UIColorHex(0xffffff);
        [_sendPostButton setTitle:@"发布" forState:UIControlStateNormal];
        [_sendPostButton setTitleColor:TEMCOLOR forState:UIControlStateNormal];
        _sendPostButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sendPostButton addTarget:self action:@selector(postAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendPostButton;
}

- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 2;
}

-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
    return NO;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    
    if (column==0) {
        return YES;
    }
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    if (column==0) {
        return 0.3;
    }
    
    return 1;
}


- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==0) {
        if (leftOrRight==0) {
            
            return self.aeraAndSchool.data.count;
            
        } else{
            
            AeraAndSchool *model = [self.aeraAndSchool.data objectAtIndex:leftRow];
            
            return [model.school count];
            
        }
    } else if (column==1){
        
        return self.communitys.data.count;
        
    }
    
    return 0;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0: return @"学校";
            break;
        case 1: return @"分类";
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        if (indexPath.leftOrRight==0) {
            AeraAndSchool *model = [self.aeraAndSchool.data objectAtIndex:indexPath.row];
            return model.cityName;
        } else{
            NSInteger leftRow = indexPath.leftRow;
            AeraAndSchool *model = [self.aeraAndSchool.data objectAtIndex:leftRow];
            School *school = model.school[indexPath.row];
            return school.name;
        }
    } else if (indexPath.column==1) {
        
        Community * model = self.communitys.data[indexPath.row];
        return model.c_name;
        
    } else {
        
        return nil;
    }
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    if (column==0) {
        
        return aeraSelectIndex;
        
    }
    if (column==1) {
        
        return typeSelectIndex;
    }
    
    return 0;
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    if (indexPath.column == 0) {
        
        aeraSelectIndex = indexPath.leftRow;
        
        if(indexPath.leftOrRight==0){
            
            schoolSelectIndex = indexPath.row;
            
            return;
        }
        
    } else{
        
        typeSelectIndex = indexPath.row;
        
    }
    
}

@end
