//
//  FacebookSingleton.h
//  PrizeKing
//
//  Created by Andres Abril on 26/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"
#define kFBAccessTokenKey  @"FBAccessTokenKey"
#define kFBExpirationDateKey  @"FBExpirationDateKey"

@interface Facebook (Singleton) <FBSessionDelegate>
- (void)authorize;
- (void)logout;
+ (Facebook *)shared;
+ (void)niler;


@end
