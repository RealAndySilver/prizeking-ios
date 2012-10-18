//
//  FirstViewController.m
//  PrizeKing
//
//  Created by Andres Abril on 10/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController
@synthesize user;
static int bubbleWidth=100;
static int bubbleHeight=87;
#pragma mark- life cycle
-(void)viewDidLoad{
    [super viewDidLoad];

    btnArray =[[NSMutableArray alloc]init];
    buyView=[[BuyCoinsView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
    [buyView bgInitWithVC:self];
    profileView=[[ProfileView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
    [profileView bgInitWithVC:self andUser:user];
    notiView=[[NotificationThanks alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
    notiView.alpha=0;
    scrollView=[[UIScrollView alloc]init];
    scrollView.frame=CGRectMake(0, self.view.frame.size.width/2+25, self.view.frame.size.height, 100);
    //[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(prueba) userInfo:nil repeats:YES];
    [self.view addSubview:scrollView];
    [self.view addSubview:buyView];
    [self.view addSubview:profileView];
    [self.view addSubview:notiView];
    coinSpinner=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    coinSpinner.frame=CGRectMake(userCoins.frame.origin.x+10, userCoins.frame.origin.y+5, 10, 10);
    coinSpinner.alpha=0;
    [self.view addSubview:coinSpinner];
    [TapjoyConnect setUserID:user.ID];
    peticion=0;
    monedasTemporales=0;
    server=[[ServerCommunicator alloc]init];
    server.caller = self;
    coin=[[CoinCaller alloc]init];
    coin.caller=self;
    //[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(notiAlpha) userInfo:nil repeats:NO];
    [self crearBotones];
    bubbleImageView=[[UIImageView alloc]init];
    bubbleImageView.center=CGPointMake(self.view.frame.size.height/2+75, self.view.frame.size.width/2-55);
    bubbleImageView.image=[UIImage imageNamed:@"bubble.png"];
    [self.view addSubview:bubbleImageView];
    [userImage setUserInteractionEnabled:YES];
    [userName setUserInteractionEnabled:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(remoteNotificationAppeared:) name:@"remoteNotification" object:nil];

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
    
    soundObject=[[SoundController alloc ]init];
    NSThread *bThread=[[NSThread alloc]initWithTarget:soundObject selector:@selector(playMainBGMusic) object:nil];
    [bThread start];
    [self performSelector:@selector(bubblePopIn) withObject:nil afterDelay:3];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self
                                           selector:@selector(restore:) userInfo:nil repeats:YES];
}
-(void)notiAlpha{
    [self.view bringSubviewToFront:notiView];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    notiView.alpha=1;
    [UIView commitAnimations];
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"user friend list count %i",user.friendsList.count);
    file = [[FileSaver alloc]init];
    //[file setCoinsQuantity:200000];
    //user=[[User alloc]user image:userimg andCoins:[file getCoinsQuantity]];
    [self userInfo];
    [self ClickEventOnCoins:nil];
}

#pragma mark- rotation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || 
    (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark- button creation
-(void)crearBotones{
    //Vacía el arreglo de botones
    [btnArray removeAllObjects];
    
    //Boton de BidNow
    UIButton *bidNowBtn=[[UIButton alloc]init];
    //[bidNowBtn setTitle:@"Bid Now" forState:UIControlStateNormal];
    [bidNowBtn setTag:0];
    UIImage *bidImage=[UIImage imageNamed:@"bidNow.png"];
    [bidNowBtn setBackgroundImage:bidImage forState:UIControlStateNormal];
    [bidNowBtn addTarget:self 
                  action:@selector(goToViewWith:)
        forControlEvents:UIControlEventTouchUpInside];

    
    //Iguala a la función que retorna botón random
    UIButton *randResult=[self randBtn];
    
    //Free Coins
    UIButton *freeCoinsBtn=[[UIButton alloc]init];
    //[faceBookTeamBtn setTitle:@"Facebook Team" forState:UIControlStateNormal];
    [freeCoinsBtn setTag:3];
    UIImage *freeCoinsImage=[UIImage imageNamed:@"freeCoins.png"];
    [freeCoinsBtn setBackgroundImage:freeCoinsImage forState:UIControlStateNormal];
    [freeCoinsBtn addTarget:self 
                  action:@selector(goToViewWith:)
        forControlEvents:UIControlEventTouchUpInside];
    
    //Lead a team button
    UIButton *faceBookTeamBtn=[[UIButton alloc]init];
    //[faceBookTeamBtn setTitle:@"Facebook Team" forState:UIControlStateNormal];
    [faceBookTeamBtn setTag:4];
    UIImage *faceBookImage=[UIImage imageNamed:@"leadBid.png"];
    [faceBookTeamBtn setBackgroundImage:faceBookImage forState:UIControlStateNormal];
    [faceBookTeamBtn addTarget:self 
                  action:@selector(goToViewWith:)
        forControlEvents:UIControlEventTouchUpInside];
    
    [btnArray addObject:bidNowBtn];
    [btnArray addObject:randResult];
    [btnArray addObject:freeCoinsBtn];
    [btnArray addObject:faceBookTeamBtn];
    [self cargarScrollViewConArray:btnArray];
    
}

#pragma mark- scrollview dinamic size set and reload
-(void)cargarScrollViewConArray:(NSMutableArray*)arrayDeBotones{
    
    if (arrayDeBotones.count<4) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
        scrollView.contentSize=CGSizeMake(self.view.frame.size.width+1, 100);
        [UIView commitAnimations];        
    }
    else {
        if (135*arrayDeBotones.count<self.view.frame.size.width) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.3];
            scrollView.contentSize=CGSizeMake(self.view.frame.size.height+1, 100);
            [UIView commitAnimations];
        }
        else {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.3];
            scrollView.contentSize=CGSizeMake((135*arrayDeBotones.count)+1, 100);
            [UIView commitAnimations];
        }
    }
    scrollView.showsHorizontalScrollIndicator=NO;
    for (int i=0; i<arrayDeBotones.count; i++) {
        UIButton *tempButton=[arrayDeBotones objectAtIndex:i];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
        tempButton.frame=CGRectMake(130*i+30,10,118,81);
        [UIView commitAnimations];
        [scrollView addSubview:tempButton];
    }
}

#pragma mark- erase scroll button
-(void)borrar:(UIButton*)sender{
    NSThread *bThread=[[NSThread alloc]initWithTarget:soundObject selector:@selector(playAirSound) object:nil];
    [bThread start];
    //scrollView=nil;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    [[btnArray objectAtIndex:1]setAlpha:0];
    [UIView commitAnimations];
    [btnArray removeObjectAtIndex:1];
    [self cargarScrollViewConArray:btnArray];
}
#pragma mark- bubble animation
-(void)bubblePopIn{
    //scrollView=nil;
    bubbleImageView.center=CGPointMake(self.view.frame.size.width/2+75, self.view.frame.size.height/2-55);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.2];
    bubbleImageView.frame=CGRectMake(self.view.frame.size.width/2+75-(bubbleWidth/2), self.view.frame.size.height/2-55-(bubbleHeight/2), bubbleWidth, bubbleHeight);
    //bubbleImageView.center=CGPointMake(self.view.frame.size.width/2+75, self.view.frame.size.height/2-55);
    [UIView commitAnimations];
    int randomNumb=(arc4random()%4)+3;
    [self performSelector:@selector(bubblePopOut) withObject:nil afterDelay:randomNumb];
}
-(void)bubblePopOut{
    //scrollView=nil;
    bubbleImageView.center=CGPointMake(self.view.frame.size.width/2+75, self.view.frame.size.height/2-55);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.2];
    bubbleImageView.frame=CGRectMake(self.view.frame.size.width/2+75, self.view.frame.size.height/2-55, 0, 0);
    bubbleImageView.center=CGPointMake(self.view.frame.size.width/2+75, self.view.frame.size.height/2-55);
    [UIView commitAnimations];
    int randomNumb=(arc4random()%15)+3;
    [self performSelector:@selector(bubblePopIn) withObject:nil afterDelay:randomNumb];
}
#pragma mark- random button generation
-(UIButton*)randBtn{
    //int randomNumb=arc4random()%10;
    CGRect buttonFrame=CGRectMake(120, 10, 0, 0);
    CGRect closeBtnFrame=CGRectMake(83, -5, 40, 40);
         UIButton *buyCoinsBtn=[[UIButton alloc]init];
        [buyCoinsBtn setTag:1];
        buyCoinsBtn.frame=buttonFrame;
        UIImage *buyCoinsImage=[UIImage imageNamed:@"wantMore.png"];
        [buyCoinsBtn setBackgroundImage:buyCoinsImage forState:UIControlStateNormal];
        [buyCoinsBtn addTarget:self 
                            action:@selector(goToViewWith:)
                  forControlEvents:UIControlEventTouchUpInside];
        UIButton *closeBuyCoinsBtn=[[UIButton alloc]init];
        closeBuyCoinsBtn.frame=closeBtnFrame;
        UIImage *closeImage=[UIImage imageNamed:@"closeBtn.png"];
        [closeBuyCoinsBtn setBackgroundImage:closeImage forState:UIControlStateNormal];
        [closeBuyCoinsBtn setTag:11];
        [closeBuyCoinsBtn addTarget:self 
                             action:@selector(borrar:)
                   forControlEvents:UIControlEventTouchUpInside];
        [buyCoinsBtn addSubview:closeBuyCoinsBtn];
        return buyCoinsBtn;
}

