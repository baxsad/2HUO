//
//  MFUConfigScene.m
//  2HUO
//
//  Created by iURCoder on 3/23/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFUHomeScene.h"
#import "UIViewController+NJKFullScreenSupport.h"
#import "WFLoopShowView.h"

#import "MFUHomeTBCell.h"
#import "MFUHomeMenuCell.h"

#import "ProductModel.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import "MFJActionSheet.h"
#import "MFJPhotoGroupView.h"

#import <AFNetworking/AFNetworking.h>
#import "YDog.h"
#import "BannerModel.h"
#import "ADDSchooleViewController.h"


@interface MFUHomeScene ()<UITableViewDataSource,UITableViewDelegate,MFUCellDelegate>

@property (nonatomic, strong) UITableView          * tableView;
@property (nonatomic, strong) NJKScrollFullScreen  * scrollProxy;
@property (nonatomic, strong) NSArray              * data;
@property (nonatomic, strong) WFLoopShowView       * bannerView;
@property (nonatomic, strong) MFJActionSheet       * sheet;

@end

@implementation MFUHomeScene

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"@$R#@F$*^?";
    [self showBarButton:NAV_RIGHT title:@"Edit" fontColor:UIColorHex(0xD2B203)];
    [self setupData];
    _scrollProxy = [[NJKScrollFullScreen alloc] initWithForwardTarget:self];
    _scrollProxy.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MFUHomeTBCell class]) bundle:nil] forCellReuseIdentifier:@"MFUHomeTBCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MFUHomeMenuCell class]) bundle:nil] forCellReuseIdentifier:@"MFUHomeMenuCell"];
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
    
    
    
    
    
}


-(void)rightButtonTouch{
    
    ADDSchooleViewController * scene = [[ADDSchooleViewController alloc] init];
    scene.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scene animated:YES];
    
}


- (void)setupData
{
    
    
    
    NSMutableArray *data = [@[] mutableCopy];
    for (NSUInteger i = 0; i < 10; i++) {
        ProductModel * model = [[ProductModel alloc] init];
        model.desc = @"昨晚坐MU5160从北京飞往上海把卡包落在了飞机上（黑色卡包，里面有各大银行各式各样的黑卡），哪位好心人捡到了请联系我助理 15101143311 思聪必有重谢。😭😭😭";
        model.productImages = @[@"http://ww2.sinaimg.cn/bmiddle/a15b4afegw1eueu5fdlzlj20xc0xcq83",
                                @"http://ww2.sinaimg.cn/bmiddle/a15b4afegw1es9mk18gwxj20xc0xcqd7",
                                @"http://ww2.sinaimg.cn/bmiddle/a15b4afegw1exewl2ixflj20xb0xcgsx",
                                @"http://ww2.sinaimg.cn/bmiddle/a15b4afegw1ekmwr1mfy3j20xc0xc7iy",
                                @"http://ww2.sinaimg.cn/bmiddle/a15b4afegw1ey0w3n9zv4j20xc0xctj5",
                                @"http://ww2.sinaimg.cn/bmiddle/a15b4afegw1eknha9qvfaj20xc0p0473",
                                @"http://ww2.sinaimg.cn/bmiddle/a15b4afegw1exewgr3su4j20xc0xcdn9",
                                @"http://ww2.sinaimg.cn/bmiddle/a15b4afegw1enlbc2m25lj20p00xcdjb",
                                @"http://ww2.sinaimg.cn/bmiddle/a15b4afegw1enoi58suy0j20m80xcq7k"];
        model.date = @"15 hour ago";
        [data addObject:model];
    }
    _data = [data copy];
}

#pragma mark -
#pragma mark NJKScrollFullScreenDelegate

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollUp:(CGFloat)deltaY
{
    [self moveNavigationBar:deltaY animated:YES];
    [self moveToolbar:-deltaY animated:YES]; // move to revese direction
}

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollDown:(CGFloat)deltaY
{
    [self moveNavigationBar:deltaY animated:YES];
    [self moveToolbar:-deltaY animated:YES];
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollUp:(NJKScrollFullScreen *)proxy
{
    [self hideNavigationBar:YES];
    [self hideToolbar:YES];
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollDown:(NJKScrollFullScreen *)proxy
{
    [self showNavigationBar:YES];
    [self showToolbar:YES];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [_scrollProxy reset];
    [self showNavigationBar:YES];
    [self showToolbar:YES];
}


#pragma mark - UITableViewDelegate and UITableViewDataScore

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section ? _data.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section) {
        MFUHomeTBCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MFUHomeTBCell"];
        cell.delegate = self;
        [cell configModel:[_data objectAtIndex:indexPath.row]];
        NSString * rowStr = [NSString stringWithFormat:@"%li%li",indexPath.section+1,indexPath.row];
        cell.row = [rowStr integerValue];
        return cell;
    }else{
        MFUHomeMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MFUHomeMenuCell"];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section ? [tableView fd_heightForCellWithIdentifier:@"MFUHomeTBCell" cacheByIndexPath:indexPath configuration:^(MFUHomeTBCell * cell) {
        [cell configModel:[_data objectAtIndex:indexPath.row]];
    }] : Screen_Width*0.5;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? Screen_Width/15*6 : 10;
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

- (void)MFUHomeTBCell:(MFUHomeTBCell *)cell moreButtonDidSelect:(ProductModel *)model
{
    
    [self.sheet showInView:[UIApplication sharedApplication].keyWindow animated:YES];
    
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = (id)_scrollProxy;
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
        CGRect rect = CGRectMake(0, 0, Screen_Width, Screen_Width/15*6);
        _bannerView = [[WFLoopShowView alloc] initWithFrame:rect image:nil animationDuration:2.7];
        
    }
    return _bannerView;
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
