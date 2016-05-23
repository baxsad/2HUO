//
//  Account.m
//  2HUO
//
//  Created by iURCoder on 4/7/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "AccountCenter.h"
#import "User.h"
#import "TMCache.h"
#import <YYWebImage/YYWebImage.h>

@interface AccountCenter ()

@property (nonatomic, strong) GDReq * userLoginRequest;
@property (nonatomic, strong) GDReq * updateUserInfoRequest;
@property (nonatomic, strong) GDReq * getSMSVerificationCodeRequest;
@property (nonatomic, strong) GDReq * regUsePhoneRequest;
@property (nonatomic, strong) GDReq * loginUsePhoneRequest;

@end

@implementation AccountCenter

+ (instancetype)shareInstance
{
    static AccountCenter *account;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        account = [[AccountCenter alloc] init];
        account.userLoginRequest = [GDRequest userLoginRequest];
        account.updateUserInfoRequest = [GDRequest updateUserInfoRequest];
        account.getSMSVerificationCodeRequest = [GDRequest getSMSVerificationCode];
        account.regUsePhoneRequest = [GDRequest regUsePhoneRequest];
        account.loginUsePhoneRequest = [GDRequest loginUsePhoneRequest];
        
    });
    return account;
}

- (void)save:(User *)user
{
    
    if (!user) {
        [[TMCache sharedCache] removeObjectForKey:kUSERCACHE];
        self.user = nil;
        self.token =nil;
        self.userHeadFace = nil;
        
    }else{
        self.user = user;
        self.token = user.token;
        self.userHeadFace = [UIImage imageWithUrl:user.avatar];
        [[TMCache sharedCache] setObject:self.user forKey:kUSERCACHE block:^(TMCache* cache, NSString* key, id object) {
            
        }];
    }
    
    
}

- (void)login:(UMSocialSnsType)type viewController:(UIViewController*)viewController complete:(UserLoginCallBack)complete
{
    [self loginWithType:type viewController:viewController data:^(BOOL success, User *user) {
        if (success && user) {
            if (complete) {
                complete(YES);
            }
            [self save:user];
        }else{
            if (complete) {
                complete(NO);
            }
        }
    }];
}

- (void)loginWithType:(UMSocialSnsType)type viewController:(UIViewController*)viewController data:(UserLoginResultBlock)complete
{
    
    [self.userLoginRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            User * user = [[User alloc] initWithDictionary:req.output[@"data"] error:nil];
            if (user) {
                complete(YES,user);
            }else{
                complete(NO,nil);
            }
        }
        if (req.failed) {
            complete(NO,nil);
        }
        
    }];
    
    NSString * platforName = [UMSocialSnsPlatformManager getSnsPlatformString:type];
    
    
    if ([UMSocialAccountManager isOauthAndTokenNotExpired:platforName]) {
        
        UMSocialAccountEntity* snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platforName];
        
        if (snsAccount.accessToken.length == 0) {
            [GDHUD showMessage:@"授权失败，请稍后再试" timeout:1];
            return;
        }
        
        if (complete) {
            
            // 登录
            [self loginWithParams:snsAccount];
            
        }
    }else {
        
        [UMSocialSnsPlatformManager getSocialPlatformWithName:platforName].loginClickHandler(viewController, [UMSocialControllerService defaultControllerService], YES, ^(UMSocialResponseEntity* response) {
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platforName];
                
                if (snsAccount.accessToken.length == 0) {
                    [GDHUD showMessage:@"授权失败，请稍后再试" timeout:1];
                    return;
                }
                
                // 登录
                
                [self loginWithParams:snsAccount];
                
            }else{
                if (complete) {
                    complete(NO,nil);
                }
            }
        });
    }
}

- (void)loginWithParams:(UMSocialAccountEntity*)snsAccount
{
    
    
    NSDictionary * info = @{@"nick":snsAccount.userName,
                            @"platId":snsAccount.usid,
                            @"avatar":snsAccount.iconURL,
                            @"platName":snsAccount.platformName};
    [self.userLoginRequest.params setValue:info[@"nick"] forKey:@"nick"];
    [self.userLoginRequest.params setValue:info[@"platId"] forKey:@"platId"];
    [self.userLoginRequest.params setValue:info[@"avatar"] forKey:@"avatar"];
    [self.userLoginRequest.params setValue:info[@"platName"] forKey:@"platName"];
    self.userLoginRequest.requestNeedActive = YES;
    
    
}

