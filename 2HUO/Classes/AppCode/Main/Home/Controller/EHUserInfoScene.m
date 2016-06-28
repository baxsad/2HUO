//
//  EHUserInfoScene.m
//  2HUO
//
//  Created by iURCoder on 5/5/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHUserInfoScene.h"
#import "EHTextFieldCell.h"
#import "EHTextViewCell.h"
#import "EHTitleCell.h"
#import "identityCardCell.h"
#import "LGAlertView.h"
#import "School.h"
#import "SellerModel.h"

@interface EHUserInfoScene ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    BOOL keyboardIsVisible; //键盘是否弹出
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *footerView;
@property (nonatomic, weak) IBOutlet UIButton *saveButton;

@property (strong, nonatomic) NSArray  *placeholders;

@property (strong, nonatomic) RACSubject *nameSignal;
@property (strong, nonatomic) RACSubject *telephoneSignal;
@property (strong, nonatomic) RACSubject *addressSignal;
@property (strong, nonatomic) RACSubject *IDCardSignal;

@property (nonatomic,   copy) NSString *name; // 姓名
@property (nonatomic,   copy) NSString *phone; // 电话
@property (nonatomic, strong) School   *school; // 学校
@property (nonatomic,   copy) NSString *address;// 详细地址
@property (nonatomic,   copy) NSString *IDCard;// 学号

@property (nonatomic, strong) GDReq    * addAddressRequest;
@property (nonatomic, strong) GDReq    * updateAddressRequest;
@property (nonatomic, strong) GDReq    * deleteAddressRequest;
@property (nonatomic, assign) BOOL userInteractionEnabled;

@end

