//
//  EHOrderListScene.m
//  2HUO
//
//  Created by iURCoder on 5/18/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHOrderListScene.h"
#import "EHMyOrderCell.h"
#import "OrderListModel.h"
#import "EHOrdelDetailScene.h"

@interface EHOrderListScene ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView * tableView;

@property (nonatomic, strong) GDReq * getOrderListRequest;
@property (nonatomic, strong) NSMutableArray * orderListData;

@end

@implementation EHOrderListScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    
    self.view.backgroundColor = BGCOLOR;
    self.tableView.backgroundColor = BGCOLOR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"EHMyOrderCell" bundle:nil] forCellReuseIdentifier:@"EHMyOrderCell"];
    self.tableView.rowHeight = 200;
    self.orderListData = @[].mutableCopy;
    
    self.getOrderListRequest = [GDRequest getOrderListRequest];
    [self.getOrderListRequest.params setValue:USER.uid forKey:@"uid"];
    [self.getOrderListRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            OrderListModel * model = [[OrderListModel alloc] initWithDictionary:req.output error:nil];
            if ([self.tableView.mj_header isRefreshing]) {
                [self.orderListData removeAllObjects];
                [self.orderListData addObjectsFromArray:model.data];
            }
            if ([self.tableView.mj_footer isRefreshing]) {
                [self.orderListData addObjectsFromArray:model.data];
            }
            [self.tableView reloadData];
            if ([self.tableView.mj_header isRefreshing]) {
                [self.tableView.mj_header endRefreshing];
            }
            if ([self.tableView.mj_footer isRefreshing]) {
                [self.tableView.mj_footer endRefreshing];
            }
        }
        if (req.failed) {
            if ([self.tableView.mj_header isRefreshing]) {
                [self.tableView.mj_header endRefreshing];
            }
            if ([self.tableView.mj_footer isRefreshing]) {
                [self.tableView.mj_footer endRefreshing];
            }
        }
    }];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView setDefaultGifRefreshWithHeader:header];
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableView setDefaultGifRefreshWithFooter:footer];
    self.tableView.mj_footer = footer;
    
}

- (void)loadNewData
{
    [self.getOrderListRequest.params removeObjectForKey:@"lastId"];
    self.getOrderListRequest.requestNeedActive = YES;
}

- (void)loadMoreData
{
    Order * order = self.orderListData.firstObject;
    [self.getOrderListRequest.params setValue:@(order.oid) forKey:@"lastId"];
    self.getOrderListRequest.requestNeedActive = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderListData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EHMyOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EHMyOrderCell"];
    [cell configModel:self.orderListData[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Order * order = self.orderListData[indexPath.row];
    if (order.status == 1001) {
        [[GDRouter sharedInstance] open:[NSString stringWithFormat:@"GD://confirmOrder/?oid=%li",order.oid]];
    }else{
        EHOrdelDetailScene * scene = [[EHOrdelDetailScene alloc] init];
        scene.oid = [NSString stringWithFormat:@"%li",order.oid];
        scene.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:scene animated:YES];
    }
}

@end
