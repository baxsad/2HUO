//
//  MFUSelectIamgeCollectionCell.m
//  2HUO
//
//  Created by iURCoder on 4/7/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFUSelectIamgeCollectionCell.h"

@interface MFUSelectIamgeCollectionCell ()

@property (nonatomic, weak) IBOutlet UIImageView * image;

@end

@implementation MFUSelectIamgeCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(NSData *)data
{
    _data = data;
    if (data) {
        [self.image setImage:[UIImage imageWithData:data]];
    }
}

@end
