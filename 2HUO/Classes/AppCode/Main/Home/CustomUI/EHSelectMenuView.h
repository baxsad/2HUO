//
//  EHSelectMenuView.h
//  2HUO
//
//  Created by iURCoder on 5/4/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^tapCallBack)();

@interface EHSelectMenuView : UIView

@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * content;
@property (nonatomic,copy) tapCallBack block;

@end
