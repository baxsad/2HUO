//
//  GDRequest.m
//  2HUO
//
//  Created by iURCoder on 4/30/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "GDRequest.h"

@implementation GDRequest

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
    req.cachePolicy = GDRequestCachePolicyReadCache;
    req.METHOD = @"GET";
    return req;
}

+ (GDReq *)getCommunityListRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"community/index.php";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.METHOD = @"GET";
    return req;
}

+ (GDReq *)getPostListRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"community/getCommunityPost.php";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.METHOD = @"GET";
    return req;
}

+ (GDReq *)addPostListRequest
{
    GDReq * req = [GDReq Request];
    req.PATH = @"community/addCommunityPost.php";
    req.responseSerializer = GDResponseSerializerTypeJSON;
    req.METHOD = @"POST";
    return req;
}

@end
