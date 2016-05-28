//
//  EHHomeHeaderView.h
//  2HUO
//
//  Created by iURCoder on 5/13/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickAction)(NSInteger index);

@interface EHHomeHeaderView : UIView

@property (nonatomic, copy) clickAction handleAction;

- (void)configModels:(NSArray *)array;

@end
