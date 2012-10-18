//
//  AppDelegate.m
//  PrizeKing
//
//  Created by Andres Abril on 10/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "PurchaseHelper.h"
#import "Flurry.h"
#import "FlurryAds.h"
#import "TapjoyConnect.h"
#import "UAirship.h"
@implementation AppDelegate

@synthesize window = _window;
@synthesize facebook;



-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    //[FlurryAppCircle setAppCircleEnabled:YES];
    //[FlurryClips setVideoAdsEnabled:YES];
    //[FlurryAppCircle setAppCircleDelegate:[[MyAdDelegate alloc] init]];
    //[FlurryClips setVideoDelegate:[[MyVideoDelegate alloc] init]];
    //[Flurry startSession:@"NBTFB5JP4VTYRBW28JM7"];
    [TapjoyConnect requestTapjoyConnect:@"b48ce29e-f295-427e-a6cf-3ef398c6d7bd" secretKey:@"MgvRLI3iZAxlEFCSRpel"];
    //[TapjoyConnect initVideoAdWithDelegate:self];
    //[TapjoyConnect setVideoCacheCount:5];
    //[FlurryAnalytics startSession:@"NBTFB5JP4VTYRBW28JM7"];//prizeKing @ iam->need to change to tapmedia's account
    
    [AdColony initAdColonyWithDelegate:self];
    
    NSMutableDictionary *takeOffOptions = [[NSMutableDictionary alloc] init];
    [takeOffOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];
    [UAirship takeOff:takeOffOptions];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[PurchaseHelper sharedHelper]];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    return YES;
}
-(NSString*)adColonyApplicationID{
    return @"app2b3b302dc79d465c96dbf3";
}
-(NSDictionary*)adColonyAdZoneNumberAssociation{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"vzf0c489af413649efb5c69e", [NSNumber numberWithInt:1], //video zone 1
            @"vz9147a43f0f4c4513b439e4", [NSNumber numberWithInt:2], //video zone 2
            nil];
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[Facebook shared] handleOpenURL:url];
}
-(void)FBDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    NSLog(@"login delegate");
}
-(void)applicationWillResignActive:(UIApplication *)application{
}
-(void)applicationDidEnterBackground:(UIApplication *)application{
} 
-(void)applicationWillEnterForeground:(UIApplication *)application{
  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
-(void)applicationDidBecomeActive:(UIApplication *)application{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appClosing" object:nil];
}
-(void)applicationWillTerminate:(UIApplication *)application{
    [UAirship land];
}
#pragma mark - push notifications
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    FileSaver *fileSaver=[[FileSaver alloc]init];
    NSString *deviceTokenString=[NSString stringWithFormat:@"%@",deviceToken];
    NSString *parsedToken=[[[deviceTokenString stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""];
    [fileSaver setDeviceToken:parsedToken];
    [[UAirship shared] registerDeviceToken:deviceToken];
    NSLog(@"token name: %@", deviceToken);
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{
	FileSaver *fileSaver=[[FileSaver alloc]init];
    [fileSaver setDeviceToken:@"null"];
    NSLog(@"Failed to get token, error: %@", error);
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"Received notification %@",userInfo);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"remoteNotification" object:userInfo];
}

@end
