//
//  MFUHomeImageCollectionCell.h
//  2HUO
//
//  Created by iURCoder on 3/24/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFJImageView.h"

@interface MFUHomeImageCollectionCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet MFJImageView * image;

- (void)setProductIamge:(NSString *)url size:(CGSize)size;

@end
