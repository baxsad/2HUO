//
//  MFJAssetModel.m
//  2HUO
//
//  Created by iURCoder on 4/9/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFJAssetModel.h"

@implementation MFJAssetModel

+ (instancetype)modelWithAsset:(id)asset type:(MFJAssetModelMediaType)type{
    MFJAssetModel *model = [[MFJAssetModel alloc] init];
    model.asset = asset;
    model.isSelected = NO;
    model.type = type;
    return model;
}

+ (instancetype)modelWithAsset:(id)asset type:(MFJAssetModelMediaType)type timeLength:(NSString *)timeLength {
    MFJAssetModel *model = [self modelWithAsset:asset type:type];
    model.timeLength = timeLength;
    return model;
}

@end


@implementation MFJAlbumModel

@end