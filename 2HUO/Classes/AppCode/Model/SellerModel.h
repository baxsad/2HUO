//
//  SellerModel.h
//  2HUO
//
//  Created by iURCoder on 5/6/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class School;

@protocol SellerModel;

@interface SellerModels : JSONModel

@property (nonatomic, strong) NSArray<SellerModel>*data;

@end

@interface SellerModel : JSONModel

@property (nonatomic, assign) NSInteger aid;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger defaultAddress;
@property (nonatomic, copy) NSString * alipay;
@property (nonatomic, copy) NSString * weixin;
@property (nonatomic, copy) NSString * idCard;
@property (nonatomic, copy) NSString * location;
@property (nonatomic, copy) NSString * userName;
@property (nonatomic, copy) NSString * numberCard;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, strong) School * school;
@property (nonatomic, copy) NSString * IDCard;

@end
