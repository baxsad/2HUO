//
//  MFUReleaseProductViewController.m
//  2HUO
//
//  Created by iURCoder on 4/7/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHReleaseScene.h"
#import "MFJTextView.h"
#import "MFJDragCellCollectionView.h"
#import "MFUSelectIamgeCollectionCell.h"
#import "EHSelectMenuView.h"
#import "GDImagePickerController.h"
#import "Communitys.h"
#import "LGAlertView.h"
#import "SellerModel.h"
#import "School.h"

typedef void(^Next)();
typedef void(^Upload)();

#define IMAGE_WIDTH (Screen_Width - 50)*(1.0/3.0)

@interface EHReleaseScene ()<UITextViewDelegate,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIScrollView * contentScrollView;
@property (nonatomic, strong) UITextField  * titleTextField;
@property (nonatomic, strong) UIView       * titleTextFieldBottomLine;
@property (nonatomic, strong) MFJTextView  * contentView;
@property (nonatomic, strong) UICollectionView          * imageCollection;
@property (nonatomic, strong) NSMutableArray            * selectImageData;
@property (nonatomic, strong) GDImagePickerController   * imagePicker;
@property (nonatomic, strong) EHSelectMenuView          * typeView;
@property (nonatomic, strong) EHSelectMenuView          * priceView;
@property (nonatomic, strong) EHSelectMenuView          * transactionModeView;
@property (nonatomic, strong) EHSelectMenuView          * locationView;
@property (nonatomic, strong) NSMutableArray            * imageUrls;
@property (nonatomic, copy  ) Next                        Next;
@property (nonatomic, copy  ) Upload                      Upload;
@property (nonatomic, strong) GDReq                     * addPostRequest;
@property (nonatomic, strong) GDReq                     * getDefAddressRequest;

#pragma mark - params

@property (nonatomic, copy) NSString * p_title;
@property (nonatomic, copy) NSString * p_content;
@property (nonatomic, copy) NSString * p_price;
@property (nonatomic, copy) NSString * p_orzPrice;
@property (nonatomic, copy) NSString * p_transModel;
@property (nonatomic, strong) SellerModel * address;

@end

