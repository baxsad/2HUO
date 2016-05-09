//
//  EHUserInfoScene.h
//  2HUO
//
//  Created by iURCoder on 5/5/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "IHBaseViewController.h"


@class SellerModel;

typedef NS_ENUM(NSUInteger, AddressStatus) {
    AddressStatusNone           = 0 ,
    AddressStatusAdd            = 1,
    AddressStatusUpdate         = 2
};

@interface EHUserInfoScene : IHBaseViewController

@property (nonatomic, assign) AddressStatus   status;
@property (nonatomic, strong) SellerModel   * sellerModel;

@end
