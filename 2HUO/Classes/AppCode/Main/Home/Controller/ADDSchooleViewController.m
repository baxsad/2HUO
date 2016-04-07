//
//  ADDSchooleViewController.m
//  2HUO
//
//  Created by iURCoder on 4/6/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "ADDSchooleViewController.h"
#import "YDog.h"

@interface ADDSchooleViewController ()

@property (nonatomic, weak) IBOutlet UITextField * nameText;
@property (nonatomic, weak) IBOutlet UITextField * dizhiText;
@property (nonatomic, weak) IBOutlet UITextField * xiaoquText;
@property (nonatomic, weak) IBOutlet UITextField * kebieText;
@property (nonatomic, weak) IBOutlet UITextField * leixingText;
@property (nonatomic, weak) IBOutlet UITextField * bianhaoText;

@property (nonatomic, weak) IBOutlet UIButton * saveButton;

@end

@implementation ADDSchooleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self.saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer * ge = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    ge.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:ge];
}

- (void)close
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)save
{
    NSString * name = self.nameText.text;
    NSString * province = @"河南省";
    NSString * xiaoqu = self.xiaoquText.text;
    NSString * dizhi = self.dizhiText.text;
    NSString * kebie = self.kebieText.text;
    NSString * leixing = self.leixingText.text;
    NSString * bianhao = self.bianhaoText.text;
    
    if (xiaoqu == nil) {
        xiaoqu = @"";
    }
    
    [[YDog shareInstance] insertInto:@"School" values:@{@"province":province,@"name":name,@"campus":xiaoqu ,@"location":dizhi,@"nature":kebie,@"type":leixing,@"sid":[bianhao numberValue]} complete:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"ok");
        }
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
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
