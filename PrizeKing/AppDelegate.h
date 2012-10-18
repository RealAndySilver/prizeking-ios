//
//  AppDelegate.h
//  PrizeKing
//
//  Created by Andres Abril on 10/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookSingleton.h"
#import "TapjoyConnect.h"
#import "TJCVideoAdProtocol.h"
#import "FileSaver.h"
#import "AdColonyPublic.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,TJCVideoAdDelegate,AdColonyDelegate>{
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) Facebook *facebook;
@end
