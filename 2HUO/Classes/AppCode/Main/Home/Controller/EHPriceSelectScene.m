//
//  EHPriceSelectScene.m
//  2HUO
//
//  Created by iURCoder on 5/4/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHPriceSelectScene.h"

@interface EHPriceSelectScene ()

@property (nonatomic, weak) IBOutlet UITextField * price;
@property (nonatomic, weak) IBOutlet UITextField * orzPrice;
@property (nonatomic, weak) IBOutlet UIButton * submitButton;

@end

@implementation EHPriceSelectScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self.submitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    self.title = @"价格";
}

- (void)submitAction
{
    NSString * priceString = self.price.text;
    NSString * orzPriceString = self.orzPrice.text;
    if (!priceString.isNotEmpty || !orzPriceString.isNotEmpty) {
        [GDHUD showMessage:@"请输入价格" timeout:1];
    }else{
        if (!priceString.isNumber || !orzPriceString.isNumber) {
            [GDHUD showMessage:@"非法输入" timeout:1];
        }else{
            NSDictionary * dic = @{@"price":priceString,
                                   @"orzPrice":orzPriceString};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PriceSelect" object:dic];
            [[GDRouter sharedInstance] pop];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
