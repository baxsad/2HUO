//
//  EHAddressCell.h
//  2HUO
//
//  Created by iURCoder on 5/6/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SellerModel;

typedef void(^SelectButtonClickCallBack)(SellerModel * model,int aid,BOOL def);

@interface EHAddressCell : UITableViewCell

@property (nonatomic, copy) SelectButtonClickCallBack selectCallBack;


- (void)reloadAddressInfo:(SellerModel *)model;


@end
