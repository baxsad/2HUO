//
//  EHPostDetailScene.m
//  2HUO
//
//  Created by iURCoder on 5/10/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHPostDetailScene.h"
#import "EHPostDetailCell.h"
#import "EHPostDetailIamgeCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "Post.h"
#import "Comments.h"
#import "EHCommentCell.h"
#import "EHInputAccessoryView.h"
#import "LGAlertView.h"

@interface EHPostDetailScene ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITableView    * tableView;
@property (nonatomic, weak) IBOutlet UIView         * toolBar;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint         * toolBarHeight;
@property (nonatomic, strong) EHInputAccessoryView  * inputAccessoryView;
@property (nonatomic, strong) UITextView  * textView;

@property (nonatomic, strong) GDReq              * addCommentsRequest;
@property (nonatomic, strong) GDReq              * getCommentsRequest;
@property (nonatomic, strong) GDReq              * checkIsOnSaleRequest;

@property (nonatomic, strong) Comments           * commentsData;
@property (nonatomic, strong) NSMutableArray<Comment>     * commentsDataArray;

@property (nonatomic, weak) IBOutlet UIButton * chujiaButton;
@property (nonatomic, weak) IBOutlet UIButton * xiangyaoButton;

@property (nonatomic, copy) NSString * c_comment;
@property (nonatomic, copy) NSString * c_biddingPrice;
@property (nonatomic, copy) NSString * c_atUserId;

@end

