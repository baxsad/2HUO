//
//  EHAddressCell.h
//  2HUO
//
//  Created by iURCoder on 5/6/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectButtonClickCallBack)(int aid,BOOL def);

@class SellerModel;

@interface EHAddressCell : UITableViewCell

@property (nonatomic, copy) SelectButtonClickCallBack selectCallBack;


- (void)reloadAddressInfo:(SellerModel *)model;


@end