@implementation EHReleaseScene

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.contentScrollView.contentSize = CGSizeMake(Screen_Width, self.locationView.bottom+50);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view layoutIfNeeded];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self showBarButton:NAV_LEFT title:@"Cancle" fontColor:UIColorHex(0x5F5F5F)];
    UIButton * sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(0, 0, 45, 25);
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [sendButton setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
    [sendButton setBackgroundColor:UIColorHex(0xD2B203)];
    [sendButton addTarget:self action:@selector(postAction) forControlEvents:UIControlEventTouchUpInside];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:13];
    sendButton.layer.cornerRadius = 5;
    sendButton.layer.masksToBounds = YES;
    [self showBarButton:NAV_RIGHT button:sendButton];
    
    @weakify(self);
    
    [self.view addSubview:self.contentScrollView];
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.contentScrollView addSubview:self.titleTextField];
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.contentScrollView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScrollView.mas_left).offset(15);
        make.right.equalTo(self.contentScrollView.mas_right).offset(15);
        make.height.mas_equalTo(@45);
    }];
    
    [self.contentScrollView addSubview:self.titleTextFieldBottomLine];
    [self.titleTextFieldBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.titleTextField.mas_bottom).offset(0);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(0);
        make.size.mas_equalTo(CGSizeMake(Screen_Width - 15, 1.0/ScreenScale));
    }];
    
    [self.contentScrollView addSubview:self.contentView];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.titleTextFieldBottomLine.mas_bottom).offset(8);
        make.left.equalTo(self.contentScrollView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(Screen_Width - 20, 100));
    }];
    [self.contentView addTextViewDidChangeEvent:^(MFJTextView *text) {
        
        @strongify(self);
        static CGFloat normalHeight = 100.0;
        CGRect frame = text.frame;
        CGSize maxSize = CGSizeMake(frame.size.width, HUGE);
        CGSize size = [text sizeThatFits:maxSize];
        if (size.height <= normalHeight)
        {
            size.height = normalHeight;
        }
        
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(Screen_Width - 20, size.height));
            
        }];
    }];
    
    self.imageUrls = [NSMutableArray array];
    self.selectImageData = [NSMutableArray array];
    UIImage * image = [UIImage imageNamed:@"addvote"];
    NSData * selectImageData = UIImagePNGRepresentation(image);
    DataModel * model = [[DataModel alloc] init];
    model.isUpload = YES;
    model.data = selectImageData;
    [self.selectImageData addObject:model];
    
    [self.contentScrollView addSubview:self.imageCollection];
    [self.imageCollection mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.contentView.mas_bottom).offset(15);
        make.left.equalTo(self.contentScrollView.mas_left).offset(15);
        make.right.equalTo(self.contentScrollView.mas_right).offset(15);
        make.size.mas_equalTo(CGSizeMake(Screen_Width - 30, IMAGE_WIDTH));
    }];
    
    [RACObserve(self,selectImageData) subscribeNext:^(id x) {
        @strongify(self);
        
        if (self.selectImageData.count<=9) {
            [self.imageCollection mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(Screen_Width - 30, 3*IMAGE_WIDTH + 20));
            }];
        }
        if (self.selectImageData.count<=6) {
            [self.imageCollection mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(Screen_Width - 30, 2*IMAGE_WIDTH + 10));
            }];
        }
        if (self.selectImageData.count<=3) {
            [self.imageCollection mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(Screen_Width - 30, IMAGE_WIDTH));
            }];
        }
        
    }];
    
    
    if (self.needSelectType) {
        [self.contentScrollView addSubview:self.typeView];
        [_typeView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            @strongify(self);
            make.top.equalTo(self.imageCollection.mas_bottom).offset(15);
            make.left.equalTo(self.imageCollection).offset(0);
            make.right.equalTo(self.imageCollection).offset(0);
            make.height.mas_equalTo(@45);
            
        }];
        
        
        [self.contentScrollView addSubview:self.priceView];
        [_priceView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            @strongify(self);
            make.top.equalTo(self.typeView.mas_bottom).offset(0);
            make.left.equalTo(self.imageCollection).offset(0);
            make.right.equalTo(self.imageCollection).offset(0);
            make.height.mas_equalTo(@45);
            
        }];
    }else{
        [self.contentScrollView addSubview:self.priceView];
        [_priceView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            @strongify(self);
            make.top.equalTo(self.imageCollection.mas_bottom).offset(15);
            make.left.equalTo(self.imageCollection).offset(0);
            make.right.equalTo(self.imageCollection).offset(0);
            make.height.mas_equalTo(@45);
            
        }];
    }
    
    [self.contentScrollView addSubview:self.transactionModeView];
    [self.transactionModeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self);
        make.top.equalTo(self.priceView.mas_bottom).offset(0);
        make.left.equalTo(self.imageCollection).offset(0);
        make.right.equalTo(self.imageCollection).offset(0);
        make.height.mas_equalTo(@45);
        
    }];
    
    [self.contentScrollView addSubview:self.locationView];
    [self.locationView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self);
        make.top.equalTo(self.transactionModeView.mas_bottom).offset(0);
        make.left.equalTo(self.imageCollection).offset(0);
        make.right.equalTo(self.imageCollection).offset(0);
        make.height.mas_equalTo(@45);
        
    }];
    
    _typeView.block = ^{
        [[GDRouter sharedInstance] open:@"GD://selectType"];
    };
    
    _priceView.block = ^{
        [[GDRouter sharedInstance] open:@"GD://selectPrice"];
    };
    
    _transactionModeView.block = ^{
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"Model"
                                                            message:@"TransactionMode Style!"
                                                              style:LGAlertViewStyleAlert
                                                       buttonTitles:@[@"On Line",@"Out Line"]
                                                  cancelButtonTitle:nil
                                             destructiveButtonTitle:@"Destructive"
                                                      actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index)
                                  {
                                      @strongify(self);
                                      self.p_transModel = index ? @"outline" : @"online";
                                  }
                                                      cancelHandler:nil
                                                 destructiveHandler:nil];
        
        [alertView showAnimated:YES completionHandler:nil];
    };
    
    _locationView.block = ^{
        [[GDRouter sharedInstance] open:@"GD://addressList"];
    };
    
    [_titleTextField becomeFirstResponder];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"SelectComunity" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        NSNotification * noti = x;
        Community * model = noti.object;
        if (model) {
            self.typeView.content = model.c_name;
            self.cid = [NSString stringWithFormat:@"%li",model.cid];
        }
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"PriceSelect" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        NSNotification * noti = x;
        NSDictionary * dic = noti.object;
        if (dic && dic.count == 2) {
            _p_price = [NSString stringWithFormat:@"%.2f",[dic[@"price"] floatValue]];
            _p_orzPrice = [NSString stringWithFormat:@"%.2f",[dic[@"orzPrice"] floatValue]];
            self.priceView.content = [NSString stringWithFormat:@"¥%@ ¥%@",_p_price,_p_orzPrice];
            [self.addPostRequest.params setValue:_p_price forKey:@"presentPrice"];
            [self.addPostRequest.params setValue:_p_orzPrice forKey:@"originalPrice"];
        }
    }];
    
    self.addPostRequest = [GDRequest addPostListRequest];
    [self.addPostRequest.params setValue:USER.uid forKey:@"uid"];
    [self.addPostRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            NSLog(@"发布成功！");
            [GDHUD hideUIBlockingIndicator];
            [self leftButtonTouch];
        }
        if (req.failed) {
            NSLog(@"发布失败！");
            [GDHUD hideUIBlockingIndicator];
            [GDHUD showMessage:@"上传失败" timeout:1];
        }
    }];
    
    
    /* 获取默认地址 */
    self.getDefAddressRequest = [GDRequest getDefAddressRequest];
    [self.getDefAddressRequest.params setObject:USER.uid forKey:@"uid"];
    [self.getDefAddressRequest.params setObject:@"1" forKey:@"def"];
    self.getDefAddressRequest.requestNeedActive = YES;
    [self.getDefAddressRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            SellerModels * model = [[SellerModels alloc] initWithDictionary:req.output error:nil];
            if (model.data.count>0) {
                self.address = model.data[0];
            }
        }
        if (req.failed) {
            self.address = nil;
        }
    }];
    
    [RACObserve(self, address) subscribeNext:^(id x) {
        if (self.address) {
            self.locationView.content = [NSString stringWithFormat:@"%@ %@",self.address.userName,self.address.school.name];
        }else{
            self.locationView.content = @"详细信息";
        }
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (BOOL)verificationParams
{
    if (!self.p_title.isNotEmpty) {
        [[[LGAlertView alloc] initWithTitle:@"提示"
                                    message:@"标题不能为空"
                                      style:LGAlertViewStyleAlert
                               buttonTitles:nil
                          cancelButtonTitle:@"确定"
                     destructiveButtonTitle:nil
                              actionHandler:nil
                              cancelHandler:nil
                         destructiveHandler:nil]
         showAnimated:YES completionHandler:nil];
        return NO;
    }
    if (!self.p_content.isNotEmpty) {
        [[[LGAlertView alloc] initWithTitle:@"提示"
                                    message:@"内容不能为空"
                                      style:LGAlertViewStyleAlert
                               buttonTitles:nil
                          cancelButtonTitle:@"确定"
                     destructiveButtonTitle:nil
                              actionHandler:nil
                              cancelHandler:nil
                         destructiveHandler:nil]
         showAnimated:YES completionHandler:nil];
        return NO;
    }
    if (!self.cid.isNotEmpty) {
        [[[LGAlertView alloc] initWithTitle:@"提示"
                                    message:@"分类不能为空"
                                      style:LGAlertViewStyleAlert
                               buttonTitles:nil
                          cancelButtonTitle:@"确定"
                     destructiveButtonTitle:nil
                              actionHandler:nil
                              cancelHandler:nil
                         destructiveHandler:nil]
         showAnimated:YES completionHandler:nil];
        return NO;
    }
    if (!self.p_price.isNotEmpty || !self.p_orzPrice.isNotEmpty) {
        [[[LGAlertView alloc] initWithTitle:@"提示"
                                    message:@"价格不能为空"
                                      style:LGAlertViewStyleAlert
                               buttonTitles:nil
                          cancelButtonTitle:@"确定"
                     destructiveButtonTitle:nil
                              actionHandler:nil
                              cancelHandler:nil
                         destructiveHandler:nil]
         showAnimated:YES completionHandler:nil];
        return NO;
    }
    if (!self.p_transModel.isNotEmpty) {
        [[[LGAlertView alloc] initWithTitle:@"提示"
                                    message:@"交易方式不能为空"
                                      style:LGAlertViewStyleAlert
                               buttonTitles:nil
                          cancelButtonTitle:@"确定"
                     destructiveButtonTitle:nil
                              actionHandler:nil
                              cancelHandler:nil
                         destructiveHandler:nil]
         showAnimated:YES completionHandler:nil];
        return NO;
    }
    if (!self.address.isNotEmpty) {
        [[[LGAlertView alloc] initWithTitle:@"提示"
                                    message:@"卖家信息不能为空"
                                      style:LGAlertViewStyleAlert
                               buttonTitles:nil
                          cancelButtonTitle:@"确定"
                     destructiveButtonTitle:nil
                              actionHandler:nil
                              cancelHandler:nil
                         destructiveHandler:nil]
         showAnimated:YES completionHandler:nil];
        return NO;
    }
    
    
    [self.addPostRequest.params setValue:self.cid forKey:@"cid"];
    [self.addPostRequest.params setValue:@(self.address.school.id) forKey:@"sid"];
    [self.addPostRequest.params setValue:@(self.address.aid) forKey:@"aid"];
    return YES;
}

- (void)postAction
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    self.p_title = self.titleTextField.text;
    self.p_content = self.contentView.text;
    [self.addPostRequest.params setValue:self.p_title forKey:@"title"];
    [self.addPostRequest.params setValue:self.p_content forKey:@"content"];
    
    [self verificationParams];
    
    [GDHUD showUIBlockingIndicator];
    
    [self uploadIamges:^(BOOL over,int index){
        if (over) {
            NSString * images = @"";
            if (self.imageUrls.isNotEmpty) {
                images = [self.imageUrls componentsJoinedByString:@","];
            }
            [self.addPostRequest.params setValue:images forKey:@"images"];
            self.addPostRequest.requestNeedActive = YES;
        }
    }];
}

- (void)leftButtonTouch
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [[GDRouter sharedInstance] pop];
}