@implementation EHPostDetailScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorHex(0xf2f2f2);
    self.title = @"详情";
    self.textView = [[UITextView alloc] init];
    self.textView.inputAccessoryView = self.inputAccessoryView;
    [self.view addSubview:self.textView];
    
    _commentsDataArray = @[].mutableCopy;
    
    @weakify(self);
    [self.chujiaButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        @strongify(self);
        if (!ISLOGIN) {
            [self showSignScene];
        }
        else
        {
            [self.textView becomeFirstResponder];
            [self.inputAccessoryView.contentTextView becomeFirstResponder];
        }
    }];
    [self.xiangyaoButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        @strongify(self);
        if (!ISLOGIN) {
            [self showSignScene];
        }
        else
        {
            [GDHUD showUIBlockingIndicator];
            [self.checkIsOnSaleRequest.params setValue:USER.uid forKey:@"uid"];
            self.checkIsOnSaleRequest.requestNeedActive = YES;
        }
    }];
    
    self.toolBar.clipsToBounds = YES;
    if (ISLOGIN) {
        if ([self.post.user.uid isEqualToString:USER.uid]) {
            self.toolBarHeight.constant = 0;
        }else{
            self.toolBarHeight.constant = 45;
        }
    }else{
        self.toolBarHeight.constant = 0;
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EHPostDetailCell class]) bundle:nil] forCellReuseIdentifier:@"EHPostDetailCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EHPostDetailIamgeCell class]) bundle:nil] forCellReuseIdentifier:@"EHPostDetailIamgeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EHCommentCell class]) bundle:nil] forCellReuseIdentifier:@"EHCommentCell"];
    
    self.getCommentsRequest = [GDRequest getCommentsRequest];
    [self.getCommentsRequest.params setValue:@(self.post.pid) forKey:@"pid"];
    self.getCommentsRequest.requestNeedActive = YES;
    [self.getCommentsRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            self.commentsData = [[Comments alloc] initWithDictionary:req.output error:nil];
            [_commentsDataArray removeAllObjects];
            [_commentsDataArray addObjectsFromArray:self.commentsData.data];
            self.commentsData.data = _commentsDataArray;
            [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationFade];
        }
        if (req.failed) {
            
        }
    }];
    
    self.addCommentsRequest = [GDRequest addCommentsRequest];
    [self.addCommentsRequest.params setValue:USER.uid forKey:@"uid"];
    [self.addCommentsRequest.params setValue:@(self.post.pid) forKey:@"pid"];
    [self.addCommentsRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
    
            @strongify(self);
            Comment * comment = [[Comment alloc] init];
            comment.pid = self.post.pid;
            comment.content = _c_comment;
            comment.atUserId = [_c_atUserId integerValue];
            comment.user = USER;
            comment.biddingPrice = [_c_biddingPrice floatValue];
            comment.createdTime = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
            [_commentsDataArray insertObject:comment atIndex:0];
            self.commentsData.data = _commentsDataArray;
            [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationFade];
            [self.textView resignFirstResponder];
            [self.inputAccessoryView.contentTextView resignFirstResponder];
            [self.inputAccessoryView.biddingTextView resignFirstResponder];
            
        }
        if (req.failed) {
            NSLog(@"%@",req.output);
        }
    }];
    
    
    self.checkIsOnSaleRequest = [GDRequest checkIsOnSaleRequest];
    [self.checkIsOnSaleRequest.params setValue:@(self.post.pid) forKey:@"pid"];
    [self.checkIsOnSaleRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            // 可以购买
            [GDHUD hideUIBlockingIndicator];
            [[GDRouter sharedInstance] open:[NSString stringWithFormat:@"GD://confirmOrder/?oid=%@",req.output[@"orderId"][@"oid"]]];
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
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.textView resignFirstResponder];
    [self.inputAccessoryView.contentTextView resignFirstResponder];
    [self.inputAccessoryView.biddingTextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1 + self.post.images.count;
    }else{
        return self.commentsData.data.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            EHPostDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EHPostDetailCell"];
            [cell configModel:self.post];
            return cell;
        }else{
            EHPostDetailIamgeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EHPostDetailIamgeCell"];
            [cell configModel:self.post.images[indexPath.row-1]];
            return cell;
        }
    }else
    {
        EHCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EHCommentCell"];
        [cell configModel:self.commentsData.data[indexPath.row]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return [tableView fd_heightForCellWithIdentifier:@"EHPostDetailCell" cacheByIndexPath:indexPath configuration:^(id cell) {
                [cell configModel:self.post];
            }];
        }else{
            return [tableView fd_heightForCellWithIdentifier:@"EHPostDetailIamgeCell" cacheByIndexPath:indexPath configuration:^(id cell) {
                
                [cell configModel:self.post.images[indexPath.row-1]];
            }];
        }
    }
    else
    {
        return [tableView fd_heightForCellWithIdentifier:@"EHCommentCell" cacheByIndexPath:indexPath configuration:^(id cell) {
            [cell configModel:self.commentsData.data[indexPath.row]];
        }];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == 0)
    {
        UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 15)];
        footer.backgroundColor = UIColorHex(0xf2f2f2);
        return footer;
    }
    else
    {
        UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 15)];
        footer.backgroundColor = [UIColor clearColor];
        return footer;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 15;
    }
    else
    {
        return 15;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        Comment *model = self.commentsData.data[indexPath.row];
        _c_atUserId = model.user.uid;
        [self.addCommentsRequest.params setObject:model.user.uid forKey:@"atUserId"];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.inputAccessoryView.contentTextView]) {
        
        NSString * content = self.inputAccessoryView.contentTextView.text;
        NSString * biddingPrice = self.inputAccessoryView.biddingTextView.text;
        if (!content.isNotEmpty) {
            
            return NO;
        }
        if (!biddingPrice.isNotEmpty) {
            
            return NO;
        }
        _c_comment = content;
        _c_biddingPrice = biddingPrice;
        _c_atUserId = nil;
        [self.addCommentsRequest.params removeObjectForKey:@"atUserId"];
        [self.addCommentsRequest.params setValue:content forKey:@"content"];
        [self.addCommentsRequest.params setValue:biddingPrice forKey:@"biddingPrice"];
        self.addCommentsRequest.requestNeedActive = YES;
        
    }
    return YES;
}

-(EHInputAccessoryView *)inputAccessoryView
{
    if (!_inputAccessoryView) {
        _inputAccessoryView = [EHInputAccessoryView viewFromNib];
        _inputAccessoryView.contentTextView.delegate = self;
        _inputAccessoryView.biddingTextView.delegate = self;
        _inputAccessoryView.contentTextView.returnKeyType = UIReturnKeySend;
    }
    return _inputAccessoryView;
}

@end
