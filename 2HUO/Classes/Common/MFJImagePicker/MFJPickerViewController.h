//
//  MFJPickerViewController.h
//  2HUO
//
//  Created by iURCoder on 4/9/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MFJPickerViewController : UINavigationController

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil UNAVAILABLE_ATTRIBUTE;



/// 用这个初始化方法
- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount;

/// 默认最大可选9张图片
@property (nonatomic, assign) NSInteger maxImagesCount;

@property (nonatomic, assign) BOOL allowPickingVideo;

@end
