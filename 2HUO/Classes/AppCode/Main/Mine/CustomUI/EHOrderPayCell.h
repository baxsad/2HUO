//
//  EHOrderPayCell.h
//  2HUO
//
//  Created by iURCoder on 5/22/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHOrderPayCell : UITableViewCell

@property (nonatomic, assign) BOOL isSelect;
- (void)configModel:(NSString *)model;

@end
