//
//  EHOrdelDetailScene.m
//  2HUO
//
//  Created by iURCoder on 5/20/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHOrdelDetailScene.h"
#import "EHOrderStatusView.h"
#import "EHOrderAddressCell.h"
#import "EHOrderNumberCell.h"
#import "EHOrderInfoCell.h"
#import "EHOrderPayCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "OrderModel.h"
#import "LGAlertView.h"

@interface EHOrdelDetailScene ()<UITableViewDelegate,UITableViewDataSource>

@property (weak,   nonatomic)  IBOutlet UITableView    * tableView;
@property (weak,   nonatomic)  IBOutlet UIView         * immediatelyPayBgView;
@property (weak,   nonatomic)  IBOutlet UIButton       * immediatelyPayButton;
@property (nonatomic, strong) EHOrderStatusView          * headerView;

@property (nonatomic, strong) GDReq                   * getOrderRequest;
@property (nonatomic, strong) GDReq                   * cancleOrderRequest;
@property (nonatomic, strong) GDReq                   * updateOrderAddressRequest;
@property (nonatomic, strong) OrderModel              * orderModel;
@property (nonatomic, strong) SellerModel             * updateAddress;

@property (nonatomic, assign) NSInteger                 paySelectIndex;

@property (nonatomic, weak) IBOutlet UILabel * totalPrice;

@end

