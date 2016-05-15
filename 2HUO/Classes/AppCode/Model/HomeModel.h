//
//  HomeModel.h
//  2HUO
//
//  Created by iURCoder on 5/12/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol PostInfo,Banner;

@interface HomeModel : JSONModel

@property (nonatomic, strong) NSArray <Banner>*banner;
@property (nonatomic, strong) NSArray <Banner>*homeFooterMenu;
@property (nonatomic, strong) NSArray <PostInfo>*post;

@end
