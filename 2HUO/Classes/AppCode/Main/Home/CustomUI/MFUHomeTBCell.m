//
//  MFUHomeTBListCell.m
//  2HUO
//
//  Created by iURCoder on 3/24/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFUHomeTBCell.h"
#import "MFUHomeImageCollectionCell.h"
#import "Product.h"
#import "MFJStatusButton.h"

#import "MFJPhotoGroupView.h"
#import "MFJImageView.h"

#import <YYWebImage/YYWebImage.h>
#import "YDog.h"

#define kPadding 2
#define kMaxRow 9

@interface MFUHomeTBCell()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UIImageView      * userIcon;
@property (nonatomic, weak) IBOutlet UILabel          * nick;
@property (nonatomic, weak) IBOutlet UILabel          * date;
@property (nonatomic, weak) IBOutlet UICollectionView * imagesCollection;
@property (nonatomic, weak) IBOutlet UILabel          * desc;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * collectionHeight;

@property (nonatomic, strong) ProductInfo * model;
@property (nonatomic, weak) IBOutlet UIView           * toolBar;
@property (nonatomic, weak) IBOutlet UIImageView      * moreButton;

@property (nonatomic, strong) MFJStatusButton         * locationButton;
@property (nonatomic, strong) MFJStatusButton         * commentsButton;
@property (nonatomic, strong) MFJStatusButton         * likeOrNoButton;


@property (nonatomic, strong) NSMutableArray          * imageViews;
@property (nonatomic, assign) CGSize                    imageSize;

@end

@implementation MFUHomeTBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageViews = [NSMutableArray array];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.userIcon.layer.cornerRadius = self.userIcon.width*0.5;
    self.userIcon.layer.masksToBounds = YES;
    self.collectionHeight.constant = 0;
    [self setUpToolBar];
    @weakify(self);
    self.moreButton.userInteractionEnabled = YES;
    [self.moreButton whenTapped:^{
        @strongify(self);
        if (self.delegate) {
            [self.delegate MFUHomeTBCell:self moreButtonDidSelect:nil];
        }
    }];
    
    self.likeOrNoButton.ButtonClick = ^{
        @strongify(self);
        
        if (!self.model) {
            return ;
        }
        
        NSNumber * islike;
        NSNumber * likecount;
        if (self.model.isLike) {
            
            islike = @0;
            likecount = [NSNumber numberWithInteger:(self.model.likeCount - 1)];
            self.model.isLike = NO;
            self.model.likeCount = (self.model.likeCount - 1);
            
        }else{
            
            islike = @1;
            likecount = [NSNumber numberWithInteger:(self.model.likeCount + 1)];
            self.model.isLike = YES;
            self.model.likeCount = (self.model.likeCount + 1);
            
        }
        
        NSString * pid = [NSString stringWithFormat:@"%li",self.model.pid];
        
        [[[YDog alloc] init] update:@"Products" values:@{@"isLike":islike,@"likeCount":likecount} where:@"pid" equeTo:pid complete:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                FuckYou(@"更新喜欢数成功！");
            }
            if (error) {
                FuckYou(@"更新喜欢数失败:%@",error);
            }
        }];
    };
    
}

