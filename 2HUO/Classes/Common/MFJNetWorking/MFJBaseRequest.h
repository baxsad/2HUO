//
//  MFJBaseRequest.h
//  2HUO
//
//  Created by iURCoder on 3/31/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFJNETDefines.h"

@interface MFJBaseRequest : NSObject

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
@property(nonatomic,assign)MFJRequestStatus             status;
/** 请求的链接 */
@property(nonatomic,strong)NSURL                      * url;
/** 错误消息或者服务器返回的MSG */
@property(nonatomic,strong)NSString                   * message;
/** 错误码返回 */
@property(nonatomic,strong)NSString                   * codeKey;
/** 正确码 */
@property(nonatomic,strong)NSString                   * exactitudeKey;
/** key path */
@property(nonatomic,strong)NSString                   * keyPath;
/** 协议（http:/https:/ftp:） */
@property(nonatomic,strong)NSString                   * SCHEME;
/** 域名 */
@property(nonatomic,strong)NSString                   * HOST;
/** 请求路径 */
@property(nonatomic,strong)NSString                   * PATH;
/** 提交方式 (GET/POST)*/
@property(nonatomic,assign)MFJRequestMethodType         METHOD;
/** 是否需要检查错误码 */
@property(nonatomic,assign)BOOL                         needCheckCode;
/** 请求数据格式 */
@property(nonatomic,assign)MFJRequestSerializerType     requestSerializer;
/** 返回数据格式 */
@property(nonatomic,assign)MFJResponseSerializerType    responseSerializer;
/** 可接受的序列化返回数据的格式 */
@property(nonatomic,strong)NSSet                      * acceptableContentTypes;
/** Http头参数设置 */
@property(nonatomic,strong)NSDictionary               * httpHeaderFields;
/** 是否启动发送请求(为MVVM设计) */
@property(nonatomic,assign)BOOL                         requestNeedActive;
/** AFN返回的AFHTTPRequestOperation */
@property(nonatomic,strong)NSURLSessionDataTask       * task;
/** 设置请求超时时间，默认是60S。*/
@property (nonatomic, assign) NSTimeInterval            timeoutInterval;
/** 请求是否超时 */
@property(nonatomic,assign)BOOL                         isTimeout;
/** 是否第一次加载 */
@property(nonatomic,assign)BOOL                         isFirstRequest;


/** 上传文件列表 */
@property(nonatomic,strong)NSDictionary               * requestFiles;
/** 上传/下载进度 */
@property(nonatomic,assign)double                       progress;
/** 已上传数据大小 */
@property(nonatomic,assign)long long                    totalBytesWritten;
/** 全部需要上传的数据大小 */
@property(nonatomic,assign)long long                    totalBytesNeedToWrite;

@property (nonatomic, copy, nullable) void (^requestProgressBlock)( NSProgress * _Nullable progress);

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

- (instancetype)init UNAVAILABLE_ATTRIBUTE;

+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

+ (instancetype)Request;

- (instancetype)initRequest;

- (BOOL)succeed;

- (BOOL)sending;

- (BOOL)failed;

- (BOOL)Error;

- (BOOL)cancled;

- (BOOL)timeOut;

- (void)start;

- (void)cancle;

- (NSUInteger)hash;

- (NSURLRequestCachePolicy)RequestCachePolicy;

@end
