//
//  GDImagePickerController.m
//  2HUO
//
//  Created by iURCoder on 4/10/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "GDImagePickerController.h"
#import "GDGridViewController.h"

@implementation GDImagePickerController

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount
{
    GDGridViewController * grid = [[GDGridViewController alloc] init];
    self = [super initWithRootViewController:grid];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
}

@end
