//
//  Created by iURCoder on 11/3/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import "SceneModel.h"

@implementation SceneModel

+(instancetype)SceneModel{
    return [[self alloc] initModel];
}

- (id)initModel{
    self = [super init];
    if(self){
        [self loadSceneModel];
    }
    return self;
}

- (void)loadSceneModel{
    self.action = [Action wAction];
    self.action.aDelegaete = self;
}


- (void)handleActionMsg:(BaseRequest *)msg{
    if(msg.sending){
        
    }else if(msg.succeed){
        
    }else if(msg.failed){
        
    }
}

- (void)handleProgressMsg:(BaseRequest *)msg{
    
}

-(void)DO_DOWNLOAD:(BaseRequest *)req{
    if(req !=nil){
        [self.action Download:req];
    }
}

- (void)SEND_ACTION:(BaseRequest *)req{
    if(req !=nil){
        [self.action Send:req];
    }
}

- (void)SEND_CACHE_ACTION:(BaseRequest *)req{
    [self.action readFromCache];
    [self SEND_ACTION:req];
}

- (void)SEND_NO_CACHE_ACTION:(BaseRequest *)req{
    [self.action notReadFromCache];
    [self SEND_ACTION:req];
}

- (void)SEND_IQ_ACTION:(BaseRequest *)req{
    if (req.isFirstRequest) {
        req.isFirstRequest = NO;
        [self.action readFromCache];
    }else{
        [self.action notReadFromCache];
    }
    [self SEND_ACTION:req];
}


@end

