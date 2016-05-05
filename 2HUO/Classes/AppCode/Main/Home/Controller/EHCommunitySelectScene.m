//
//  EHCommunitySelectScene.m
//  2HUO
//
//  Created by iURCoder on 5/4/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHCommunitySelectScene.h"
#import "EHCommunitySelectCell.h"
#import "Communitys.h"

@interface EHCommunitySelectScene ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) Communitys           * communityData;

@end

@implementation EHCommunitySelectScene

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.communityData = [[TMCache sharedCache] objectForKey:@"Community"];
    self.view.backgroundColor = UIColorHex(0xf2f2f2);
    self.title = @"分类";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"EHCommunitySelectCell" bundle:nil] forCellReuseIdentifier:@"EHCommunitySelectCell"];
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.communityData.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EHCommunitySelectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EHCommunitySelectCell"];
    Community * model = self.communityData.data[indexPath.row];
    [cell configModel:model];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * header = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, Screen_Width-30, 45)];
    header.text = @"    商品种类";
    header.font = [UIFont systemFontOfSize:14];
    header.textColor = UIColorHex(0x999999);
    header.backgroundColor = [UIColor clearColor];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Community * model = self.communityData.data[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectComunity" object:model];
    [[GDRouter sharedInstance] pop];
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

@end