@implementation EHUserInfoScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.title = @"地址管理";
    if (self.sellerModel) {
        self.school = self.sellerModel.school;
    }
    
    [RACObserve(self, status) subscribeNext:^(id x) {
        if (self.status == AddressStatusNone) {
            [self showBarButton:NAV_RIGHT title:@"编辑" fontColor:UIColorHex(0xff5a5f)];
        }
        if (self.status == AddressStatusUpdate) {
            [self showBarButton:NAV_RIGHT title:@"完成" fontColor:UIColorHex(0xff5a5f)];
            [self.saveButton setTitle:@"删除" forState:UIControlStateNormal];
        }
        if (self.status == AddressStatusAdd) {
            [self.saveButton setTitle:@"确认" forState:UIControlStateNormal];
        }
        self.userInteractionEnabled = (self.status == 1 || self.status == 2) ? YES : NO;
    }];
    
    self.userInteractionEnabled = (self.status == 1 || self.status == 2) ? YES : NO;
    
    [RACObserve(self, userInteractionEnabled) subscribeNext:^(id x) {
        self.saveButton.hidden = !_userInteractionEnabled;
    }];
    
    self.saveButton.layer.cornerRadius = 3.0;
    self.saveButton.layer.masksToBounds = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName: NSStringFromClass([EHTextFieldCell class]) bundle:nil] forCellReuseIdentifier:@"EHTextFieldCell"];
    [self.tableView registerNib:[UINib nibWithNibName: NSStringFromClass([EHTextViewCell class]) bundle:nil] forCellReuseIdentifier:@"EHTextViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName: NSStringFromClass([EHTitleCell class]) bundle:nil] forCellReuseIdentifier:@"EHTitleCell"];
    [self.tableView registerNib:[UINib nibWithNibName: NSStringFromClass([identityCardCell class]) bundle:nil] forCellReuseIdentifier:@"identityCardCell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _nameSignal = [RACSubject subject];
    _telephoneSignal = [RACSubject subject];
    _addressSignal = [RACSubject subject];
    _IDCardSignal = [RACSubject subject];
    
    RAC(self,name) = [self.nameSignal startWith:@""];
    RAC(self,phone) = [self.telephoneSignal startWith:@""];
    RAC(self,address) = [self.addressSignal startWith:@""];
    RAC(self,IDCard) = [self.IDCardSignal startWith:@""];
    
    if (!_userInteractionEnabled && self.sellerModel) {
        _placeholders = @[_sellerModel.userName,_sellerModel.phone,_sellerModel.school.name,_sellerModel.location,_sellerModel.numberCard];
    }else{
        _placeholders = @[@"卖家姓名",@"手机号码",@"学校",@"详细地址",@"您的学号信息将被加密，请放心填写"];
    }
    
    self.addAddressRequest = [GDRequest addAddressRequest];
    [self.addAddressRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            [[GDRouter sharedInstance] pop];
        }
        if (req.failed) {
            [GDHUD showMessage:req.output[@"message"] timeout:1];
        }
    }];
    
    self.updateAddressRequest = [GDRequest updateAddressRequest];
    [self.updateAddressRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            [GDHUD hideUIBlockingIndicator];
            [[GDRouter sharedInstance] pop];
        }
        if (req.failed) {
            [GDHUD hideUIBlockingIndicator];
            [GDHUD showMessage:req.output[@"message"] timeout:1];
        }
    }];
    
    self.deleteAddressRequest = [GDRequest deleteAddressRequest];
    [self.deleteAddressRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            [GDHUD hideUIBlockingIndicator];
            [[GDRouter sharedInstance] pop];
        }
        if (req.failed) {
            [GDHUD hideUIBlockingIndicator];
            [GDHUD showMessage:req.output[@"message"] timeout:1];
        }
    }];
    
    /** 监听键盘是否弹出 */
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil] subscribeNext:^(id x) {
        keyboardIsVisible = YES;
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(id x) {
        keyboardIsVisible = NO;
    }];
    
    self.saveButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input){
        
        if (self.status == AddressStatusUpdate) {
            [GDHUD showUIBlockingIndicator];
            [self.deleteAddressRequest.params setObject:@(self.sellerModel.aid) forKey:@"aid"];
            [self.deleteAddressRequest.params setObject:USER.uid forKey:@"uid"];
            self.deleteAddressRequest.requestNeedActive = YES;
            return [RACSignal empty];
        }
        
        if (keyboardIsVisible) {
            [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        }
        if ([self validity]){
            
            self.addAddressRequest.params = @{@"uid":USER.uid,
                                              @"sid":@(self.school.id),
                                              @"name":self.name,
                                              @"phone":self.phone,
                                              @"location":self.address,
                                              @"numberCard":self.IDCard}.mutableCopy;
            self.addAddressRequest.requestNeedActive = YES;
        }
        
        return [RACSignal empty];
    }];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.sellerModel) {
        self.name = _sellerModel.userName;
        self.phone = _sellerModel.phone;
        self.address = _sellerModel.location;
        self.IDCard = _sellerModel.numberCard;
    }
}

