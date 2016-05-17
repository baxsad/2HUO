//
//  EHAddressListScene.m
//  2HUO
//
//  Created by iURCoder on 5/6/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHAddressListScene.h"
#import "EHAddressCell.h"
#import "SellerModel.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface EHAddressListScene ()<UITableViewDataSource,UITableViewDelegate>

@property (weak,   nonatomic) IBOutlet UITableView     * tableView;
@property (weak,   nonatomic) IBOutlet UIButton        * ADDAddressButton; // 添加地址按钮
@property (assign, nonatomic) NSInteger                  addressSelectIndex; // 选择的地址下标

@property (nonatomic, strong) GDReq                    * getAddressListRequest;
@property (nonatomic, strong) GDReq                    * updateAddressListRequest;
@property (nonatomic, strong) SellerModels             * sellerModels;
@property (nonatomic, strong) SellerModel              * selectModel;

@end

@implementation EHAddressListScene



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.getAddressListRequest.requestNeedActive = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.title=@"信息";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName: NSStringFromClass([EHAddressCell class]) bundle:nil] forCellReuseIdentifier:@"EHAddressCell"];
    
    self.getAddressListRequest = [GDRequest getAddressListRequest];
    [self.getAddressListRequest.params setValue:USER.uid forKey:@"uid"];
    [self.getAddressListRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
            }
            self.sellerModels = [[SellerModels alloc] initWithDictionary:req.output error:nil];
            [self.tableView reloadData];
        }
        if (req.failed) {
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
            }
        }
    }];
    
    self.updateAddressListRequest = [GDRequest updateAddressRequest];
    [self.updateAddressListRequest.params setValue:USER.uid forKey:@"uid"];
    [self.updateAddressListRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateAddressInfo" object:self.selectModel];
            [[GDRouter sharedInstance] pop];
        }
        if (req.failed) {
            NSLog(@"sss%@",req.message);
        }
    }];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView setDefaultGifRefreshWithHeader:header];
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    [self.ADDAddressButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        [[GDRouter sharedInstance] open:@"GD://addAddress/?status=1"];
    }];
    
}

- (void)loadNewData
{
    self.getAddressListRequest.requestNeedActive = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sellerModels.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EHAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EHAddressCell"];
    SellerModel * model = self.sellerModels.data[indexPath.row];
    if (model.defaultAddress == 1) {
        self.selectModel = model;
    }
    [cell reloadAddressInfo:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.selectCallBack = ^(SellerModel * model,int aid,BOOL def)
    {
        if (!def) {
            self.selectModel = model;
            [self.updateAddressListRequest.params setValue:@(aid) forKey:@"aid"];
            [self.updateAddressListRequest.params setValue:@(!def) forKey:@"defaultAddress"];
            self.updateAddressListRequest.requestNeedActive = YES;
        }
    };
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self);
    return [tableView fd_heightForCellWithIdentifier:@"EHAddressCell" configuration:^(id cell) {
        @strongify(self);
        [cell reloadAddressInfo:self.sellerModels.data[indexPath.row]];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SellerModel * model = self.sellerModels.data[indexPath.row];
    [[GDRouter sharedInstance] open:@"GD://addAddress/?status=0" extraParams:@{@"sellerModel":model}];
}


@end
