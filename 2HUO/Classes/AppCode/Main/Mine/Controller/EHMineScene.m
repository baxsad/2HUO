//
//  EHMineScene.m
//  2HUO
//
//  Created by iURCoder on 5/3/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHMineScene.h"
#import "EHMineHeadCell.h"
#import "EHMineMenuCell.h"

@interface EHMineScene ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UIView * footerView;
@property (nonatomic, strong) NSArray* dataArray;

@end

@implementation EHMineScene

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BGCOLOR;
    [self setTitle:@"Me" font:[UIFont boldSystemFontOfSize:17] fontColor:UIColorHex(0x222222)];
    [self showBarButton:NAV_LEFT title:@"Cancle" fontColor:UIColorHex(0x444444)];
    
    self.dataArray = [self titlesAtSection];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EHMineHeadCell class]) bundle:nil] forCellReuseIdentifier:@"EHMineHeadCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EHMineMenuCell class]) bundle:nil] forCellReuseIdentifier:@"EHMineMenuCell"];
    [self.view addSubview:self.tableView];
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"UpdateUserInfo" object:nil] subscribeNext:^(id x) {
        [self.tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    
}

- (NSArray*)titlesAtSection
{
    NSArray* section = @[ @{@"title":@""} ];
    
    NSArray* section1 = @[ @{@"title":@"我喜欢的",@"icon":@"mine_product"},
                           @{@"title":@"我关注的",@"icon":@"mine_wallet"}
                           ];
    
    NSArray* section2 = @[ @{@"title":@"我发布的",@"icon":@"skin_program"},
                           @{@"title":@"我买到的",@"icon":@"mine_order"},
                           @{@"title":@"订单地址",@"icon":@"mine_address"}
                           ];
    
    NSArray* section3 = @[ @{@"title":@"登出",@"icon":@"setEnable"}];
    return @[section, section1, section2 ,section3];
}

- (void)leftButtonTouch
{
    [[GDRouter sharedInstance] pop];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [((NSArray *)self.dataArray[section]) count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        EHMineMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EHMineMenuCell"];
        NSDictionary *dic = self.dataArray[indexPath.section][indexPath.row];
        if (((NSArray *)self.dataArray[indexPath.section]).count == indexPath.row + 1) {
            cell.isLast = YES;
        }
        [cell configWithDic:dic];
        return cell;
    }else{
        EHMineHeadCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EHMineHeadCell"];
        [cell reloadData];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        return 45;
    }else{
        return 125;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0000001;
    }else{
        return 15;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (ISLOGIN) {
            [[GDRouter sharedInstance] open:@"GD://setUserInfo"];
        }else{
            [self showSignScene];
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 2) {
            if (ISLOGIN) {
                [[GDRouter sharedInstance] open:@"GD://addressList"];
            }else
            {
                [self showSignScene];
            }
        }
    }
    if (indexPath.section == 3) {
        [[AccountCenter shareInstance] logout];
        if (!ISLOGIN) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = BGCOLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 0.000001)];
    }
    return _headerView;
}

- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 0.000001)];
    }
    return _footerView;
}

@end
