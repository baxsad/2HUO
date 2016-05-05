//
//  EHMineMenuCell.h
//  2HUO
//
//  Created by iURCoder on 5/3/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHMineMenuCell : UITableViewCell
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isLast;
- (void)configWithDic:(NSDictionary *)dic;
@end
