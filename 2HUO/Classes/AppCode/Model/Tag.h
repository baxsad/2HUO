//
//  Tag.h
//  2HUO
//
//  Created by iURCoder on 4/7/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface Tag : JSONModel

@property (nonatomic, assign) NSInteger   tagId;
@property (nonatomic, copy  ) NSString  * tagName;

@end
