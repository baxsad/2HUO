//
//  GDGridViewController.h
//  2HUO
//
//  Created by iURCoder on 4/10/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDAssetManager.h"

@interface GDGridViewController : UICollectionViewController

@property (nonatomic, strong) GDAlbumModel * albumModel;

- (instancetype)init;

@end
