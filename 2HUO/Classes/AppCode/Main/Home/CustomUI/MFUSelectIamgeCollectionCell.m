//
//  MFUSelectIamgeCollectionCell.m
//  2HUO
//
//  Created by iURCoder on 4/7/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFUSelectIamgeCollectionCell.h"
#import "CALayer+MFJExtent.h"

@implementation DataModel


@end

@interface MFUSelectIamgeCollectionCell ()

@property (nonatomic, weak) IBOutlet UIImageView * image;
@property (nonatomic,   strong) UILabel  * progressLable;

@end

@implementation MFUSelectIamgeCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _progressLable = [[UILabel alloc] init];
    [self.image addSubview:_progressLable];
    [_progressLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _progressLable.textAlignment = NSTextAlignmentCenter;
    _progressLable.font = [UIFont systemFontOfSize:12];
    _progressLable.textColor = [UIColor whiteColor];

}

- (void)setProgress:(float)progress
{
    NSLog(@"%f",progress);
    _progress = progress;
    _progressLable.text = [NSString stringWithFormat:@"%f",progress];
    if (progress>=1) {
        _progressLable.hidden = YES;
        _data.isUpload = YES;
    }
    
}

- (void)setData:(DataModel *)data
{
    _data = data;
    if (data) {
        [self.image setImage:[UIImage imageWithData:data.data]];
    }
}

@end