#pragma mark- user load
-(void)userInfo{
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

#pragma mark- button actions
-(void)restore:(id)sender{
    NSArray *array=[[NSArray alloc]initWithArray:btnArray];
    int random=arc4random()%5;
    if (random==3) {
        if (array.count<4){
            [btnArray removeAllObjects];
            for (int i=0; i<array.count+1; i++) {
                if (i==0) {
                    [btnArray addObject:[array objectAtIndex:i]];
                }
                else if (i==1) {
                    [btnArray addObject:[self randBtn]];
                }
                else if (i>1) {
                    [btnArray addObject:[array objectAtIndex:i-1]];
                }
            }
            [self cargarScrollViewConArray:btnArray];
        }
    }
}
-(IBAction)goToViewFromStoryBoardTrigger:(UIButton*)sender{
    [self goToViewWith:sender];
}
-(IBAction)logout:(id)sender{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"loguedout" object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)goToViewWith:(UIButton*)sender{
    NSThread *bThread=[[NSThread alloc]initWithTarget:soundObject selector:@selector(playClickSound) object:nil];
    [bThread start];
    if (sender.tag==0) {
        [self.navigationController.view.layer addAnimation:[NavAnimations navAlphaAnimation] forKey:nil];
        BidViewController *bVC=[[BidViewController alloc]init];
        bVC=[self.storyboard instantiateViewControllerWithIdentifier:@"BidViewController"];
        bVC.user=user;
        [self.navigationController pushViewController:bVC animated:NO];
    }
    else if (sender.tag==1) {
        //NSLog(@"Esta sección abre la tienda de monedas");
        [self.view bringSubviewToFront:buyView];
        [self getUserCoins];
        [buyView setViewAlphaToOne];
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
        //[TapjoyConnect showOffersWithViewController:self withInternalNavBar:YES];
        //[TapjoyConnect showOffersWithViewController:self];
        //[TapjoyConnect showOffers];


    }
    else if (sender.tag==4) {
        [self.navigationController.view.layer addAnimation:[NavAnimations navAlphaAnimation] forKey:nil];
        FacebookMainVC *ftVC=[[FacebookMainVC alloc]init];
        ftVC=[self.storyboard instantiateViewControllerWithIdentifier:@"FacebookMain"];
        ftVC.user=user;
        [self.navigationController pushViewController:ftVC animated:NO];
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
#pragma mark- prueba timer
-(void)prueba{
    NSArray *array=[[NSArray alloc]initWithArray:btnArray];
    [btnArray removeAllObjects];
    for (int i=0; i<array.count+1; i++) {
        if (i==0) {
            [btnArray addObject:[array objectAtIndex:i]];
        }
        else if (i==1) {
            [btnArray addObject:[self randBtn]];
        }
        else if (i>1) {
            [btnArray addObject:[array objectAtIndex:i-1]];
        }
    }
    [self cargarScrollViewConArray:btnArray];
}

-(void)getCurrentCoinsAndAdd:(NSString*)coinsToAdd{
    monedasTemporales=[coinsToAdd doubleValue];
    [self getUserCoinsAndAdd];
}
#pragma mark - server requests
-(void)getUserCoinsAndAdd{
    peticion=1;
    NSLog(@"getUserCoinsAndAdd %.0f",monedasTemporales);
    NSString *date= [self dateString];
    NSString *parameters=[NSString stringWithFormat:@"%.0f/%@/%@/%@/3/%@",monedasTemporales,user.ID,@"0",@"0",date];
    [server callServerWithMethod:@"ChargeCoinsUser" andParameter:parameters];
}
-(void)getUserCoins{
    peticion=2;
    [server callServerWithMethod:@"GetUserCoins" andParameter:user.ID];
}
-(void)addFreeCoins:(double)coins{
    peticion=3;
    NSString *date=[self dateString];
    NSString *parameters=[NSString stringWithFormat:@"%.0f/%@/%@/%@/1/%@",coins,user.ID,@"0",@"0",date];
    [server callServerWithMethod:@"ChargeCoinsUser" andParameter:parameters];
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
#pragma mark - server response

-(void)receivedDataFromServer:(id)sender{
    if (peticion==1) {
        //avisar que debemos manejar alguna respuesta, está retornando vacío
        peticion=0;
        server=sender;
        user.coins+=monedasTemporales;
        [self userInfo];
        monedasTemporales=0;
        return;
    }
    else if(peticion==2){
        peticion=0;
        server=sender;
        coinSpinner.alpha=0;
        userCoins.alpha=1;
        [coinSpinner stopAnimating];
        user.coins= [[server.resDic objectForKey:@"Balance"]doubleValue];
        [self userInfo];
        NSLog(@"GetCoins %@",server.resDic);
    }
    else if(peticion==3){
        if ([[server.resDic objectForKey:@"Response"]intValue]==1) {
            peticion=0;
            server=sender;
            /*coinSpinner.alpha=0;
            userCoins.alpha=1;
            [coinSpinner stopAnimating];
            user.coins+= monedasTemporales;
            [self userInfo];
            NSLog(@"GetCoins %@",server.resDic);
            monedasTemporales=0;*/
            [self getUserCoins];
        }
        else{
            monedasTemporales=0;
        }
    }
}
-(void)receivedDataFromServerWithError:(id)sender{
    if (peticion==1) {
        //avisar que debemos manejar alguna respuesta, está retornando vacío
        peticion=0;
        server=sender;
        
        return;
    }
    else if(peticion==2){
        peticion=0;
        server=sender;
        coinSpinner.alpha=0;
        userCoins.alpha=1;
        [coinSpinner stopAnimating];
        [self userInfo];
    }
}
-(void)receivedFromCoinSubClass:(NSDictionary*)params{
    coinSpinner.alpha=0;
    userCoins.alpha=1;
    [coinSpinner stopAnimating];
    user.coins= [[params objectForKey:@"Balance"]doubleValue];
    [self userInfo];
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
#pragma mark - remote notification
-(void)remoteNotificationAppeared:(NSNotification*)notification{
    NSDictionary *payload=notification.object;
    NSString *message=[[payload objectForKey:@"aps"]objectForKey:@"alert"];
    message=[message stringByReplacingOccurrencesOfString:@"{name}" withString:user.firstName];
    UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"Notification" message:@"Hey!, someone else made a bid.. don´t let them take your prize. \nBid Now!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [av show];
    if ([message rangeOfString:@"500"].location != NSNotFound) {
        NSLog(@"Won 500 coins");
        [self addFreeCoins:500];
    }
}
@end
