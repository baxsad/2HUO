//
//  MFUHomeMenuCell.m
//  2HUO
//
//  Created by iURCoder on 3/29/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFUHomeMenuCell.h"
#import "MFUMenuButtonCell.h"
#import "Type.h"

@interface MFUHomeMenuCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView * collectionView;

@property (nonatomic,copy) NSArray * menuInfoArray ;

@property (nonatomic, strong) ProductType * model;

@end

@implementation MFUHomeMenuCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(155, 95);
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _collectionView.collectionViewLayout = layout;
    [_collectionView registerNib:[UINib nibWithNibName:@"MFUMenuButtonCell" bundle:nil] forCellWithReuseIdentifier:@"MFUMenuButtonCell"];
    
    [[YDog shareInstance] selectFrom:@"Type" type:SearchTypeEqualTo where:@"type" is:@"hot" page:@"1" complete:^(NSArray *objects, NSError *error) {
        
        _model = [[ProductType alloc] initWithDictionary:@{@"list":objects} error:nil];
        [self.collectionView reloadData];
        
    }];
    
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _model.list.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MFUMenuButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MFUMenuButtonCell" forIndexPath:indexPath];
    Type * type = _model.list[indexPath.item];
    [cell.icon yy_setImageWithURL:[NSURL URLWithString:type.icon] placeholder:nil];
    return cell;
}


@end
