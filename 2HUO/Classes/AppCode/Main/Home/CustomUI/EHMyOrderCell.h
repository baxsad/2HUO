//
//  EHMyOrderCell.h
//  2HUO
//
//  Created by iURCoder on 5/18/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Order;
@interface EHMyOrderCell : UITableViewCell
- (void)configModel:(Order *)model;
@end
