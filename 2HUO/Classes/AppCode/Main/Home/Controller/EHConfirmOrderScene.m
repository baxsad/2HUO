//
//  EHConfirmOrderScene.m
//  2HUO
//
//  Created by iURCoder on 5/17/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHConfirmOrderScene.h"
#import "EHOrderAddressCell.h"
#import "EHOrderInfoCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "OrderModel.h"
#import "EHOrdelDetailScene.h"
#import "LGAlertView.h"

@interface EHConfirmOrderScene ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,   weak) IBOutlet UITableView    * tableView;
@property (nonatomic,   weak) IBOutlet UIButton       * submitOrderButton;
@property (nonatomic,   weak) IBOutlet UILabel        * totalPriceLable;
@property (nonatomic,   weak) IBOutlet UIView         * toolBar;

@property (nonatomic, strong) GDReq                   * getOrderRequest;
@property (nonatomic, strong) GDReq                   * makeOrderRequest;
@property (nonatomic, strong) GDReq                   * updateOrderAddressRequest;
@property (nonatomic, strong) OrderModel              * orderModel;
@property (nonatomic, strong) SellerModel             * updateAddress;

@end

@implementation EHConfirmOrderScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    self.view.backgroundColor = BGCOLOR;
    self.tableView.backgroundColor = BGCOLOR;
    [GDHUD showCustomLoadingViewWithView:self.view];
    self.toolBar.alpha = 1;
    self.tableView.alpha = 0;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOrderAddressCell" bundle:nil] forCellReuseIdentifier:@"EHOrderAddressCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOrderInfoCell" bundle:nil] forCellReuseIdentifier:@"EHOrderInfoCell"];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 15)];
    
    @weakify(self);
    self.getOrderRequest = [GDRequest getOrderRequest];
    [self.getOrderRequest.params setValue:self.oid forKey:@"oid"];
    self.getOrderRequest.requestNeedActive = YES;
    [self.getOrderRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            
            self.orderModel = [[OrderModel alloc] initWithDictionary:req.output[@"data"] error:nil];
            [self.makeOrderRequest.params setValue:@(self.orderModel.productInfo.pid) forKey:@"pid"];
            [self.updateOrderAddressRequest.params setValue:@(self.orderModel.oid) forKey:@"oid"];
            
            [self.tableView reloadData];
            self.totalPriceLable.text = [NSString stringWithFormat:@"%.2f",self.orderModel.productInfo.presentPrice+self.orderModel.productInfo.shippingCount].processingPrice;
            
            [GDHUD hideUIBlockingIndicator];
            [UIView animateWithDuration:0.125 animations:^{
                self.tableView.alpha = 1;
                self.toolBar.alpha = 1;
            }];
        }
        if (req.failed) {
            [[[LGAlertView alloc] initWithTitle:@"提示"
                                        message:@"获取订单信息失败~"
                                          style:LGAlertViewStyleAlert
                                   buttonTitles:nil
                              cancelButtonTitle:@"确定"
                         destructiveButtonTitle:nil
                                  actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                                      NSLog(@"actionHandler, %@, %lu", title, (long unsigned)index);
                                  }
                                  cancelHandler:^(LGAlertView *alertView) {
                                      [self leftButtonTouch];
                                  }
                             destructiveHandler:^(LGAlertView *alertView) {
                                 NSLog(@"destructiveHandler");
                             }] showAnimated:YES completionHandler:nil];
        }
    }];
    
    
    self.makeOrderRequest = [GDRequest makeOrderRequest];
    [self.makeOrderRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            // 可以购买
            [GDHUD hideUIBlockingIndicator];
            EHOrdelDetailScene * scene = [[EHOrdelDetailScene alloc] init];
            scene.oid = [NSString stringWithFormat:@"%li",self.orderModel.oid];
            scene.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:scene animated:YES];

        }
        if (req.failed) {
            // 不可以购买
            [GDHUD hideUIBlockingIndicator];
            [[[LGAlertView alloc] initWithTitle:@"提示"
                                        message:@"宝贝已经落入他人之手～"
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
    }];
    [self.submitOrderButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        @strongify(self);
        if (!ISLOGIN) {
            [self showSignScene];
        }
        else
        {
            if (self.orderModel) {
                [GDHUD showUIBlockingIndicator];
                [self.makeOrderRequest.params setValue:USER.uid forKey:@"uid"];
                [self.makeOrderRequest.params setValue:@(self.orderModel.oid) forKey:@"oid"];
                self.makeOrderRequest.requestNeedActive = YES;
            }
            
        }
    }];
    
    self.updateOrderAddressRequest = [GDRequest updateOrderAddressRequest];
    [self.updateOrderAddressRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            if (self.updateAddress) {
                self.orderModel.buyerAddress = self.updateAddress;
                [self.tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        if (req.failed) {
            [GDHUD showMessage:@"更新地址失败" timeout:1];
        }
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"updateConfirmOrderAddress" object:nil] subscribeNext:^(NSNotification * x) {
        SellerModel * address = x.object;
        self.updateAddress = address;
        [self.updateOrderAddressRequest.params setValue:@(self.updateAddress.aid) forKey:@"aid"];
        self.updateOrderAddressRequest.requestNeedActive = YES;
    }];
    
}

- (void)leftButtonTouch
{
    [super leftButtonTouch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        EHOrderAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EHOrderAddressCell"];
        [cell configModel:self.orderModel.buyerAddress];
        return cell;
    }
    if (indexPath.row == 1) {
        EHOrderInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EHOrderInfoCell"];
        [cell configModel:self.orderModel.productInfo];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [tableView fd_heightForCellWithIdentifier:@"EHOrderAddressCell" cacheByIndexPath:indexPath configuration:^(EHOrderAddressCell * cell) {
            [cell configModel:self.orderModel.buyerAddress];
        }];
    }
    if (indexPath.row == 1) {
        return [tableView fd_heightForCellWithIdentifier:@"EHOrderInfoCell" cacheByIndexPath:indexPath configuration:^(EHOrderInfoCell * cell) {
            [cell configModel:self.orderModel.productInfo];
        }];
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [[GDRouter sharedInstance] open:@"GD://addressList" extraParams:@{@"confirm":@(1)}];
    }
    if (indexPath.row == 1) {
        [[GDRouter sharedInstance] open:@"GD://postDetail" extraParams:@{@"pid":[NSString stringWithFormat:@"%li",self.orderModel.productInfo.pid]}];
    }
}

@end
