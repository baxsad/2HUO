//
//  OrderListModel.h
//  2HUO
//
//  Created by iURCoder on 5/18/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "OrderModel.h"

@protocol Order;
@class ProductInfo;

@interface OrderListModel : JSONModel

@property (nonatomic, strong) NSArray <Order> * data;

@end

@interface Order : JSONModel

@property (nonatomic, assign) NSInteger oid;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger createdTime;
@property (nonatomic, strong) ProductInfo * productInfo;

@end
