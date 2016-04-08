//
//  User.h
//  2HUO
//
//  Created by iURCoder on 4/7/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface User : JSONModel

@property (nonatomic, copy  ) NSString * uid;
@property (nonatomic, copy  ) NSString * nick;
@property (nonatomic, copy  ) NSString * school;
@property (nonatomic, copy  ) NSString * desc;
@property (nonatomic, copy  ) NSString * avatar;
@property (nonatomic, assign) NSInteger  sex;// 0 - 女,1 - 男,2 - 未知
@property (nonatomic, assign) NSInteger  type;// 0 - 普通，1 - 认证
@property (nonatomic, copy  ) NSString * platName;
@property (nonatomic, copy  ) NSString * token;
@property (nonatomic, copy  ) NSString * createDate;
@property (nonatomic, copy  ) NSString * lastTimeLogin;

@end
