//
//  EHCommentCell.h
//  2HUO
//
//  Created by iURCoder on 5/10/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Comment;

@interface EHCommentCell : UITableViewCell

- (void)configModel:(Comment *)model;

@end

