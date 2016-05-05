//
//  GDRequest.h
//  2HUO
//
//  Created by iURCoder on 4/30/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "GDReq.h"

@interface GDRequest : GDReq

// 用户登录
+ (GDReq *)userLoginRequest;

// 获取学校列表
+ (GDReq *)getSchoolListRequest;

// 获取分类列表
+ (GDReq *)getCommunityListRequest;

// 获取商品列表
+ (GDReq *)getPostListRequest;

// 发布商品
+ (GDReq *)addPostListRequest;

@end
