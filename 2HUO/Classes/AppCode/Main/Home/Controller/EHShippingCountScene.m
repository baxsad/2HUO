//
//  EHShippingCountScene.m
//  2HUO
//
//  Created by iURCoder on 5/17/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHShippingCountScene.h"
#import "EHTextFieldCell.h"
#import "LGAlertView.h"

@interface EHShippingCountScene ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL keyboardIsVisible; //键盘是否弹出
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *footerView;
@property (nonatomic, weak) IBOutlet UIButton *saveButton;

@property (strong, nonatomic) NSArray  *placeholders;

@property (strong, nonatomic) RACSubject *shippingSignal;

@property (nonatomic, copy) NSString *shippingCount;

@end

@implementation EHShippingCountScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.title = @"价格";
    
    self.saveButton.layer.cornerRadius = 3.0;
    self.saveButton.layer.masksToBounds = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName: NSStringFromClass([EHTextFieldCell class]) bundle:nil] forCellReuseIdentifier:@"EHTextFieldCell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _placeholders = @[@"运费 ¥"];
    _shippingSignal = [RACSubject subject];
    
    RAC(self,shippingCount) = [self.shippingSignal startWith:@""];
    
    /** 监听键盘是否弹出 */
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil] subscribeNext:^(id x) {
        keyboardIsVisible = YES;
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(id x) {
        keyboardIsVisible = NO;
    }];
    
    self.saveButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input){
        if (keyboardIsVisible) {
            [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        }
        [self submitAction];
        return [RACSignal empty];
    }];
}

- (void)submitAction
{
    NSString * shippingCount = self.shippingCount;
    if (!shippingCount.isNotEmpty || !shippingCount.isNotEmpty) {
        [[[LGAlertView alloc] initWithTitle:@"提示"
                                    message:@"请填写运费"
                                      style:LGAlertViewStyleAlert
                               buttonTitles:nil
                          cancelButtonTitle:@"确定"
                     destructiveButtonTitle:nil
                              actionHandler:nil
                              cancelHandler:nil
                         destructiveHandler:nil] showAnimated:YES completionHandler:nil];
    }else{
        
        if (!shippingCount.isNumber) {
            [[[LGAlertView alloc] initWithTitle:@"提示"
                                        message:@"非法输入"
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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShippingCountSelect" object:shippingCount];
            [[GDRouter sharedInstance] pop];
        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 90.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.footerView;
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EHTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EHTextFieldCell"];
    cell.placeholder = _placeholders[indexPath.row];
    [cell bindSignal:self.shippingSignal];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49;
}


@end
