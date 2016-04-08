//
//  Account.h
//  2HUO
//
//  Created by iURCoder on 4/7/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocial.h"

@class User;

typedef NS_ENUM(NSUInteger, UserLoginType) {
    UserLoginTypeWeiBo                = 0,
    UserLoginTypeOICQ                 = 1,
    
};

typedef void (^UserLoginResultBlock)(BOOL success, User * user);
typedef void (^UserLogoutCallBack)(BOOL success);

@interface AccountCenter : NSObject

@property (nonatomic, strong) User     * user;
@property (nonatomic,   copy) NSString * token;
@property (nonatomic, strong) UIImage  * userHeadFace;

+ (instancetype)shareInstance;

- (void)save:(User *)user;

- (void)loginWithType:(UMSocialSnsType)type viewController:(UIViewController*)viewController data:(UserLoginResultBlock)complete;

- (void)logoutWithType:(UMSocialSnsType)type complete:(UserLogoutCallBack)callBack;

@end
