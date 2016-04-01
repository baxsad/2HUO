//
//  MFUHomeTBListCell.m
//  2HUO
//
//  Created by iURCoder on 3/24/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFUHomeTBCell.h"
#import "MFUHomeImageCollectionCell.h"
#import "ProductModel.h"
#import "MFJStatusButton.h"

#import "MFJPhotoGroupView.h"
#import "MFJImageView.h"

#define kPadding 2
#define kMaxRow 9

@interface MFUHomeTBCell()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UIImageView      * userIcon;
@property (nonatomic, weak) IBOutlet UILabel          * nick;
@property (nonatomic, weak) IBOutlet UILabel          * date;
@property (nonatomic, weak) IBOutlet UICollectionView * imagesCollection;
@property (nonatomic, weak) IBOutlet UILabel          * desc;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * collectionHeight;

@property (nonatomic, strong) ProductModel * model;
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
}

- (void)configModel:(ProductModel *)model
{
    
    self.model = model;
    [self setUpImageCollection];
    [self.imageViews removeAllObjects];
    [self.imagesCollection reloadData];
    self.desc.text = model.desc;
    self.date.text = [NSString stringWithFormat:@"%@ from %@",model.date,[NSString deviceVersion]];
    BOOL like = arc4random()%200 > 100;
    NSInteger count = arc4random()%200;
    NSString * scount = [NSString stringWithFormat:@"%li",count];
    [self.likeOrNoButton configureStatus:like text:like?[NSString stringWithFormat:@"%li",count]:scount animated:YES];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger rowNumber = self.model.productImages.count > kMaxRow ? kMaxRow : self.model.productImages.count ;
    return rowNumber;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MFUHomeImageCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"555" forIndexPath:indexPath];
    [cell setProductIamge:self.model.productImages[indexPath.row] size:self.imageSize];
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
    CGFloat imageCount = self.model.productImages.count;
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
