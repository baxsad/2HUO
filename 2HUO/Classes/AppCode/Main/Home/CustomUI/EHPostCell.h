//
//  MFUHomeTBListCell.h
//  2HUO
//
//  Created by iURCoder on 3/24/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PostInfo,EHPostCell;

@protocol EHPostCellDelegate

- (void)EHPostCell:(EHPostCell *)cell moreButtonDidSelect:(PostInfo *)model;
- (void)EHPostCell:(EHPostCell *)cell likeButtonDidSelect:(PostInfo *)model IsLike:(BOOL)like likeCount:(NSInteger)count;

@end

@interface EHPostCell : UITableViewCell

@property (nonatomic, strong) id<EHPostCellDelegate>delegate;

@property (nonatomic, assign) NSInteger row;

- (void)configModel:(PostInfo *)model;

@end
