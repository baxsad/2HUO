//
//  MFUHomeTBListCell.h
//  2HUO
//
//  Created by iURCoder on 3/24/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductModel,MFUHomeTBCell;

@protocol MFUCellDelegate

- (void)MFUHomeTBCell:(MFUHomeTBCell *)cell moreButtonDidSelect:(ProductModel *)model;

@end

@interface MFUHomeTBCell : UITableViewCell

@property (nonatomic, strong) id<MFUCellDelegate>delegate;

@property (nonatomic, assign) NSInteger row;

- (void)configModel:(ProductModel *)model;

@end
