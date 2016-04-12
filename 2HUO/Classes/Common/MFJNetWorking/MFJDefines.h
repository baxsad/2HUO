//
//  MFJNETDefines.h
//  2HUO
//
//  Created by iURCoder on 3/31/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#ifndef MFJNETDefines_h
#define MFJNETDefines_h

#import <AFNetworking/AFNetworking.h>

#ifdef isTest

//测试接口

#define kFileUpload @"182.92.180.73"
static  NSString* const kWebBaseUrl = @"http://10.0.1.12:8081/iLikeTest/";

#define kHostPath @"10.0.1.12:8081/iLikeTest/"

#else

//正式接口
#define kFileUpload @"182.92.180.73"
static NSString* const kWebBaseUrl = @"http://www.caimiapp.com/";

#define kHostPath @"www.caimiapp.com/api_260/"

#endif

#define MFJ_REQUEST_RIGHT_CODE  0
#define MFJ_ERROR_CODE_PATH     @"error_code"

// 网络请求类型RequestCachePolicy
typedef NS_ENUM(NSUInteger, MFJRequestMethodType) {
    MFJRequestMethodTypeGET     = 0 ,
    MFJRequestMethodTypePOST    = 1 << 0,
    MFJRequestMethodTypeHEAD    = 1 << 1,
    MFJRequestMethodTypePUT     = 3 << 0,
    MFJRequestMethodTypePATCH   = 1 << 2,
    MFJRequestMethodTypeDELETE  = 5 << 0
};

// RequestCachePolicy
typedef NS_ENUM(NSUInteger, MFJRequestCachePolicy) {
    MFJRequestCachePolicyNoCache           = 0 , /**< 不缓存    */
    MFJRequestCachePolicyReadCache         = 1 << 0, /**< 缓存,每次都优先从缓存读取    */
    MFJRequestCachePolicyReadCacheFirst    = 1 << 1 /**< 缓存,第一次从缓存读取以后不读缓存    */
};

// 网络请求状态
typedef NS_ENUM(NSInteger, MFJRequestStatus) {
    MFJRequestStatusSending = 0 << 1,  /**< 请求发送中    */
    MFJRequestStatusSuccess = 1 << 0,  /**< 请求成功      */
    MFJRequestStatusFailed  = 1 << 1,  /**< 请求失败      */
    MFJRequestStatusError   = 3 << 0,  /**< 请求错误      */
    MFJRequestStatusCancle  = 1 << 2,  /**< 请求已取消    */
    MFJRequestStatusTimeOut = 5,       /**< 请求超时      */
    MFJRequestStatusNotStart= 6,       /**< 请求未开始    */
    MFJRequestStatusStart   = 7        /**< 开始请求      */
};

// 请求的序列化格式
typedef NS_ENUM(NSUInteger, MFJRequestSerializerType) {
    MFJRequestSerializerTypeHTTP    = 0,
    MFJRequestSerializerTypeJSON    = 1 << 0
};

// 请求返回的序列化格式
typedef NS_ENUM(NSUInteger, MFJResponseSerializerType) {
    MFJResponseSerializerTypeHTTP    = 0,
    MFJResponseSerializerTypeJSON    = 1 << 0
};

/**
 *  SSL Pinning
 */
typedef NS_ENUM(NSUInteger, MFJSSLPinningMode) {
    /**
     *  不校验Pinning证书
     */
    MFJSSLPinningModeNone,
    /**
     *  校验Pinning证书中的PublicKey.
     *  知识点可以参考
     *  https://en.wikipedia.org/wiki/HTTP_Public_Key_Pinning
     */
    MFJSSLPinningModePublicKey,
    /**
     *  校验整个Pinning证书
     */
    MFJSSLPinningModeCertificate,
};

typedef void (^MFJRequestBlock)(void);

// MFJ 默认的请求超时时间
#define MFJ_API_REQUEST_TIME_OUT     29
#define MAX_HTTP_CONNECTION_PER_HOST 5


#endif /* MFJNETDefines_h */