- (void)uploadIamges:(void (^)(BOOL over,int index))complete
{
    __block int i = 0;
    
    __weak typeof(self) weakSelf = self;
    self.Next = ^(){
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.Upload();
    };
    
    self.Upload = ^(){
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf.selectImageData.count == 1) {
            complete(YES,0);
        }
        DataModel * model = [strongSelf.selectImageData objectAtIndex:i];
        [[DataCenter defaultCenter] uploadPicture:[UIImage imageWithData:model.data] progress:^(float progress) {
            
        } response:^(NSString *imageName) {
            // 上传图片获取到图片的链接
            __strong typeof(self) strongSelf = weakSelf;
            if (imageName != nil) {
                [strongSelf.imageUrls addObject:imageName];
            }else{
                NSLog(@"上传失败！");
            }
            if (complete) {
                if (i == _selectImageData.count - 2) {
                    complete(YES,i+1);
                }else{
                    complete(NO,i+1);
                }
            }
            if (i != _selectImageData.count - 2) {
                i ++;
                strongSelf.Next();
            }
        }];
        
    };

    self.Next();
}

#pragma mark - <CollectionViewDelegate>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _selectImageData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MFUSelectIamgeCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MFUSelectIamgeCollectionCell" forIndexPath:indexPath];
    cell.data = _selectImageData[indexPath.row];
    if (indexPath.row == _selectImageData.count - 1) {
        cell.isADD = YES;
    }
    return cell;
}



