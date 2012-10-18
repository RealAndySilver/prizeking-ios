//
//  OfferWallViewController.h
//  PrizeKing
//
//  Created by Andres Abril on 15/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavAnimations.h"
#import "Tapjoyconnect.h"
#import "AdColonyPublic.h"
#import "ServerCommunicator.h"
#import "User.h"


@interface OfferWallViewController : UIViewController<TJCVideoAdDelegate,AdColonyTakeoverAdDelegate>{
    UIView *banner;
    ServerCommunicator *server;
}
@property(nonatomic,retain)User *user;
@end
