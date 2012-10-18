//
//  OfferWallViewController.m
//  PrizeKing
//
//  Created by Andres Abril on 15/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OfferWallViewController.h"
#import "Flurry.h"
#import "FlurryAds.h"

@interface OfferWallViewController ()

@end

@implementation OfferWallViewController
@synthesize user;

- (void)viewDidLoad
{
    [super viewDidLoad];
    server=[[ServerCommunicator alloc]init];
    server.caller=self;
    /*banner = [FlurryAppCircle getHook:@"VIDEO_SPLASH_HOOK"
                                         xLoc:0
                                         yLoc:0
                                         view:self.view];*/
    [FlurryAds initialize:self];
    [self performSelector:@selector(update) withObject:nil afterDelay:1];
	// Do any additional setup after loading the view.
    // A notification method must be set to retrieve the featured app object.
    
    //[AdColony playVideoAdForZone:@"vzf0c489af413649efb5c69e" withDelegate:nil withV4VCPrePopup:YES andV4VCPostPopup:YES];
    //NSLog(@"ddd%@",[AdColony getVirtualCurrencyNameForSlot:1]);
    NSString *date=[self dateString];
    NSString *parameters=[NSString stringWithFormat:@"1500/%@/%@/%@/2/%@",user.ID,@"0",@"0",date];
    [server callServerWithMethod:@"ChargeCoinsUser" andParameter:parameters];
}
-(void)adColonyVideoAdNotServedForZone:(NSString *)zone{
    NSLog(@"No Video for zone %@", zone);
}
-(void)viewWillAppear:(BOOL)animated{
    //UIImage *view=[UIImage imageNamed:@"1000coins.png"];
    
    //[FlurryAppCircle openTakeover:@"STORE_VIDEO" orientation:nil rewardImage:view rewardMessage:@"Baja esta app y ganarás " userCookies:nil];
    //[TapjoyConnect initVideoAdWithDelegate:self];
    //[TapjoyConnect showFeaturedAppFullScreenAdWithViewController:self];
    //[TapjoyConnect showOffersWithViewController:self withInternalNavBar:YES];
    //[AdColony playVideoAdForSlot:1 withDelegate:nil withV4VCPrePopup:YES withV4VCPostPopup:YES];
    //[AdColony playVideoAdForZone:@"" withDelegate:self withV4VCPrePopup:YES withV4VCPostPopup:YES];
}
- (void) adColonyTakeoverBeganForZone:(NSString *)zone {
    NSLog(@"AdColony video ad launched for zone %@", zone);
}
- (void) adColonyTakeoverEndedForZone:(NSString *)zone withVC:(BOOL)withVirtualCurrencyAward {
    NSString *date=[self dateString];
    NSString *parameters=[NSString stringWithFormat:@"100/%@/%@/%@/2/%@",user.ID,@"0",@"0",date];
    [server callServerWithMethod:@"ChargeCoinsUser" andParameter:parameters];
    NSLog(@"Ended video");
}
-(NSString*)dateString{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd-HHmmss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [formatter setTimeZone:timeZone];
    NSDate *now = [[NSDate alloc] init];
    NSString *date=[formatter stringFromDate:now];
    NSDate *date2=[formatter dateFromString:date];
    NSTimeInterval seconds = [date2 timeIntervalSince1970];
    NSString *date3=[NSString stringWithFormat:@"%.0f",seconds];
    NSLog(@"segundos entre fechas %@",date3);
    return date3;
}
-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"appeared");
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
-(void)update{
    //[FlurryAds showAdForSpace:@"STORE_VIDEO" view:self.view size:FULLSCREEN timeout:3000];
    //[FlurryAppCircle updateHook:banner];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || 
    (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
-(IBAction)goBack:(id)sender{
    [self.navigationController.view.layer addAnimation:[NavAnimations navAlphaAnimation] forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)videoAdBegan{
    NSLog(@"Began video");
}
- (void)videoAdClosed{
    NSLog(@"vid closed");
    [TapjoyConnect getTapPoints];
}

- (void)getFeaturedApp:(NSNotification*)notifyObj
{

    // Displays a full screen ad, showing the current featured app.
    [TapjoyConnect showFeaturedAppFullScreenAd];
    
    // OR
    // This is used when you want to add the full screen ad to an existing view controller.
    //[TapjoyConnect showFeaturedAppFullScreenAdWithViewController:self];
}
#pragma  mark - button Actions
-(IBAction)videos:(id)sender{
    [AdColony playVideoAdForSlot:1 withDelegate:self withV4VCPrePopup:YES andV4VCPostPopup:YES];
}
-(IBAction)tapjoy:(id)sender{
    [TapjoyConnect showOffersWithViewController:self withInternalNavBar:YES];
}
-(IBAction)featuredApp:(id)sender{
    [TapjoyConnect getFeaturedApp];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFeaturedApp:) name:TJC_FEATURED_APP_RESPONSE_NOTIFICATION object:nil];
    //[TapjoyConnect showFeaturedAppFullScreenAdWithViewController:self];
}







@end