#pragma mark - <MFJDragCellCollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == _selectImageData.count-1) {

        [self presentViewController:self.imagePicker animated:YES completion:nil];
        
    }else{
        
        
        
    }
    
}


- (void)dealloc
{
    NSLog(@"dealloc");
}


#pragma mark --getter

- (GDImagePickerController *)imagePicker
{
    if (!_imagePicker) {
        _imagePicker = [[GDImagePickerController alloc] initWithMaxImagesCount:1];
        @weakify(self);
        _imagePicker.complete = ^(NSArray * imageArray){
            @strongify(self);
            for (NSData * selectImageData in imageArray) {
                @strongify(self);
                DataModel * model = [[DataModel alloc] init];
                model.isUpload = NO;
                model.data = selectImageData;
                [self.selectImageData insertObject:model atIndex:self.selectImageData.count-1];
                self.selectImageData = self.selectImageData;
                [self.imageCollection reloadData];
            }
            
            
        };
    }
    return _imagePicker;
}

- (UIScrollView *)contentScrollView
{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.backgroundColor = UIColorHex(0xffffff);
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.bounces = NO;
        _contentScrollView.delegate = self;
    }
    return _contentScrollView;
}

- (UITextField *)titleTextField
{
    if (!_titleTextField) {
        _titleTextField = [[UITextField alloc] init];
        _titleTextField.font = [UIFont systemFontOfSize:14];
        _titleTextField.placeholder = @"标题(小赚一笔)";
        [_titleTextField setValue:UIColorHex(0xCECED1) forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _titleTextField;
}

- (UIView *)titleTextFieldBottomLine
{
    if (!_titleTextFieldBottomLine) {
        _titleTextFieldBottomLine = [UIView new];
        _titleTextFieldBottomLine.backgroundColor = UIColorHex(0xebebeb);
    }
    return _titleTextFieldBottomLine;
}

- (MFJTextView *)contentView
{
    if (!_contentView) {
        _contentView = [[MFJTextView alloc] init];
        _contentView.delegate = self;
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.font = [UIFont systemFontOfSize:14];
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.scrollEnabled = NO;
        _contentView.placeholder = @"描述一下你的宝贝";
        [_contentView setPlaceholderFont:[UIFont systemFontOfSize:14]];
        [_contentView setPlaceholderColor:UIColorHex(0xCECED1)];
    }
    return _contentView;
}

- (UICollectionView *)imageCollection
{
    if (!_imageCollection) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(IMAGE_WIDTH, IMAGE_WIDTH);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        _imageCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _imageCollection.backgroundColor = [UIColor clearColor];
        _imageCollection.delegate = self;
        _imageCollection.dataSource = self;
        _imageCollection.clipsToBounds = NO;
        _imageCollection.scrollEnabled = NO;
        _imageCollection.showsVerticalScrollIndicator = NO;
        _imageCollection.showsHorizontalScrollIndicator = NO;
        [_imageCollection registerNib:[UINib nibWithNibName:@"MFUSelectIamgeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"MFUSelectIamgeCollectionCell"];
    }
    return _imageCollection;
}

- (EHSelectMenuView *)typeView
{
    if (!_typeView) {
        _typeView = [EHSelectMenuView viewFromNib];
        _typeView.title = @"分类";
        _typeView.content = @"选择分类";
        _typeView.backgroundColor = [UIColor whiteColor];
    }
    return _typeView;
}

- (EHSelectMenuView *)priceView
{
    if (!_priceView) {
        _priceView = [EHSelectMenuView viewFromNib];
        _priceView.title = @"价格";
        _priceView.content = @"输入价格";
        _priceView.backgroundColor = [UIColor whiteColor];
    }
    return _priceView;
}

- (EHSelectMenuView *)transactionModeView
{
    if (!_transactionModeView) {
        _transactionModeView = [EHSelectMenuView viewFromNib];
        _transactionModeView.title = @"方式";
        _transactionModeView.content = @"交易方式";
        _transactionModeView.backgroundColor = [UIColor whiteColor];
    }
    return _transactionModeView;
}

- (EHSelectMenuView *)locationView
{
    if (!_locationView) {
        _locationView = [EHSelectMenuView viewFromNib];
        _locationView.title = @"地址";
        _locationView.content = @"详细信息";
        _locationView.backgroundColor = [UIColor whiteColor];
    }
    return _locationView;
}

@end
