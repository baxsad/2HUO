//
//  MFUReleaseProductViewController.m
//  2HUO
//
//  Created by iURCoder on 4/7/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFUReleaseProductScene.h"
#import "MFJTextView.h"
#import "MFJDragCellCollectionView.h"
#import "MFUSelectIamgeCollectionCell.h"

#define IMAGE_WIDTH (Screen_Width - 50)*(1.0/3.0)

@interface MFUReleaseProductScene ()<UITextViewDelegate,MFJDragCellCollectionViewDataSource, MFJDragCellCollectionViewDelegate>

@property (nonatomic, strong) UIScrollView * contentScrollView;
@property (nonatomic, strong) UITextField  * titleTextField;
@property (nonatomic, strong) UIView       * titleTextFieldBottomLine;
@property (nonatomic, strong) MFJTextView  * contentView;
@property (nonatomic, strong) MFJDragCellCollectionView * imageCollection;
@property (nonatomic, strong) NSMutableArray            * imageData;

@end

@implementation MFUReleaseProductScene

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [_titleTextField becomeFirstResponder];
    
}

-(void)viewDidLayoutSubviews
{
    
    if (self.imageCollection.bottom > self.contentScrollView.height) {
        self.contentScrollView.contentSize = CGSizeMake(Screen_Width, self.imageCollection.bottom);
    }else{
        self.contentScrollView.contentSize = CGSizeMake(Screen_Width, self.contentScrollView.height);
    }
    
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
    
    _contentScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_contentScrollView];
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _contentScrollView.backgroundColor = UIColorHex(0xffffff);
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.contentSize = CGSizeMake(Screen_Width, 2.0*Screen_Height);
    _contentScrollView.bounces = NO;
    _contentScrollView.scrollEnabled = YES;
    
    _titleTextField = [[UITextField alloc] init];
    _titleTextField.font = [UIFont systemFontOfSize:14];
    [_contentScrollView addSubview:_titleTextField];
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.contentScrollView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScrollView.mas_left).offset(15);
        make.right.equalTo(self.contentScrollView.mas_right).offset(15);
        make.height.mas_equalTo(@45);
    }];
    _titleTextField.placeholder = @"标题(小赚一笔)";
    [_titleTextField setValue:UIColorHex(0xCECED1) forKeyPath:@"_placeholderLabel.textColor"];
    
    _titleTextFieldBottomLine = [UIView new];
    _titleTextFieldBottomLine.backgroundColor = UIColorHex(0xebebeb);
    [_contentScrollView addSubview:_titleTextFieldBottomLine];
    [self.titleTextFieldBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.titleTextField.mas_bottom).offset(0);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(0);
        make.size.mas_equalTo(CGSizeMake(Screen_Width - 15, 1.0/ScreenScale));
    }];
    
    _contentView = [[MFJTextView alloc] init];
    [_contentScrollView addSubview:_contentView];
    _contentView.delegate = self;
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.font = [UIFont systemFontOfSize:14];
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    _contentView.scrollEnabled = NO;
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.titleTextFieldBottomLine.mas_bottom).offset(8);
        make.left.equalTo(self.contentScrollView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(Screen_Width - 20, 100));
    }];
    _contentView.placeholder = @"描述一下你的宝贝";
    [_contentView setPlaceholderFont:[UIFont systemFontOfSize:14]];
    [_contentView setPlaceholderColor:UIColorHex(0xCECED1)];
    [_contentView addTextViewDidChangeEvent:^(MFJTextView *text) {
        
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
            
            make.top.equalTo(self.titleTextFieldBottomLine.mas_bottom).offset(8);
            make.left.equalTo(self.contentScrollView.mas_left).offset(10);
            make.size.mas_equalTo(CGSizeMake(Screen_Width - 20, size.height));
            
        }];
    }];
    
    self.imageData = [NSMutableArray array];
    
    UIImage * image = [UIImage imageNamed:@"addvote"];
    NSData * imageData = UIImagePNGRepresentation(image);
    [self.imageData addObject:imageData];
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(IMAGE_WIDTH, IMAGE_WIDTH);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    _imageCollection = [[MFJDragCellCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _imageCollection.backgroundColor = [UIColor clearColor];
    _imageCollection.delegate = self;
    _imageCollection.dataSource = self;
    _imageCollection.shakeLevel = 2.0f;
    [self.contentScrollView addSubview:_imageCollection];
    [_imageCollection registerNib:[UINib nibWithNibName:@"MFUSelectIamgeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"MFUSelectIamgeCollectionCell"];
    [_imageCollection mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.contentView.mas_bottom).offset(15);
        make.left.equalTo(self.contentScrollView.mas_left).offset(15);
        make.right.equalTo(self.contentScrollView.mas_right).offset(15);
        make.size.mas_equalTo(CGSizeMake(Screen_Width - 30, IMAGE_WIDTH));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)postAction
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)leftButtonTouch
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [[MFJRouter sharedInstance] pop];
}

#pragma mark - <CollectionViewDelegate>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _imageData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MFUSelectIamgeCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MFUSelectIamgeCollectionCell" forIndexPath:indexPath];
    cell.data = _imageData[indexPath.row];
    return cell;
}

- (NSArray *)dataSourceArrayOfCollectionView:(MFJDragCellCollectionView *)collectionView{
    return _imageData;
}

#pragma mark - <MFJDragCellCollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)dragCellCollectionView:(MFJDragCellCollectionView *)collectionView newDataArrayAfterMove:(NSArray *)newDataArray{
    _imageData = [NSMutableArray arrayWithArray:newDataArray];
}

- (void)dragCellCollectionView:(MFJDragCellCollectionView *)collectionView cellWillBeginMoveAtIndexPath:(NSIndexPath *)indexPath{
    //拖动时候最后禁用掉编辑按钮的点击
    
}

- (void)dragCellCollectionViewCellEndMoving:(MFJDragCellCollectionView *)collectionView{
    
}




#pragma mark --getter



@end
