//
//  EHPostDetailCell.h
//  2HUO
//
//  Created by iURCoder on 5/10/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PostInfo;

@interface EHPostDetailCell : UITableViewCell

- (void)configModel:(PostInfo *)model;

@end
