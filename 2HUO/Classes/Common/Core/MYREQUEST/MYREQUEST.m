//
//  Created by iURCoder on 11/3/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import "MYREQUEST.h"



@implementation MYREQUEST

+ (id)uploadPictureModel:(UploadPictureModel)model
{
    MYREQUEST* request = [MYREQUEST Request];
    request.SCHEME = @"http";
    request.HOST = @"http://x.mouto.org";
    request.PATH = @"wb/x.php?up";
    request.METHOD = @"POST";
    return request;
}

+ (id)getHomeContents
{
    MYREQUEST * request = [MYREQUEST Request];
    request.PATH = @"latest.json"; /** 接口名字 */
    request.METHOD = @"GET"; /** 请求方法 */
    request.needCheckCode = NO; /** 默认不检测状态码 */
    request.requestSerializer  = wRequestSerializerJSON; /** 不设置的话默认都是 JSON 格式 */
    request.responseSerializer = wResponseSerializerJSON; /** 不设置的话默认都是 JSON 格式 */
    request.timeoutInterval = 30; /** 默认超时时间60s */
    return request;
    
}



@end