- (void)rightButtonTouch
{
    
    if (self.status == AddressStatusNone) {
        self.status = AddressStatusUpdate;
        if (self.school && self.sellerModel) {
            self.school = self.sellerModel.school;
        }

        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0],
                                                 [NSIndexPath indexPathForRow:1 inSection:0],
                                                 [NSIndexPath indexPathForRow:2 inSection:0],
                                                 [NSIndexPath indexPathForRow:3 inSection:0],
                                                 [NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        return;
    }
    if (self.status == AddressStatusUpdate) {
        
        // 编辑完成？
        NSLog(@"编辑完成？");
        if (keyboardIsVisible) {
            [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        }
        if ([self validity]){
            
            [GDHUD showUIBlockingIndicator];
            self.updateAddressRequest.params = @{@"aid":@(self.sellerModel.aid),
                                                 @"uid":USER.uid,
                                                 @"sid":@(self.school.id),
                                                 @"name":self.name,
                                                 @"phone":self.phone,
                                                 @"location":self.address,
                                                 @"numberCard":self.IDCard}.mutableCopy;
            self.updateAddressRequest.requestNeedActive = YES;
            
        }
        return;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 90;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 15;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            EHTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EHTextFieldCell"];
            cell.text = @"";
            cell.placeholder = _placeholders[indexPath.row];
            if (self.userInteractionEnabled){
                cell.text = self.name;
            }
            [cell bindSignal:self.nameSignal];
            cell.userInteractionEnabled = _userInteractionEnabled;
            return cell;
            
            break;
        }
        case 1:{
            EHTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EHTextFieldCell"];
            cell.text = @"";
            cell.placeholder = _placeholders[indexPath.row];
            if (self.userInteractionEnabled){
                cell.text = self.phone;
            }
            [cell setKeyBoardType:UIKeyboardTypePhonePad];
            [cell bindSignal:self.telephoneSignal];
            cell.userInteractionEnabled = _userInteractionEnabled;
            return cell;
            break;
        }
        case 2:{
            EHTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EHTitleCell"];
            if (self.userInteractionEnabled && !self.sellerModel) {
                [cell setTitle:_school ? _school.name : _placeholders[indexPath.row]];
            }else{
                if (self.userInteractionEnabled) {
                    [cell setTitle:_school ? _school.name : _placeholders[indexPath.row]];
                }else{
                    [cell setTitle:_placeholders[indexPath.row]];
                }
            }
            [cell setTitleColor:RGBA(102.0, 102.0, 102.0, 1)];
            [cell setTitleFont:[UIFont systemFontOfSize:15]];
            [cell setContenAlignment:NSTextAlignmentLeft];
            [cell setLeftMarginWith:15.0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = _userInteractionEnabled;
            return cell;
            break;
        }
        case 3:{
            EHTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EHTextViewCell"];
            [cell.textView setText:@""];
            cell.textView.placeholder = _placeholders[indexPath.row];
            if (self.userInteractionEnabled){
                cell.textView.text = self.address;
            }
            [cell bindSignal:self.addressSignal];
            cell.userInteractionEnabled = _userInteractionEnabled;
            return cell;
            break;
        }
        case 4:{
            identityCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identityCardCell"];
            cell.text = @"";
            cell.placeholder = _placeholders[indexPath.row];
            if (self.userInteractionEnabled){
                cell.text = self.IDCard;
            }
            [cell setKeyBoardType:UIKeyboardTypeDefault];
            [cell bindSignal:self.IDCardSignal];
            cell.userInteractionEnabled = _userInteractionEnabled;
            return cell;
            break;
        }
        default:
            return nil;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        return 95;
    }else if(indexPath.row == 4){
        return 100;
    }else{
        return 49;
    }
}

- (BOOL)validity{
    
    if ([self.name isEqualToString:@""] || self.name.length<2) {
        if ([self.name isEqualToString:@""]) {
            [[[LGAlertView alloc] initWithTitle:@"提示"
                                        message:@"姓名不能为空"
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
        }else{
            [[[LGAlertView alloc] initWithTitle:@"提示"
                                        message:@"请填写正确的姓名"
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
        return NO;
    }else if ([self.phone isEqualToString:@""] || ([self.phone length]<11 || ![self.phone hasPrefix:@"1"])){
        if ([self.phone isEqualToString:@""]) {
            [[[LGAlertView alloc] initWithTitle:@"提示"
                                        message:@"手机号不能为空"
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
        }else{
            [[[LGAlertView alloc] initWithTitle:@"提示"
                                        message:@"手机号格式错误"
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
        return NO;
    }else if(!self.school){
        [[[LGAlertView alloc] initWithTitle:@"提示"
                                    message:@"请选择学校"
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
        return NO;
    }else if (!self.address.isNotEmpty){
        [[[LGAlertView alloc] initWithTitle:@"提示"
                                    message:@"地址不能为空"
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
        return NO;
    }else if (self.IDCard == nil || self.IDCard.length ==0){
        
        [[[LGAlertView alloc] initWithTitle:@"提示"
                                    message:@"请填写学号信息"
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
        return NO;
        
    }else if(YES){
        
        return YES;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        if (keyboardIsVisible) {
            [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        }
        [[GDRouter sharedInstance] open:@"GD://school"];
        [GDRouter sharedInstance].receiveCallBack = ^(School * model){
            self.school = model;
            NSIndexPath * path = [NSIndexPath indexPathForRow:2 inSection:0];
            [self.tableView reloadRowAtIndexPath:path withRowAnimation:UITableViewRowAnimationFade];
        };
    }
}


#pragma mark - getter


@end
