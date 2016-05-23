//
//  GDRequest.m
//  2HUO
//
//  Created by iURCoder on 4/30/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "GDRequest.h"

@implementation GDRequest

+ (GDReq *)loginUsePhoneRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"user/x.loginUsePhone.post.php";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.needCheckCode = YES;
    req.METHOD = @"POST";
    return req;
}

+ (GDReq *)regUsePhoneRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"user/x.phoneReg.post.php";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.needCheckCode = YES;
    req.METHOD = @"POST";
    return req;
}

+ (GDReq *)getSMSVerificationCode
{
    GDReq * req = [GDReq Request];
    req.PATH = @"SMS/SendTemplateSMS.php";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.needCheckCode = YES;
    req.METHOD = @"GET";
    return req;
}

+ (GDReq *)gethomeModelRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"index.php";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.needCheckCode = YES;
    req.METHOD = @"GET";
    return req;
}

+ (GDReq *)getAreaListRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"Location/x.getLocation.get.php";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.cachePolicy = GDRequestCachePolicyReadCache;
    req.needCheckCode = YES;
    req.METHOD = @"GET";
    return req;
}

+ (GDReq *)getAreaAndSchoolListRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"Location/x.getCityAndSchool.get.php";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.cachePolicy = GDRequestCachePolicyReadCache;
    req.needCheckCode = YES;
    req.METHOD = @"GET";
    return req;
}

+ (GDReq *)userLoginRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"user/logAccount.php";
    req.needCheckCode = YES;
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.METHOD = @"POST";
    return req;
}

+ (GDReq *)getSchoolListRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"user/x.school.get.php";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.cachePolicy = GDRequestCachePolicyNoCache;
    req.METHOD = @"GET";
    return req;
}

+ (GDReq *)getAddressListRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"user/x.address.get.php";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.needCheckCode = YES;
    req.METHOD = @"GET";
    return req;
}
+ (GDReq *)addAddressRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"user/x.address.post.php";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.needCheckCode = YES;
    req.METHOD = @"POST";
    return req;
}
+ (GDReq *)updateAddressRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"user/x.address.update.post.php";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.needCheckCode = YES;
    req.METHOD = @"POST";
    return req;
}
+ (GDReq *)deleteAddressRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"user/x.address.delete.post.php";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.needCheckCode = YES;
    req.METHOD = @"POST";
    return req;
}

+ (GDReq *)getDefAddressRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"user/x.address.get.php";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.needCheckCode = YES;
    req.METHOD = @"GET";
    return req;
}

/////////

+ (GDReq *)getCommunityListRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"community/x.community.get.php";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.METHOD = @"GET";
    return req;
}

+ (GDReq *)getPostListRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"community/x.getCommunityPost.get.php";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.METHOD = @"GET";
    return req;
}

+ (GDReq *)addPostListRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"community/x.addCommunityPost.post.php";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.needCheckCode = YES;
    req.METHOD = @"POST";
    return req;
}

+ (GDReq *)likePostRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"community/x.likePost.post.php";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.needCheckCode = YES;
    req.METHOD = @"POST";
    return req;
}

+ (GDReq *)addCommentsRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"community/x.addComments.post.php";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.needCheckCode = YES;
    req.METHOD = @"POST";
    return req;
}

+ (GDReq *)getCommentsRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"community/x.getComments.get.php";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.METHOD = @"GET";
    return req;
}

+ (GDReq *)updateUserInfoRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"user/x.updateUserInfo.post.php";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.needCheckCode = YES;
    req.METHOD = @"POST";
    return req;
}

+ (GDReq *)checkIsOnSaleRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"community/x.placeOrder.post.php";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.needCheckCode = YES;
    req.METHOD = @"POST";
    return req;
}

+ (GDReq *)getOrderRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"community/x.getOrder.get.php";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.needCheckCode = YES;
    req.METHOD = @"GET";
    return req;
}

+ (GDReq *)makeOrderRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"community/x.makeOrder.post.php";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.needCheckCode = YES;
    req.METHOD = @"POST";
    return req;
}

+ (GDReq *)getOrderListRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"community/x.getMyOrder.get.php";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.needCheckCode = YES;
    req.METHOD = @"GET";
    return req;
}

+ (GDReq *)getMyLikePostListRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"community/x.getMyLikePost.get.php";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.needCheckCode = YES;
    req.METHOD = @"GET";
    return req;
}

+ (GDReq *)cancleOrderRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"community/x.cancleOrder.post.php";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.needCheckCode = YES;
    req.METHOD = @"POST";
    return req;
}

@end
