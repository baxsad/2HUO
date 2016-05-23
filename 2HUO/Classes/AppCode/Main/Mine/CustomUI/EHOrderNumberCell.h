//
//  EHOrderNumberCellTableViewCell.h
//  2HUO
//
//  Created by iURCoder on 5/20/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderModel;

@interface EHOrderNumberCell : UITableViewCell

- (void)reloadOrderNumber:(OrderModel *)model;

@end
