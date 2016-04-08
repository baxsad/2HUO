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

@implementation AccountCenter

+ (instancetype)shareInstance
{
    static AccountCenter *account;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        account = [[AccountCenter alloc] init];
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
        return;
    }
    
    self.user = user;
    self.token = user.token;
    self.userHeadFace = [UIImage imageWithUrl:user.avatar];
    [[TMCache sharedCache] setObject:self.user forKey:kUSERCACHE block:^(TMCache* cache, NSString* key, id object) {
        
    }];
}


- (void)loginWithType:(UMSocialSnsType)type viewController:(UIViewController*)viewController data:(UserLoginResultBlock)complete
{
    
    
    NSString * platforName = [UMSocialSnsPlatformManager getSnsPlatformString:type];
    
    
    if ([UMSocialAccountManager isOauthAndTokenNotExpired:platforName]) {
        
        UMSocialAccountEntity* snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platforName];
        
        if (snsAccount.accessToken.length == 0) {
            [O2HUD showMessage:@"授权失败，请稍后再试" timeout:1];
            return;
        }
        
        if (complete) {
            
            [[YDog shareInstance] selectFrom:@"V_User" type:SearchTypeEqualTo where:@"uid" is:snsAccount.usid page:nil complete:^(NSArray *objects, NSError *error) {
                if (objects.count>0) {
                    NSDictionary * info = objects[0];
                    User * user = [[User alloc] initWithDictionary:info error:nil];
                    if (complete) {
                        complete(YES,user);
                    }
                }else{
                    if (complete) {
                        complete(NO,nil);
                    }
                }
            }];
        }
    }else {
        
        [UMSocialSnsPlatformManager getSocialPlatformWithName:platforName].loginClickHandler(viewController, [UMSocialControllerService defaultControllerService], YES, ^(UMSocialResponseEntity* response) {
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platforName];
                
                if (snsAccount.accessToken.length == 0) {
                    [O2HUD showMessage:@"授权失败，请稍后再试" timeout:1];
                    return;
                }
                
                [[YDog dog] selectFrom:@"V_User" type:SearchTypeEqualTo where:@"uid" is:snsAccount.usid page:nil complete:^(NSArray *objects, NSError *error) {
                    if (objects.count > 0) {
                        NSDictionary * info = objects[0];
                        User * user = [[User alloc] initWithDictionary:info error:nil];
                        if (complete) {
                            complete(YES,user);
                        }
                    }else{
                        [self reg:snsAccount complete:complete];
                    }
                }];
                
            }else{
                if (complete) {
                    complete(NO,nil);
                }
            }
        });
    }
}

- (void)reg:(UMSocialAccountEntity*)snsAccount complete:(UserLoginResultBlock)complete
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDictionary * info = @{@"nick":snsAccount.userName,
                            @"uid":snsAccount.usid,
                            @"token":snsAccount.accessToken.MD5,
                            @"avatar":snsAccount.iconURL,
                            @"createDate":currentDateStr,
                            @"lastTimeLogin":currentDateStr,
                            @"platName":snsAccount.platformName};
    
    [[YDog dog] insertInto:@"V_User" values:info complete:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            User * user = [[User alloc] initWithDictionary:info error:nil];
            if (complete) {
                complete(YES,user);
            }
        }else{
            if (complete) {
                complete(NO,nil);
            }
        }
    }];
}

- (void)logoutWithType:(UMSocialSnsType)type complete:(UserLogoutCallBack)callBack
{
    NSString* platforName = [UMSocialSnsPlatformManager getSnsPlatformString:type];
    if ([UMSocialAccountManager isOauthAndTokenNotExpired:platforName]) {
        [[UMSocialDataService defaultDataService] requestUnOauthWithType:platforName completion:^(UMSocialResponseEntity* response) {
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                [[TMCache sharedCache] removeObjectForKey:kUSERCACHE];
                [self save:nil];
                if (callBack) {
                    callBack(YES);
                }
            }else{
                if (callBack) {
                    callBack(NO);
                }
            }
            
        }];
    }else{
        
        [[TMCache sharedCache] removeObjectForKey:kUSERCACHE];
    }
}

@end