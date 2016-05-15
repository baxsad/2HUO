//
//  BannerModel.h
//  2HUO
//
//  Created by iURCoder on 4/6/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol Banner;

@interface BannerModel : JSONModel

@property (nonatomic, strong) NSArray <Banner> * data;

@end


@interface Banner : JSONModel

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * image;
@property (nonatomic, copy) NSString * pid;

@end