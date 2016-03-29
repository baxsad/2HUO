//
//  Created by iURCoder on 11/3/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "WrSingleton.h"
#import "ActionDelegate.h"
#import "AFNetworking.h"


/*! @brief Functional class for a request network
 *
 *  Including sending requests to intercede, results processing, cache settings
 *  Such a dependency on the properties of the basereq class （BaseReq.h）
 */

@interface Action : NSObject
/**
 *  声明一个协议，来对外发送请求状态的信息
 */
@property(nonatomic, weak) id <ActionDelegate> aDelegaete;
/**
 *  创建一个单例，存储请求的一些信息（参数配置,！只执行一次，可以放在 AppDelegate 里面执行～）
 */
AS_SINGLETON(Action)
/**
 *  初始化请求
 *  @parmas host:服务器地址  clint:客户端名字  codeKey:状态码标示  rightCode:成功标示  msgKey:返回消息标示
 */
+ (void)actionConfigServer:(NSString *)host client:(NSString *)client codeKey:(NSString *)codeKey rightCode:(NSInteger)rightCode msgKey:(NSString *)msgKey;
/**
 *  返回类对象
 */
+ (id)wAction;
/**
 *  创建一个发送请求的对象，默认使用缓存
 */
- (id)initWithCache;
/**
 *  网络请求发送成功
 */
- (void)success:(BaseRequest *)req;
/**
 *  网络请求出现错误
 */
- (void)error:(BaseRequest *)req;
/**
 *  请求失败
 */
- (void)failed:(BaseRequest *)req;
/**
 *  设置请求使用缓存
 */
- (void)useCache;
/**
 *  从缓存中读取
 */
- (void)readFromCache;
/**
 *  不读取缓存数据
 */
- (void)notReadFromCache;
/**
 *  发送请求
 *  @parmas 构建的basereq对象（包含一些请求需要的参数）
 */
- (NSURLSessionDataTask *)Send:(BaseRequest *)req;
/**
 *  下载请求
 *  @parmas 构建的basereq对象（包含一些请求需要的参数）
 */
- (NSURLSessionDataTask *)Download:(BaseRequest *)req;

@end
