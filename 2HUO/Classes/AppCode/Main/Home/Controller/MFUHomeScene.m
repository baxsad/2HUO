//
//  MFUConfigScene.m
//  2HUO
//
//  Created by iURCoder on 3/23/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFUHomeScene.h"
#import "WFLoopShowView.h"
#import "MFUHomeTBCell.h"
#import "MFUHomeMenuCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MFJActionSheet.h"
#import "MFJPhotoGroupView.h"
#import "BannerModel.h"
#import "Product.h"


@interface MFUHomeScene ()<UITableViewDataSource,UITableViewDelegate,MFUCellDelegate>

@property (nonatomic, strong) UITableView          * tableView;
@property (nonatomic, strong) NSArray              * data;
@property (nonatomic, strong) WFLoopShowView       * bannerView;
@property (nonatomic, strong) MFJActionSheet       * sheet;
@property (nonatomic, strong) Product              * productModel;

@end

@implementation MFUHomeScene

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showBarButton:NAV_RIGHT title:@"Edit" fontColor:UIColorHex(0xD2B203)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MFUHomeTBCell class]) bundle:nil] forCellReuseIdentifier:@"MFUHomeTBCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MFUHomeMenuCell class]) bundle:nil] forCellReuseIdentifier:@"MFUHomeMenuCell"];
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
    
    
    [[YDog shareInstance] selectFrom:@"Banner" type:SearchTypeEqualTo where:@"name" is:@"_homeBanner" page:@"1" complete:^(NSArray *objects, NSError *error) {
        
        BannerModel * model = [[BannerModel alloc] initWithDictionary:@{@"list":objects} error:nil];
        [self.bannerView loadImagesWithModel:model];
        
    }];
    
//    NSDictionary * user = @{@"nick":@"王思聪",@"uid":@"10001",@"avatar":@"http://ww4.sinaimg.cn/large/a15b4afegw1f2nymm1a3yj20go0go3zc",@"school":@"伦敦大学",@"type":@1};
//    NSArray * images = @[@"http://ww2.sinaimg.cn/bmiddle/a15b4afegw1eueu5fdlzlj20xc0xcq83",
//                         @"http://ww2.sinaimg.cn/bmiddle/a15b4afegw1es9mk18gwxj20xc0xcqd7",
//                         @"http://ww2.sinaimg.cn/bmiddle/a15b4afegw1exewl2ixflj20xb0xcgsx",
//                         @"http://ww2.sinaimg.cn/bmiddle/a15b4afegw1ekmwr1mfy3j20xc0xc7iy",
//                         @"http://ww2.sinaimg.cn/bmiddle/a15b4afegw1ey0w3n9zv4j20xc0xctj5",
//                         @"http://ww2.sinaimg.cn/bmiddle/a15b4afegw1eknha9qvfaj20xc0p0473",
//                         @"http://ww2.sinaimg.cn/bmiddle/a15b4afegw1exewgr3su4j20xc0xcdn9",
//                         @"http://ww2.sinaimg.cn/bmiddle/a15b4afegw1enlbc2m25lj20p00xcdjb",
//                         @"http://ww2.sinaimg.cn/bmiddle/a15b4afegw1enoi58suy0j20m80xcq7k"];
//    NSArray * tags = @[@{@"tagName":@"硬件",@"tagId":@100001},@{@"tagName":@"硬件",@"tagId":@100002},@{@"tagName":@"智能设备",@"tagId":@100003},@{@"tagName":@"手机",@"tagId":@100004},@{@"tagName":@"iphone 6s",@"tagId":@100005}];
//    NSDictionary * data = @{@"pid":@24234,@"user":user,@"createTime":@1459998586,@"updateTime":@1459999586,@"images":images,@"title":@"我是标题我是标题我是标题我是标题我是标题",@"content":@"昨晚坐MU5160从北京飞往上海把卡包落在了飞机上（黑色卡包，里面有各大银行各式各样的黑卡），哪位好心人捡到了请联系我助理 15101143311 思聪必有重谢。😭😭😭",@"tags":tags,@"likeCount":@672,@"location":@"北京市",@"school":@"北京电影学院",@"presentPrice":@49900,@"originalPrice":@129000,@"transactionMode":@"online",@"type":@"sale"};
//    
//    [[[YDog alloc] init] insertInto:@"Products" values:data complete:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            NSLog(@"上传成功！！");
//        }
//    }];
    
    [[[YDog alloc] init] selectFrom:@"Products" type:SearchTypeNone where:@"likeCount" is:@100 page:nil complete:^(NSArray *objects, NSError *error) {
        NSDictionary * response = @{@"list":objects};
        
        self.productModel = [[Product alloc] initWithDictionary:response error:nil];
        
    }];
    
    [RACObserve(self, productModel) subscribeNext:^(id x) {
        [self.tableView reloadData];
    }];
    
}


-(void)rightButtonTouch{
    
    [[MFJRouter sharedInstance] show:@"mfj://addProduct" completion:nil];
    
}


#pragma mark - UITableViewDelegate and UITableViewDataScore

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section ? self.productModel.list.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section) {
        MFUHomeTBCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MFUHomeTBCell"];
        cell.delegate = self;
        [cell configModel:[self.productModel.list objectAtIndex:indexPath.row]];
        NSString * rowStr = [NSString stringWithFormat:@"%li%li",indexPath.section+1,indexPath.row];
        cell.row = [rowStr integerValue];
        return cell;
    }else{
        MFUHomeMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MFUHomeMenuCell"];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section ? [tableView fd_heightForCellWithIdentifier:@"MFUHomeTBCell" cacheByIndexPath:indexPath configuration:^(MFUHomeTBCell * cell) {
        [cell configModel:[self.productModel.list objectAtIndex:indexPath.row]];
    }] : Screen_Width*0.5;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? Screen_Width/15*6 : 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return section == 0 ? self.bannerView : [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 0.001)];
}

- (void)MFUHomeTBCell:(MFUHomeTBCell *)cell moreButtonDidSelect:(Product *)model
{
    
    [self.sheet showInView:[UIApplication sharedApplication].keyWindow animated:YES];
    
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (WFLoopShowView *)bannerView
{
    if (!_bannerView) {
        CGRect rect = CGRectMake(0, 0, Screen_Width, Screen_Width/15*6);
        _bannerView = [[WFLoopShowView alloc] initWithFrame:rect image:nil animationDuration:2.7];
        
    }
    return _bannerView;
}



- (MFJActionSheet *)sheet
{
    if (!_sheet) {
        
        MFJActionSheetSection * s1 = [MFJActionSheetSection sectionWithTitle:@"我是第一个分组！" message:@"button列表" buttonTitles:@[@"Report",@"Share to WeiBo",@"Copy Share Url",@"Turn On Post Notifications"] buttonStyle:MFJActionSheetButtonStyleInstagram];
        
        MFJActionSheetSection * s2 = [MFJActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Cancle"] buttonStyle:MFJActionSheetButtonStyleYellow];
        
        
        
        
        [s1 setButtonStyle:MFJActionSheetButtonStyleInstagramRed forButtonAtIndex:0];
        
        
        _sheet = [[MFJActionSheet alloc] initWithSections:@[s1,s2]];
        
        _sheet.buttonClickBlock = ^(MFJActionSheet * sheet , NSIndexPath * indexPath){
            NSLog(@"click:%li,%li",indexPath.section,indexPath.row);
        };
        
    }
    return _sheet;
}



@end
