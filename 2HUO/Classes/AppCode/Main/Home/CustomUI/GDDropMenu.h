//
//  GDDropMenu.h
//  2HUO
//
//  Created by iURCoder on 5/12/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GDDropMenu;

typedef NS_ENUM(NSUInteger, GDMenuStatus) {
    GDMenuStatusHiden    = 0,
    GDMenuStatusShow    = 1 << 0
};

@protocol GDDropMenuDelegate <NSObject>

@required

- (NSInteger)menu:(GDDropMenu *)menu numberOfRowsInSection:(NSInteger)section;

- (NSString *)menu:(GDDropMenu *)menu titleForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (NSInteger)numberOfSectionsInMenu:(GDDropMenu *)menu;

- (NSString *)menu:(GDDropMenu *)menu titleForHeaderInSection:(NSInteger)section;

- (void)menu:(GDDropMenu *)menu didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface GDDropMenu : UIView

@property (nonatomic, weak) id<GDDropMenuDelegate>delegate;

- (instancetype)initOrg:(CGPoint)origin inView:(UIView *)view;

- (void)show;

@end
