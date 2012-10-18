//  BidViewController.m
//  PrizeKing
//  Created by Andres Abril on 15/06/12.
//  Copyright (c) 2012 iAmStudio SAS. All rights reserved.
//

#import "BidViewController.h"

@interface BidViewController ()

@end

@implementation BidViewController
@synthesize user;

-(void)viewDidLoad{
    [super viewDidLoad];
    buyView=[[BuyCoinsView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
    [buyView bgInitWithVC:self];
    //buyView.alpha=0;
    [self.view addSubview:buyView];
    [self userInfo];
    file=[[FileSaver alloc]init];
    scrollView=[[UIScrollView alloc]init];
    scrollView.frame=CGRectMake(0, self.view.frame.size.width/6.5, self.view.frame.size.height, 235);
    [self.view addSubview:scrollView];  
    server=[[ServerCommunicator alloc]init];
    server.caller = self;
    coin=[[CoinCaller alloc]init];
    coin.caller=self;
    peticion=0;
    descontar=0;
    monedasTemporales=0;
    
    profileView=[[ProfileView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
    [profileView bgInitWithVC:self andUser:user];
    
    coinSpinner=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    coinSpinner.frame=CGRectMake(userCoins.frame.origin.x+10, userCoins.frame.origin.y+5, 10, 10);
    coinSpinner.alpha=0;
    [self.view addSubview:coinSpinner];
    [self.view addSubview:profileView];

    UITapGestureRecognizer *labelTapRecognizer = [[UITapGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(ClickEventOnImage:)];
    [labelTapRecognizer setNumberOfTouchesRequired:1];
    [labelTapRecognizer setDelegate:self];
    
    UITapGestureRecognizer *coinsTapRecognizer = [[UITapGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(ClickEventOnCoins:)];
    [labelTapRecognizer setNumberOfTouchesRequired:1];
    [labelTapRecognizer setDelegate:self];
    
    UITapGestureRecognizer *imageTapRecognizer = [[UITapGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(ClickEventOnImage:)];
    [imageTapRecognizer setNumberOfTouchesRequired:1];
    [imageTapRecognizer setDelegate:self];
    
    userCoins.userInteractionEnabled = YES;
    [userCoins addGestureRecognizer:coinsTapRecognizer];
    
    userImage.userInteractionEnabled = YES;
    userName.userInteractionEnabled = YES;
    [userImage addGestureRecognizer:imageTapRecognizer];
    [userName addGestureRecognizer:labelTapRecognizer];
    
    
    
    [self loadAuctionsFromServer];
    //[self getUserCoins];
}
-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appClosing) name:@"appClosing" object:nil];
    NSArray *viewsToRemove = [scrollView subviews];
    for (BidView *v in viewsToRemove){
        if ([v respondsToSelector:@selector(threadStartRefresher)]) {
            [v performSelector:@selector(threadStartRefresher)];
        }
        //[v removeFromSuperview];
    }
    [self ClickEventOnCoins:nil];
}
-(void)viewDidUnload:(BOOL)animated{
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"appClosing" object:nil];
    NSLog(@"Unloaded");
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"appClosing" object:nil];
    NSLog(@"Killed timers");
    NSArray *viewsToRemove = [scrollView subviews];
    for (BidView *v in viewsToRemove){
        if ([v respondsToSelector:@selector(invalidateTimer)]) {
            [v performSelector:@selector(invalidateTimer)];
        }
    }
}

-(void)appClosing{
    [self loadAuctionsFromServer];
}
-(void)viewDidUnload{
    [super viewDidUnload];
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || 
    (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
-(IBAction)goBack:(id)sender{
    [self.navigationController.view.layer addAnimation:[NavAnimations navAlphaAnimation] forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}
-(IBAction)goToViewFromStoryBoardTrigger:(UIButton*)sender{
    [self goToViewWith:sender];
}
-(void)buyViewAppear{
    [self.view bringSubviewToFront:buyView];
    [buyView setViewAlphaToOne];
}
-(void)goToViewWith:(UIButton*)sender{
    if (sender.tag==0) {
        [self.navigationController.view.layer addAnimation:[NavAnimations navAlphaAnimation] forKey:nil];
        BidViewController *bVC=[[BidViewController alloc]init];
        bVC=[self.storyboard instantiateViewControllerWithIdentifier:@"BidViewController"];
        [self.navigationController pushViewController:bVC animated:NO];
    }
    else if (sender.tag==1) {
        [self buyViewAppear];
    }
    else if (sender.tag==2) {
        //NSLog(@"Esta sección va a otro botón random");
    }
    else if (sender.tag==3) {
        OfferWallViewController *owVC=[[OfferWallViewController alloc]init];
        [self.navigationController.view.layer addAnimation:[NavAnimations navAlphaAnimation] forKey:nil];
        owVC=[self.storyboard instantiateViewControllerWithIdentifier:@"OfferWall"];
        NSLog(@"Offer wall user %@",owVC.user.ID);
        owVC.user=user;
        [self.navigationController pushViewController:owVC animated:NO];
    }
    else if (sender.tag==4) {
        //NSLog(@"Esta sección va a Facebook lead");
    }
    else if (sender.tag==5) {
        TestimonialsViewController *tVC=[[TestimonialsViewController alloc]init];
        [self goToNextViewControllerWithVC:tVC andIdentifier:@"Testimonials"];
    }
    else if (sender.tag==6) {
        //NSLog(@"Esta sección va a Ajustes");
        OptionsViewController *oVC=[[OptionsViewController alloc]init];
        oVC=[self.storyboard instantiateViewControllerWithIdentifier:@"Options"];
        [self goToNextViewControllerWithVC:oVC andIdentifier:@"Options"];
    }
}
-(void)goToNextViewControllerWithVC:(UIViewController*)viewController andIdentifier:(NSString*)identifier{
    [self.navigationController.view.layer addAnimation:[NavAnimations navAlphaAnimation] forKey:nil];
    viewController=[self.storyboard instantiateViewControllerWithIdentifier:identifier];
    [self.navigationController pushViewController:viewController animated:NO];
}
#pragma mark- scrollview dinamic size set and reload
-(void)cargarScrollViewConArray:(NSMutableDictionary*)dic enPos:(int)posicion{
    int viewMargin=0;
    int viewHeight=235;
    int position=5+(130*posicion);
    BidView *bid=[[BidView alloc]initWithFrame:CGRectMake(position, viewMargin, 129, viewHeight)];
    bid.user=user;
    [bid initBidWithDictionary:dic andContext:self];
    bid.alpha=0;
    [scrollView addSubview:bid];
    [self animarEntradaDeBids:bid conTiempo:posicion*0.5];
    if (position<self.view.frame.size.width) {
        scrollView.contentSize=CGSizeMake(self.view.frame.size.width+1, 210);
    }
    else{
        scrollView.contentSize=CGSizeMake(position+129, 210);
    }
    scrollView.showsHorizontalScrollIndicator=NO;
}
-(void)animarEntradaDeBids:(UIView*)bid conTiempo:(float)tiempo{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:tiempo];
    bid.alpha=1;
    [UIView commitAnimations];
}
#pragma mark - user info update
-(void)userInfo{
    //currentUser.coins=[file getCoinsQuantity];
    NSString *fullName=[NSString stringWithFormat:@"%@ %@",user.firstName,user.lastName];
    userName.text=fullName;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterScientificStyle];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formattedString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:user.coins]];
    userCoins.text=[NSString stringWithFormat:@"§%@",formattedString];
    userImage.layer.cornerRadius = 2.0;
    userImage.layer.masksToBounds = YES;
    userImage.image=user.image;
    userImage.contentMode = UIViewContentModeScaleAspectFill;
}
#pragma mark - bid actions
-(void)placeBidWithTag:(int)tag{
    if (tag==100) {
        descontar=1000;
        [self getUserCoins];
    }
    else if (tag==101) {
        descontar=500;
        [self getUserCoins];
    }
    else if (tag==102) {
        descontar=125;
        [self getUserCoins];
    }
}

-(void)getCurrentCoins:(double)currentCoins AndSubstract:(double)coinsToSubstract{
    double result=0;
    if ((currentCoins-coinsToSubstract)>=0) {
        result=currentCoins-coinsToSubstract;
        monedasTemporales=result;
        [self getUserCoinsAndDiscount];
    }
    else {
        result=currentCoins;
        user.coins=result;
        [self coinStoreAlphaIn];
    }
}
-(void)getCurrentCoinsAndAdd:(NSString*)coinsToAdd{
    monedasTemporales=[coinsToAdd doubleValue];
    [self getUserCoinsAndAdd];
}
-(void)coinStoreAlphaIn{
    [self.view bringSubviewToFront:buyView];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    buyView.alpha=1;
    [UIView commitAnimations];
}
-(IBAction)reloadAuctions:(id)sender{
    [self loadAuctionsFromServer];
}
#pragma mark - server request methods
-(void)loadAuctionsFromServer{
    peticion=1;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Loading Auctions";
    [server callServerWithMethod:@"GetLastAuctions" andParameter:@"6"];
}
-(void)getUserCoins{
    peticion=2;
    NSLog(@"facebook id coins %@",user.ID);
    [server callServerWithMethod:@"GetUserCoins" andParameter:user.ID];
}
-(void)getUserCoinsAndDiscount{
    peticion=3;
    NSLog(@"getUserCoinsAndDiscount %.0f",user.coins);
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [formatter setTimeZone:timeZone];
    NSDate *now = [[NSDate alloc] init];
    NSString *date=[formatter stringFromDate:now];
    NSLog(@"Log de la fecha %@",date);
    NSString *parameters=[NSString stringWithFormat:@"%.0f/%@/%@/%@/%@",monedasTemporales,user.ID,@"0",@"0",date];
    [server callServerWithMethod:@"ChargeCoinsUser" andParameter:parameters];
}
-(void)getUserCoinsAndAdd{
    peticion=4;
    NSLog(@"getUserCoinsAndAdd %.0f",monedasTemporales);
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [formatter setTimeZone:timeZone];
    NSDate *now = [[NSDate alloc] init];
    NSString *date=[formatter stringFromDate:now];
    NSLog(@"Log de la fecha %@",date);
    NSString *parameters=[NSString stringWithFormat:@"%.0f/%@/%@/%@/3",monedasTemporales,user.ID,@"0",@"0"];
    [server callServerWithMethod:@"ChargeCoinsUser" andParameter:parameters];
}
#pragma mark - server response

-(void)receivedDataFromServer:(id)sender{
    server=sender;
    NSLog(@"Response  %@",server.resDic);
    if (peticion==1) {
        NSArray *viewsToRemove = [scrollView subviews];
        for (BidView *v in viewsToRemove){
            if ([v respondsToSelector:@selector(invalidateTimer)]) {
                [v performSelector:@selector(invalidateTimer)];
            }
            [v removeFromSuperview];
        }
        int i=0;
        for (NSMutableDictionary *dictionary in server.resDic) {
            [self cargarScrollViewConArray:dictionary enPos:i];
            i++;
        }
        i=0;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        peticion=0;
        return;
    }
    else if (peticion==2) {
        coinSpinner.alpha=0;
        userCoins.alpha=1;
        [coinSpinner stopAnimating];
        user.coins=[[server.resDic objectForKey:@"Balance"]doubleValue];
        [self userInfo];
        if (descontar==1000) {
            [self getCurrentCoins:user.coins AndSubstract:1000];
        }
        else if (descontar==500) {
            [self getCurrentCoins:user.coins AndSubstract:500];
        }
        else if (descontar==125) {
            [self getCurrentCoins:user.coins AndSubstract:125];
        }
        descontar=0;
        peticion=0;
        return;
    }
    else if (peticion==3) {
        NSLog(@"Coins Substracted %@",server.resDic);
        user.coins=monedasTemporales;
        [self userInfo];
        descontar=0;
        monedasTemporales=0;
        peticion=0;
        return;
    }
    else if (peticion==4) {
        NSLog(@"Coins added %@",server.resDic);
        user.coins+=monedasTemporales;
        
        [self userInfo];
        descontar=0;
        monedasTemporales=0;
        peticion=0;
        return;
    }
}
-(void)receivedDataFromServerWithError:(id)sender{
    NSLog(@"Error");
    monedasTemporales=0;
    NSArray *viewsToRemove = [scrollView subviews];
    for (BidView *v in viewsToRemove) [v removeFromSuperview];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)receivedFromCoinSubClass:(NSDictionary*)params{
    coinSpinner.alpha=0;
    userCoins.alpha=1;
    [coinSpinner stopAnimating];
    user.coins= [[params objectForKey:@"Balance"]doubleValue];
    [self userInfo];
}
#pragma mark - bid hud external call
-(void)bidHudOn{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Placing Bid";
}
-(void)bidHudOffOK{
    hud.labelText = NSLocalizedString(@"Success!",nil);
    hud.detailsLabelText = NSLocalizedString(@"your bid was placed.",nil);
	hud.mode = MBProgressHUDModeCustomView;
    [self performSelector:@selector(bidHudHide) withObject:nil afterDelay:1.5];
}
-(void)bidHudOffError{
    hud.labelText = NSLocalizedString(@"Error",nil);
    hud.detailsLabelText = NSLocalizedString(@"Bid not placed",nil);
	hud.mode = MBProgressHUDModeCustomView;
    [self performSelector:@selector(bidHudHide) withObject:nil afterDelay:1.5];
}
-(void)bidHudHide{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if([touch view] == userImage||[touch view] == userName){
        NSLog(@"Down");
    }
}
-(void) ClickEventOnImage:(id) sender{
    
    [self showProfile];
}
-(void) ClickEventOnCoins:(id) sender{
    coinSpinner.alpha=1;
    userCoins.alpha=0;
    [self.view bringSubviewToFront:coinSpinner];
    [coinSpinner startAnimating];
    //[self getUserCoins];
    [coin getCoinsWithUserId:user.ID];
}
-(void)showProfile{
    NSLog(@"Up");
    [profileView updateUserInfo];
    [self.view bringSubviewToFront:profileView];
    [profileView setViewAlphaToOne];
}


@end
