//
//  EHSchoolScene.m
//  2HUO
//
//  Created by iURCoder on 5/5/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHSchoolScene.h"
#import "School.h"
#import "EHSchoolCell.h"

@interface EHSchoolScene ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView  * tableView;
@property (nonatomic, strong) GDReq        * getSchoolListRequest;
@property (nonatomic, strong) SchooData    * schoolData;

@end

@implementation EHSchoolScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BGCOLOR;
    self.title = @"学校";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"EHSchoolCell" bundle:nil] forCellReuseIdentifier:@"EHSchoolCell"];
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
    
    self.getSchoolListRequest = [GDRequest getSchoolListRequest];
    [self.getSchoolListRequest.params setValue:@"all" forKey:@"type"];
    self.getSchoolListRequest.requestNeedActive = YES;
    [self.getSchoolListRequest listen:^(GDReq * _Nonnull req) {
        self.schoolData = [[SchooData alloc] initWithDictionary:req.output error:nil];
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.schoolData.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EHSchoolCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EHSchoolCell"];
    School * model = self.schoolData.data[indexPath.row];
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
    header.text = @"    学校名字";
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
    School * model = self.schoolData.data[indexPath.row];
    [[GDRouter sharedInstance] pop];
    [GDRouter sharedInstance].send(model);
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

@end
