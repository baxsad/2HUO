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

@interface EHCommunityPostsScene ()<UITableViewDataSource,UITableViewDelegate,EHPostCellDelegate>

@property (nonatomic, strong) UITableView          * tableView;
@property (nonatomic, strong) NSArray              * data;
@property (nonatomic, strong) MFJActionSheet       * sheet;
@property (nonatomic, strong) Post                 * postModel;
@property (nonatomic, strong) GDReq                * getPostListRequest;
@property (nonatomic, strong) GDReq                * likePostRequest;

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
    self.view.backgroundColor = UIColorHex(0xf2f2f2);
    [self showBarButton:NAV_RIGHT title:@"Edit" fontColor:UIColorHex(0xD2B203)];
    self.title = self.ptitle;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EHPostCell class]) bundle:nil] forCellReuseIdentifier:@"EHPostCell"];
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
    
    self.getPostListRequest = [GDRequest getPostListRequest];
    [self.getPostListRequest.params setValue:@(self.cid) forKey:@"cid"];
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
    
}

- (void)loadNewData
{
    self.getPostListRequest.requestNeedActive = YES;
}

-(void)rightButtonTouch{
    
    if (!ISLOGIN) {
        [GDHUD showMessage:@"not login!" timeout:1];
        return;
    }
    [[GDRouter sharedInstance] show:@"mfj://addPost" extraParams:@{@"cid":[NSString stringWithFormat:@"%li",self.cid]} completion:nil];
    
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


@end
