//
//  FacebookSingleton.m
//  PrizeKing
//
//  Created by Andres Abril on 26/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FacebookSingleton.h"

@implementation Facebook (Singleton)
- (id)init {
    if ((self = [self initWithAppId:@"437775826235557" andDelegate:self])) {
        [self authorize];
    }
    return self;
}

- (void)authorize {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:kFBAccessTokenKey] && [defaults objectForKey:kFBExpirationDateKey]) {
        self.accessToken = [defaults objectForKey:kFBAccessTokenKey];
        self.expirationDate = [defaults objectForKey:kFBExpirationDateKey];
        NSLog(@"authorize if 1 ");
    }
    
    if (![self isSessionValid]) {
        NSArray *permissions =  [[NSArray alloc] initWithObjects:
                                 @"email",
                                 nil];
        [self authorize:permissions];
        NSLog(@"authorize if 2 ");
    }
}

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self accessToken] forKey:kFBAccessTokenKey];
    [defaults setObject:[self expirationDate] forKey:kFBExpirationDateKey];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"requestFacebookData" object:self];
    NSLog(@"didlogin single");
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    if (cancelled) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FBLoginCancelled" object:self];
        NSLog(@"Canceled");
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FBLoginFailed" object:self];
        NSLog(@"failed");
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FBDidNotLogin" object:self];
}

- (void)fbDidLogout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kFBAccessTokenKey];
    [defaults removeObjectForKey:kFBExpirationDateKey];
    [defaults synchronize];
    self.accessToken = nil;
    self.expirationDate = nil;
    shared=nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FBDidLogout" object:self];
    NSLog(@"Logued out singleton");
}

static Facebook *shared = nil;
+(void)niler{
    shared=nil;
}
+ (Facebook *)shared {
    @synchronized(self) {
        if(shared == nil)
            shared = [[self alloc] init];
    }
    return shared;
}
@end
