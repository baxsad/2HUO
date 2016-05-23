//
//  User.h
//  2HUO
//
//  Created by iURCoder on 4/7/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "School.h"
@interface User : JSONModel

@property (nonatomic, copy  ) NSString * uid;
@property (nonatomic, copy  ) NSString * alipay;
@property (nonatomic, copy  ) NSString * weixin;
@property (nonatomic, copy  ) NSString * nick;
@property (nonatomic, assign) NSInteger  sid;
@property (nonatomic, copy  ) NSString * desc;
@property (nonatomic, copy  ) NSString * avatar;
@property (nonatomic, copy  ) NSString * sex;// 0 - 女,1 - 男,2 - 未知
@property (nonatomic, copy  ) NSString * age;
@property (nonatomic, assign) NSInteger  type;// 0 - 普通，1 - 认证
@property (nonatomic, copy  ) NSString * platName;
@property (nonatomic, copy  ) NSString * token;
@property (nonatomic, copy  ) NSString * createDate;
@property (nonatomic, copy  ) NSString * lastTimeLogin;
@property (nonatomic, strong) School   * school;

@end
