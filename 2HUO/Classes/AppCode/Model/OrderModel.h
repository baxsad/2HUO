//
//  OrderModel.h
//  2HUO
//
//  Created by iURCoder on 5/17/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "School.h"
#import "SellerModel.h"

@class ProductInfo;

@interface OrderModel : JSONModel

@property (nonatomic, assign) NSInteger oid;
@property (nonatomic,   copy) NSString  *orderNumber;
@property (nonatomic, assign) NSInteger suid;
@property (nonatomic, assign) NSInteger buid;
@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) SellerModel *saleAddress;
@property (nonatomic, strong) SellerModel *buyerAddress;

@property (nonatomic, strong) ProductInfo *productInfo;

@end

@interface ProductInfo : JSONModel

@property (nonatomic, assign) NSInteger pid;
@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, assign) NSInteger sid;
@property (nonatomic,   copy) NSString  *transactionMode;
@property (nonatomic,   copy) NSString  *communityType;
@property (nonatomic,   copy) NSString  *schoolName;
@property (nonatomic,   copy) NSString  *title;
@property (nonatomic,   copy) NSString  *content;
@property (nonatomic, strong) NSArray   *images;
@property (nonatomic, assign) float originalPrice;
@property (nonatomic, assign) float presentPrice;
@property (nonatomic, assign) float shippingCount;

@end
