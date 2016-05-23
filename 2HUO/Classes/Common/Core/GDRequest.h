//
//  GDRequest.h
//  2HUO
//
//  Created by iURCoder on 4/30/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "GDReq.h"

@interface GDRequest : GDReq

// 手机号登录
+ (GDReq *)loginUsePhoneRequest;

// 手机号注册
+ (GDReq *)regUsePhoneRequest;

// 获取验证码
+ (GDReq *)getSMSVerificationCode;

// 首页数据
+ (GDReq *)gethomeModelRequest;

// 获取地区
+ (GDReq *)getAreaListRequest;

// 获取地区+学校
+ (GDReq *)getAreaAndSchoolListRequest;

#pragma mark 用户

// 用户登录
+ (GDReq *)userLoginRequest;

// 获取学校列表
+ (GDReq *)getSchoolListRequest;

// 获取地址列表
+ (GDReq *)getAddressListRequest;

// 添加地址
+ (GDReq *)addAddressRequest;

// 修改地址
+ (GDReq *)updateAddressRequest;

// 删除地址
+ (GDReq *)deleteAddressRequest;

// 默认地址
+ (GDReq *)getDefAddressRequest;

// 修改用户信息
+ (GDReq *)updateUserInfoRequest;

#pragma mark  商品

// 获取分类列表
+ (GDReq *)getCommunityListRequest;

// 获取商品列表
+ (GDReq *)getPostListRequest;

// 发布商品
+ (GDReq *)addPostListRequest;

// 喜欢商品
+ (GDReq *)likePostRequest;

// 添加评论
+ (GDReq *)addCommentsRequest;

// 获取评论
+ (GDReq *)getCommentsRequest;

// 检查是否可以购买
+ (GDReq *)checkIsOnSaleRequest;

// 获取订单信息
+ (GDReq *)getOrderRequest;

// 确认订单
+ (GDReq *)makeOrderRequest;

// 获取订单列表
+ (GDReq *)getOrderListRequest;

// 获取我喜欢的商品列表
+ (GDReq *)getMyLikePostListRequest;

// 取消订单
+ (GDReq *)cancleOrderRequest;

@end