- (void)logout
{
    [self logoutWithType:UMSocialSnsTypeSina];
    [self logoutWithType:UMSocialSnsTypeMobileQQ];
    [self logoutWithType:UMSocialSnsTypeWechatSession];
    
}

- (void)logoutWithType:(UMSocialSnsType)type
{
    NSString* platforName = [UMSocialSnsPlatformManager getSnsPlatformString:type];
    if ([UMSocialAccountManager isOauthAndTokenNotExpired:platforName]) {
        [[UMSocialDataService defaultDataService] requestUnOauthWithType:platforName completion:^(UMSocialResponseEntity* response) {
            [self save:nil];
        }];
    }
    [self save:nil];
}

- (void)updateUserInfo:(NSDictionary *)info complete:(UpdateUserCallBack)complete
{
    [self.updateUserInfoRequest.params removeAllObjects];
    [self.updateUserInfoRequest.params setValue:USER.uid forKey:@"uid"];
    
    for (NSString * key in info) {
        [self.updateUserInfoRequest.params setValue:info[key] forKey:key];
    }
    
    [self.updateUserInfoRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            User * user = [[User alloc] initWithDictionary:req.output[@"data"] error:nil];
            if (user) {
                [self save:user];
                complete(YES);
            }else{
                complete(NO);
            }
        }
        if (req.failed) {
            complete(NO);
        }
    }];
    
    self.updateUserInfoRequest.requestNeedActive = YES;
    
}

- (void)clearCache:(ClearCacheCallBack)callback
{
    [[TMCache sharedCache] removeAllObjects];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    [cache.diskCache removeAllObjectsWithProgressBlock:^(int removedCount, int totalCount) {
        // progress
        if (callback) {
            callback(NO,removedCount/totalCount);
        }
    } endBlock:^(BOOL error) {
        // end
        if (callback) {
            callback(YES,1.0);
        }
    }];
    
}

- (void)getSMSCode:(NSString *)phone complete:(GetSMSCodeCallBack)complete
{
    if (self.getSMSVerificationCodeRequest.status == GDRequestStatusSending) {
        [self.getSMSVerificationCodeRequest cancle];
    }
    [self.getSMSVerificationCodeRequest.params setValue:phone forKey:@"phone"];
    self.getSMSVerificationCodeRequest.requestNeedActive = YES;
    [self.getSMSVerificationCodeRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            if (complete) {
                complete(YES);
            }
        }
        if (req.failed) {
            if (complete) {
                complete(NO);
            }
        }
    }];
}

- (void)regWithParams:(NSDictionary *)params complete:(RegCallBack)complete
{
    if (self.regUsePhoneRequest.status == GDRequestStatusSending) {
        [self.regUsePhoneRequest cancle];
    }
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self.regUsePhoneRequest.params setValue:obj forKey:key];
    }];
    self.regUsePhoneRequest.requestNeedActive = YES;
    [self.regUsePhoneRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            if (complete) {
                complete(YES);
            }
        }
        if (req.failed) {
            if (complete) {
                complete(NO);
            }
        }
    }];
}

- (void)loginWithParams:(NSDictionary *)params complete:(RegCallBack)complete
{
    if (self.loginUsePhoneRequest.status == GDRequestStatusSending) {
        [self.loginUsePhoneRequest cancle];
    }
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self.loginUsePhoneRequest.params setValue:obj forKey:key];
    }];
    self.loginUsePhoneRequest.requestNeedActive = YES;
    [self.loginUsePhoneRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            
            User * user = [[User alloc] initWithDictionary:req.output[@"user"] error:nil];
            if (user) {
                [self save:user];
                complete(YES);
            }else{
                complete(NO);
            }
            
        }
        if (req.failed) {
            if (complete) {
                complete(NO);
            }
        }
    }];
}

@end
