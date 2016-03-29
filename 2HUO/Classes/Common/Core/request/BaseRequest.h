//
//  Created by iURCoder on 11/3/15.
//  Copyright © 2015 iUR. All rights reserved.
//

////////////////////////////////////////////////////////
////////////////version:2.1  motify:2015.10.29//////////
///////////////////Merry Christmas=。=//////////////////
////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "ReactiveCocoa.h"

#define AppSecret @"test"
#define BASE_URL @"http://zhuangbi.me"

typedef NS_ENUM(NSInteger, wRequestStatus) {
    wRequestStatusSending = 0 << 1,  /**< 请求发送中    */
    wRequestStatusSuccess = 1 << 0,  /**< 请求成功    */
    wRequestStatusFailed  = 1 << 1,  /**< 请求失败    */
    wRequestStatusError   = 3 << 0,  /**< 请求错误    */
    wRequestStatusCancle  = 1 << 2,  /**< 请求已取消    */
    wRequestStatusTimeOut = 5        /**< 请求超时    */
};

typedef NS_ENUM(NSInteger, wRequestSerializer) {
    wRequestSerializerJSON            = 1 << 0, /**< JSON格式请求     */
    wRequestSerializerHTTP            = 1 << 1, /**< 二进制格式请求     */
    wRequestSerializerPropertyList    = 3 << 0  /**< PLIST格式请求     */
};

typedef NS_ENUM(NSInteger, wResponseSerializer) {
    wResponseSerializerJSON    = 1 << 0, /**< 返回JSON格式     */
    wResponseSerializerHTTP    = 1 << 1, /**< 返回二进制格式     */
    wResponseSerializerXML     = 3 << 0  /**<返回XML格式     */
};

typedef void (^wRequestBlock)(void);

#pragma mark - BaseResp
/**
 * ! @brief 该类为所有响应类的基类
 */
@interface BaseRequest : NSObject
/** DATA 数据 */
@property(nonatomic,strong)NSData                     * outputData;
/** 序列化后的数据 */
@property(nonatomic,strong)NSDictionary               * output;
/** 请求使用字典参数 */
@property(nonatomic,strong)NSMutableDictionary        * params;
/** wcf请求需要的参数 */
@property(nonatomic,strong)NSString                   * soapMessage;
/** 获取的字符串数据 */
@property(nonatomic,strong)NSString                   * responseString;
/** 请求的错误 */
@property(nonatomic,strong)NSError                    * error;
/** /Request状态 */
@property(nonatomic,assign)wRequestStatus               status;
/** 请求的链接 */
@property(nonatomic,strong)NSURL                      * url;
/** 错误消息或者服务器返回的MSG */
@property(nonatomic,strong)NSString                   * message;
/** 错误码返回 */
@property(nonatomic,strong)NSString                   * codeKey;
/** 协议（http:/https:/ftp:） */
@property(nonatomic,strong)NSString                   * SCHEME;
/** 域名 */
@property(nonatomic,strong)NSString                   * HOST;
/** 请求路径 */
@property(nonatomic,strong)NSString                   * PATH;
/** 提交方式 (GET/POST)*/
@property(nonatomic,strong)NSString                   * METHOD;
/** 是否需要检查错误码 */
@property(nonatomic,assign)BOOL                         needCheckCode;
/** 请求数据格式 */
@property(nonatomic,assign)wRequestSerializer           requestSerializer;
/** 返回数据格式 */
@property(nonatomic,assign)wResponseSerializer          responseSerializer;
/** 可接受的序列化返回数据的格式 */
@property(nonatomic,strong)NSSet                      * acceptableContentTypes;
/** Http头参数设置 */
@property(nonatomic,strong)NSDictionary               * httpHeaderFields;
/** 是否启动发送请求(为MVVM设计) */
@property(nonatomic,assign)BOOL                         requestNeedActive;
/** AFN返回的AFHTTPRequestOperation */
@property(nonatomic,strong)NSURLSessionDataTask       * task;
/** 请求的 Block (发送请求)  */
@property(nonatomic,copy)wRequestBlock                  requestInActiveBlock;
/** 设置请求超时时间，默认是60S。*/
@property (nonatomic, assign) NSTimeInterval            timeoutInterval;
/** 请求是否超时 */
@property(nonatomic,assign)BOOL                         isTimeout;
/** 是否第一次加载 */
@property(nonatomic,assign)BOOL                         isFirstRequest;


/*＊
 *! @brief 上传相关参数
 */
/** 上传文件列表 */
@property(nonatomic,strong)NSDictionary               * requestFiles;
/** 上传/下载进度 */
@property(nonatomic,assign)double                       progress;
/** 已上传数据大小 */
@property(nonatomic,assign)long long                    totalBytesWritten;
/** 全部需要上传的数据大小 */
@property(nonatomic,assign)long long                    totalBytesNeedToWrite;

/*＊
 *! @brief download下载相关参数
 */
/** 下载链接 */
@property(nonatomic,strong)NSString                   * downloadUrl;
/** 下载到目标路径 */
@property(nonatomic,strong)NSString                   * targetPath;
/** 已下载传数据大小 */
@property(nonatomic,assign)long long                    totalBytesRead;
/** 全部需要下载的数据大小 */
@property(nonatomic,assign)long long                    totalBytesNeedToRead;
/** 是否冻结，下次联网时继续(保留设计) */
@property(nonatomic,assign)BOOL                         freezable;

/*! @brief 缓存识别码
 *
 *  根绝请求地址生成唯一缓存识别码
 */
- (NSString *)cacheKey;

/*! @brief 创建请求请求
 *
 *  @see BaseResp
 */

+ (id)Request;
+ (id)RequestWithBlock:(wRequestBlock)voidBlock;//初始化block

/*! @brief 请求是否成功
 *
 *  YES NO
 */
- (BOOL)succeed;
/*! @brief 请求是否在发送中
 *
 *  YES NO
 */
- (BOOL)sending;
/*! @brief 请求是否失败
 *
 *  YES NO
 */
- (BOOL)failed;
/*! @brief 请求是否取消
 *
 *  YES NO
 */
- (BOOL)cancled;
/*! @brief 请求是否超时
 *
 *  YES NO
 */
- (BOOL)timeOut;
/*! @brief 取消本次请求
 *
 *  用于取消本次已经发出去的网络请求
 */
- (void)cancle;

@end
