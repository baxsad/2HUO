//
//  MFJPhotoGroupView.h
//  2HUO
//
//  Created by iURCoder on 3/26/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MFJLoopViewCell : UICollectionViewCell

@property (weak, nonatomic) UIImageView *imageView;
@property (copy, nonatomic) NSString *title;

@property (nonatomic, strong) UIColor *titleLabelTextColor;
@property (nonatomic, strong) UIFont *titleLabelTextFont;
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;
@property (nonatomic, assign) CGFloat titleLabelHeight;

@end
