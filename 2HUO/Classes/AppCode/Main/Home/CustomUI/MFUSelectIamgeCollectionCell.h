//
//  MFUSelectIamgeCollectionCell.h
//  2HUO
//
//  Created by iURCoder on 4/7/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataModel : NSObject

@property (nonatomic,assign) BOOL isUpload;
@property (nonatomic, strong) NSData * data;

@end

@interface MFUSelectIamgeCollectionCell : UICollectionViewCell

@property (nonatomic, strong) DataModel * data;
@property (nonatomic, assign) float progress;
@property (nonatomic, assign) BOOL     isADD;

@end