@implementation EHOrdelDetailScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BGCOLOR;
    self.tableView.backgroundColor = BGCOLOR;
    self.tableView.alpha = 0;
    self.immediatelyPayBgView.alpha = 0;
    self.title = @"订单信息";
    self.paySelectIndex = 0;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOrderNumberCell" bundle:nil] forCellReuseIdentifier:@"EHOrderNumberCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOrderAddressCell" bundle:nil] forCellReuseIdentifier:@"EHOrderAddressCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOrderInfoCell" bundle:nil] forCellReuseIdentifier:@"EHOrderInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOrderPayCell" bundle:nil] forCellReuseIdentifier:@"EHOrderPayCell"];
    
    @weakify(self);
    self.cancleOrderRequest = [GDRequest cancleOrderRequest];
    [self.cancleOrderRequest.params setValue:USER.uid forKey:@"uid"];
    [self.cancleOrderRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            self.getOrderRequest.requestNeedActive = YES;
        }
        if (req.failed) {
            [GDHUD showMessage:@"出现了一点错误" timeout:1];
        }
    }];
    
    self.getOrderRequest = [GDRequest getOrderRequest];
    [self.getOrderRequest.params setValue:self.oid forKey:@"oid"];
    self.getOrderRequest.requestNeedActive = YES;
    [self.getOrderRequest listen:^(GDReq * _Nonnull req) {
        @strongify(self);
        if (req.succeed) {
            
            self.orderModel = [[OrderModel alloc] initWithDictionary:req.output[@"data"] error:nil];
            [self.cancleOrderRequest.params setValue:@(self.orderModel.oid) forKey:@"oid"];
            [self reloadHeader];
            [self reloadNavButton];
            [self.tableView reloadData];
            [self.updateOrderAddressRequest.params setValue:@(self.orderModel.oid) forKey:@"oid"];
            self.totalPrice.text = [NSString stringWithFormat:@"%.2f",self.orderModel.productInfo.presentPrice+self.orderModel.productInfo.shippingCount].processingPrice;
            [GDHUD hideUIBlockingIndicator];
            [UIView animateWithDuration:0.125 animations:^{
                self.tableView.alpha = 1;
                self.immediatelyPayBgView.alpha = 1;
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
    
    self.updateOrderAddressRequest = [GDRequest updateOrderAddressRequest];
    [self.updateOrderAddressRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            if (self.updateAddress) {
                self.orderModel.buyerAddress = self.updateAddress;
                [self.tableView reloadRow:1 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        if (req.failed) {
            [GDHUD showMessage:@"更新地址失败" timeout:1];
        }
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"updateDetailOrderAddress" object:nil] subscribeNext:^(NSNotification * x) {
        SellerModel * address = x.object;
        self.updateAddress = address;
        [self.updateOrderAddressRequest.params setValue:@(self.updateAddress.aid) forKey:@"aid"];
        self.updateOrderAddressRequest.requestNeedActive = YES;
    }];
    
}

- (void)rightButtonTouch
{
    if (self.orderModel.status == 1001 || self.orderModel.status == 1002 || self.orderModel.status == 1006) {
        self.cancleOrderRequest.requestNeedActive = YES;
    }
    if (self.orderModel.status == 1004) {
        // 申请售后
    }
}

- (void)reloadNavButton
{
    if (self.orderModel.status == 1001 || self.orderModel.status == 1002 || self.orderModel.status == 1006) {
        [self showBarButton:NAV_RIGHT title:@"取消订单" fontColor:TEMCOLOR];
    }else if (self.orderModel.status == 1004){
        [self showBarButton:NAV_RIGHT title:@"申请售后" fontColor:TEMCOLOR];
    }else{
        [self showBarButton:NAV_RIGHT title:@"" fontColor:TEMCOLOR];
    }
    
    if (self.orderModel.status == 1002) {
        self.immediatelyPayBgView.hidden = NO;
    }else{
        self.immediatelyPayBgView.hidden = YES;
    }
}

- (void)reloadHeader
{
    switch (self.orderModel.status) {
        case 1001:
        {
            [self.headerView reloadTopViewInfoWithTitle:@"待确认订单" Des:@"订单等待确认"];
        }
            break;
        case 1002:
        {
            [self.headerView reloadTopViewInfoWithTitle:@"交易中" Des:@"订单正在处理中"];
        }
            break;
        case 1003:
        {
            [self.headerView reloadTopViewInfoWithTitle:@"已取消" Des:@"订单已经取消"];
        }
            break;
        case 1004:
        {
            [self.headerView reloadTopViewInfoWithTitle:@"已完成" Des:@"订单已经完成"];
        }
            break;
        case 1005:
        {
            [self.headerView reloadTopViewInfoWithTitle:@"售后处理中" Des:@"订单正在售后处理中"];
        }
            break;
        case 1006:
        {
            [self.headerView reloadTopViewInfoWithTitle:@"超时未处理" Des:@"订单超时未处理，已经取消"];
        }
            break;
        
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 30)];
    lable.text = @"    支付方式";
    lable.textColor = UIColorHex(0x888888);
    lable.font = [UIFont systemFontOfSize:14];
    lable.backgroundColor = UIColorHex(0xffffff);
    lable.clipsToBounds = YES;
    UIView * bottomLile = [[UIView alloc] initWithFrame:CGRectMake(0, 45-1.0/ScreenScale, Screen_Width, 1.0/ScreenScale)];
    bottomLile.backgroundColor = UIColorHex(0xf2f2f2);
    [lable addSubview:bottomLile];
    return section ? ((self.orderModel.status == 1002 && (self.orderModel.saleAddress.alipay.isNotEmpty || self.orderModel.saleAddress.weixin.isNotEmpty)) ? lable : nil) : self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section ? ((self.orderModel.status == 1002 && (self.orderModel.saleAddress.alipay.isNotEmpty || self.orderModel.saleAddress.weixin.isNotEmpty)) ? 45 : 0) : 63;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.orderModel.status == 1002) {
        return 2;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    if (section == 1) {
        if (self.orderModel.saleAddress.alipay.isNotEmpty && self.orderModel.saleAddress.weixin.isNotEmpty) {
            return 2;
        }
        if (!self.orderModel.saleAddress.alipay.isNotEmpty && !self.orderModel.saleAddress.weixin.isNotEmpty) {
            return 0;
        }else{
            return 1;
        }
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            EHOrderNumberCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EHOrderNumberCell"];
            [cell reloadOrderNumber:self.orderModel];
            return cell;
        }
        if (indexPath.row == 1) {
            EHOrderAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EHOrderAddressCell"];
            [cell configModel:self.orderModel.buyerAddress];
            if (self.orderModel.status == 1002) {
                [cell setArrowHiden:NO];
            }else{
                [cell setArrowHiden:YES];
            }
            return cell;
        }
        if (indexPath.row == 2) {
            EHOrderInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EHOrderInfoCell"];
            [cell configModel:self.orderModel.productInfo];
            return cell;
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            EHOrderPayCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EHOrderPayCell"];
            if (self.orderModel.saleAddress.alipay.isNotEmpty) {
                // 支付宝
                [cell configModel:@"alipay"];
            }else{
                // 微信
                [cell configModel:@"weixin"];
            }
            if (self.paySelectIndex == 0) {
                cell.isSelect = YES;
            }else{
                cell.isSelect = NO;
            }
            return cell;
        }
        if (indexPath.row == 1) {
            EHOrderPayCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EHOrderPayCell"];
            
            // 微信
            [cell configModel:@"weixin"];
            if (self.paySelectIndex == 1) {
                cell.isSelect = YES;
            }else{
                cell.isSelect = NO;
            }
            return cell;
        }else{
            return nil;
        }
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 75;
        }
        if (indexPath.row == 1) {
            return [tableView fd_heightForCellWithIdentifier:@"EHOrderAddressCell" cacheByIndexPath:indexPath configuration:^(EHOrderAddressCell * cell) {
                [cell configModel:self.orderModel.buyerAddress];
            }];
        }
        if (indexPath.row == 2) {
            return [tableView fd_heightForCellWithIdentifier:@"EHOrderInfoCell" cacheByIndexPath:indexPath configuration:^(EHOrderInfoCell * cell) {
                [cell configModel:self.orderModel.productInfo];
            }];
        }
    }
    if (indexPath.section == 1) {
        return 60;
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            if (self.orderModel.status == 1002) {
                [[GDRouter sharedInstance] open:@"GD://addressList" extraParams:@{@"orderDetail":@(1)}];
            }
        }
        if (indexPath.row == 2) {
            [[GDRouter sharedInstance] open:@"GD://postDetail" extraParams:@{@"pid":[NSString stringWithFormat:@"%li",self.orderModel.productInfo.pid]}];
        }
    }
    if (indexPath.section == 1) {
        self.paySelectIndex = indexPath.row;
        [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (EHOrderStatusView *)headerView
{
    if (!_headerView) {
        _headerView = [EHOrderStatusView viewFromNib];
    }
    return _headerView;
}

@end
