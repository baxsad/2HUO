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
    self.view.backgroundColor = UIColorHex(0xf2f2f2);
    [self setTitle:@"Me" font:[UIFont boldSystemFontOfSize:17] fontColor:UIColorHex(0x222222)];
    [self showBarButton:NAV_LEFT title:@"Cancle" fontColor:UIColorHex(0x444444)];
    [self showBarButton:NAV_RIGHT title:@"Settings" fontColor:UIColorHex(0x444444)];
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
    
    
}

- (NSArray*)titlesAtSection
{
    NSArray* section = @[ @{@"title":@""} ];
    
    NSArray* section1 = @[ @{@"title":@"我喜欢的",@"icon":@"mine_product"},
                           @{@"title":@"关注的卖家",@"icon":@"mine_wallet"},
                           @{@"title":@"足迹",@"icon":@"skin_program"}
                           ];
    
    NSArray* section2 = @[ @{@"title":@"我的订单",@"icon":@"mine_order"},
                           @{@"title":@"收货地址",@"icon":@"mine_address"}
                           ];
    
    NSArray* section3 = @[ @{@"title":@"设置",@"icon":@"setEnable"}];
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