- (void)configModel:(ProductInfo *)model
{
    
    self.model = model;
    [self setUpImageCollection];
    [self.imageViews removeAllObjects];
    [self.imagesCollection reloadData];
    self.desc.text = model.content;
    self.date.text = [NSString stringWithFormat:@"%li from %@",model.createTime,[NSString deviceVersion]];
    self.nick.text = self.model.user.nick;
    [self.userIcon yy_setImageWithURL:[NSURL URLWithString:model.user.avatar] options:YYWebImageOptionUseNSURLCache];
    [self.likeOrNoButton configureStatus:model.isLike text:[NSString stringWithFormat:@"%li",model.likeCount] animated:YES];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger rowNumber = self.model.images.count > kMaxRow ? kMaxRow : self.model.images.count ;
    return rowNumber;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MFUHomeImageCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"555" forIndexPath:indexPath];
    [cell setProductIamge:self.model.images[indexPath.row] size:self.imageSize];
    [self.imageViews addObject:cell.image];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray * data = [NSMutableArray array];
    for (int i = 0; i<self.imageViews.count; i++) {
        MFJPhotoGroupItem * item = [[MFJPhotoGroupItem alloc] init];
        MFJImageView * imageView = self.imageViews[i];
        item.thumbView = imageView;
        item.largeImageURL = [NSURL URLWithString:imageView.url];
        [data addObject:item];
    }
    
   NSInteger rr = indexPath.row;
    
    MFJPhotoGroupView * group = [[MFJPhotoGroupView alloc] initWithGroupItems:data];
    [group presentFromImageView:self.imageViews[rr] toController:self.viewController animated:YES completion:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpImageCollection
{
    CGFloat cellWidth = Screen_Width;
    CGFloat imageCount = self.model.images.count;
    CGSize  itemSize = CGSizeZero;
    
    if (imageCount == 0) {
        self.collectionHeight.constant = 0;
    }else if (imageCount == 1){
        self.collectionHeight.constant = cellWidth;
        itemSize = CGSizeMake(cellWidth, cellWidth);
    }else if (imageCount == 2){
        self.collectionHeight.constant = (cellWidth-kPadding)/2;
        itemSize = CGSizeMake((cellWidth-kPadding)/2, (cellWidth-kPadding)/2);
    }else if (imageCount == 3){
        self.collectionHeight.constant = (cellWidth-kPadding*2)/3;
        itemSize = CGSizeMake((cellWidth-kPadding*2)/3, (cellWidth-kPadding*2)/3);
    }else if (imageCount == 4){
        self.collectionHeight.constant = cellWidth;
        itemSize = CGSizeMake((cellWidth-kPadding)/2, (cellWidth-kPadding)/2);
    }else if (imageCount == 5 || imageCount == 6){
        self.collectionHeight.constant = (cellWidth-kPadding*2)/3*2+kPadding;
        itemSize = CGSizeMake((cellWidth-kPadding*2)/3, (cellWidth-kPadding*2)/3);
    }else if (6<imageCount && imageCount<10){
        self.collectionHeight.constant = cellWidth;
        itemSize = CGSizeMake((cellWidth-kPadding*2)/3, (cellWidth-kPadding*2)/3);
    }
    
    _imageSize = itemSize;
    _imagesCollection.showsHorizontalScrollIndicator = NO;
    _imagesCollection.showsVerticalScrollIndicator = NO;
    _imagesCollection.backgroundColor = [UIColor clearColor];
    _imagesCollection.delegate = self;
    _imagesCollection.dataSource = self;
    _imagesCollection.showsHorizontalScrollIndicator = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = itemSize;
    layout.minimumLineSpacing = kPadding;
    layout.minimumInteritemSpacing = kPadding;

    _imagesCollection.collectionViewLayout = layout;
    [_imagesCollection registerNib:[UINib nibWithNibName:@"MFUHomeImageCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"555"];
}


- (void)setUpToolBar
{
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 0.5)];
    line.backgroundColor = UIColorHex(0xf2f2f2);
    [self.toolBar addSubview:line];
    [self.toolBar addSubview:self.locationButton];
    [self.toolBar addSubview:self.commentsButton];
    [self.toolBar addSubview:self.likeOrNoButton];
}

- (MFJStatusButton *)locationButton
{
    if (!_locationButton) {
        CGRect rect = CGRectMake(0, 0.5, Screen_Width/3, 44.5);
        _locationButton = [[MFJStatusButton alloc] initWithFrame:rect
                                                           image:@"home_location"
                                                     selectImage:@""
                                                            text:@"Bei Jing"
                                                            type:MFJStatusButtonTypeNormal];
        _locationButton.backgroundColor = UIColorHex(0xffffff);
    }
    return _locationButton;
}

- (MFJStatusButton *)commentsButton
{
    if (!_commentsButton) {
        CGRect rect = CGRectMake(Screen_Width/3, 0.5, Screen_Width/3, 44.5);
        _commentsButton = [[MFJStatusButton alloc] initWithFrame:rect
                                                           image:@"home_comments"
                                                     selectImage:@""
                                                            text:@"Message"
                                                            type:MFJStatusButtonTypeNormal];
        _commentsButton.backgroundColor = UIColorHex(0xffffff);
    }
    return _commentsButton;
}

- (MFJStatusButton *)likeOrNoButton
{
    if (!_likeOrNoButton) {
        CGRect rect = CGRectMake(Screen_Width/3*2, 0.5, Screen_Width/3, 44.5);
        _likeOrNoButton = [[MFJStatusButton alloc] initWithFrame:rect
                                                           image:@"home_unlike"
                                                     selectImage:@"home_like"
                                                            text:@"Like"
                                                            type:MFJStatusButtonTypeLike];
        _likeOrNoButton.backgroundColor = UIColorHex(0xffffff);
        
    }
    return _likeOrNoButton;
}

@end
