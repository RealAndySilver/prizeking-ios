//
//  BidView.m
//  PrizeKing
//
//  Created by Andres Abril on 16/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BidView.h"

@implementation BidView
@synthesize timerLabel;
@synthesize segundos,minutos,horas;
@synthesize continuaElTimer;
@synthesize auctionID;
@synthesize currentBVC;
@synthesize thisTag;
@synthesize user;
@synthesize refresher;

///CreateBID/{auctionId}/{amount}/{user}

-(void)initBidWithDictionary:(NSMutableDictionary*)dic andContext:(BidViewController*)bVC{
    currentBVC=bVC;
    server=[[ServerCommunicator alloc]init];
    server.caller = self;
    peticion=0;
    //[self startRefresher];
    
    NSMutableDictionary *bidDic=dic;
    active=[[bidDic objectForKey:@"Active"]boolValue];
    int auctionCategory=[[bidDic objectForKey:@"AuctionCategory"]intValue];
    auctionID=[bidDic objectForKey:@"AuctionID"];
    NSString *currentWinnerName=[bidDic objectForKey:@"CurrentWinnerName"];
    NSString *currentWinnerImageUrl=[bidDic objectForKey:@"CurrentWinnerImageUrl"];
    //NSNumber *currentWinnerBidsString=[bidDic objectForKey:@"WinnerBids"];
    NSString *prizeName=[bidDic objectForKey:@"PrizeName"];
    description=[[UITextView alloc]init];
    description.text=[bidDic objectForKey:@"Details"];
    [description setEditable:NO];
    description.alpha=0;
    int contador=[[bidDic objectForKey:@"Timer"]intValue];
    contador=contador*1;
    //Whole bid placeholder
    CGRect placeHolderFrame=CGRectMake(0, 0, 129, 235);
    UIImageView *bidPlaceHolder=[[UIImageView alloc]initWithFrame:placeHolderFrame];
    [bidPlaceHolder setUserInteractionEnabled:YES];
    bidPlaceHolder.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame=CGRectMake(15,118, 10, 10);
    spinner.alpha=0;
    [bidPlaceHolder addSubview:spinner];
    
    //Footer label
    UILabel *footerLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 214, 110, 12)];
    footerLabel.textColor=[UIColor brownColor];
    footerLabel.font = [UIFont fontWithName:@"Helvetica" size: 12.0];
    footerLabel.textAlignment=UITextAlignmentCenter;
    //footerLabel.shadowColor = [UIColor grayColor];
	//footerLabel.shadowOffset = CGSizeMake(1,1);
    footerLabel.backgroundColor=[UIColor clearColor];
    
    //Prize image and label draw
    prizeImageView =[[UIImageView alloc]initWithFrame:CGRectMake(25, 30, 80, 80)];
    //prizeImageView.layer.cornerRadius = 10.0;
    prizeImageView.layer.masksToBounds = YES;
    prizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    description.frame=CGRectMake(0, 0, prizeImageView.frame.size.width, prizeImageView.frame.size.height);
    UITapGestureRecognizer *imageTapRecognizer = [[UITapGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(ClickEventOnImage:)];
    [imageTapRecognizer setNumberOfTouchesRequired:1];
    [imageTapRecognizer setDelegate:self];
    prizeImageView.userInteractionEnabled = YES;
    [description addGestureRecognizer:imageTapRecognizer];
    [prizeImageView addGestureRecognizer:imageTapRecognizer];
    
    [prizeImageView addSubview:description];
    
    [self performSelectorInBackground:@selector(backGroundThreadForImageWithDictionary:) withObject:bidDic];
    
    //[prizeImageView.layer setBorderColor: [[UIColor grayColor] CGColor]];
    //[prizeImageView.layer setBorderWidth: 1.5];
    
    prizeNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(25, 110, 80, 22)];
    prizeNameLabel.textAlignment=UITextAlignmentCenter;
    prizeNameLabel.backgroundColor=[UIColor clearColor];
    UIFont *font2=[UIFont fontWithName:@"Verdana-Bold" size:8.0];
    prizeNameLabel.font = font2;
    prizeNameLabel.textColor=[UIColor blackColor];
    [prizeNameLabel setNumberOfLines:2];
    //[self prize];
    prizeNameLabel.text=prizeName;
    [bidPlaceHolder addSubview:prizeImageView];
    [bidPlaceHolder addSubview:prizeNameLabel];
    
    //Current Winer Image and Label draw
    int marginTop=150;
    currentWinnerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, marginTop, 15, 15)];
    currentWinnerImageView.layer.cornerRadius = 3.0;
    currentWinnerImageView.layer.masksToBounds = YES;
    currentWinnerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [currentWinnerImageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [currentWinnerImageView.layer setBorderWidth: 0.5];
    
    currentWinnerLabel = [[UILabel alloc]initWithFrame:CGRectMake(28, marginTop+2, 85, 12)];
    currentWinnerLabel.textAlignment=UITextAlignmentCenter;
    currentWinnerLabel.backgroundColor=[UIColor clearColor];
    currentWinnerLabel.font = [UIFont fontWithName:@"Helvetica" size: 8.0];
    currentWinnerLabel.textColor=[UIColor blackColor];
    currentWinnerBids = [[UILabel alloc]initWithFrame:CGRectMake(28, marginTop+8, 85, 12)];
    currentWinnerBids.textAlignment=UITextAlignmentCenter;
    currentWinnerBids.backgroundColor=[UIColor clearColor];
    currentWinnerBids.font = [UIFont fontWithName:@"Helvetica" size: 8.0];
    currentWinnerBids.textColor=[UIColor blackColor];
    //currentWinnerBids.text=[NSString stringWithFormat:@"Bids made %@",currentWinnerBidsString];
    currentWinnerLabel.text=[self currentWinnerNameControl:currentWinnerName];
    //currentWinnerImageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[IAmCoder decodeURL:currentWinnerImageUrl]]]];
    NSLog(@"current winner image url %@",currentWinnerImageUrl);
    currentWinnerImageView.image=[CacheImage getCachedImage:[IAmCoder decodeURL:currentWinnerImageUrl] noThread:nil];
    if (currentWinnerImageView.image==nil) {
        currentWinnerImageView.image=[UIImage imageNamed:@"kingHead.png"];
    }
    [bidPlaceHolder addSubview:currentWinnerImageView];
    [bidPlaceHolder addSubview:currentWinnerLabel];
    [bidPlaceHolder addSubview:currentWinnerBids];
    
    
    //Timer label
    timerLabel=[[UILabel alloc]initWithFrame:CGRectMake(35, 4, 80, 13)];
    timerLabel.textColor=[UIColor brownColor];
    timerLabel.font = [UIFont fontWithName:@"Helvetica" size: 12.0];
    timerLabel.textAlignment=UITextAlignmentCenter;
    timerLabel.backgroundColor=[UIColor clearColor];
    
    CGRect buttonFrame=CGRectMake(10, 179, 108, 34);
    CustomButton *bidButton=[[CustomButton alloc]init];
    //[buyCoinsBtn setTitle:@"Buy Coins" forState:UIControlStateNormal];
    
    bidButton.frame=buttonFrame;
    UIImage *bidButtonImage=[UIImage imageNamed:@"bidder.png"];
    [bidButton setBackgroundImage:bidButtonImage forState:UIControlStateNormal];
    [bidButton addTarget:self
                  action:@selector(placeBid:)
        forControlEvents:UIControlEventTouchUpInside];
    [bidPlaceHolder addSubview:bidButton];
    
    //Big Number Label
    UIFont *bigFont=[UIFont fontWithName:@"Helvetica" size:60.0];
    UIFont *superBigFont=[UIFont fontWithName:@"Helvetica" size:100.0];
    bigNumberContainer=[[UILabel alloc]init];
    bigNumberContainer.font=superBigFont;
    bigNumberContainer.frame=CGRectMake(0, 0, 100, 100);
    bigNumberContainer.center=CGPointMake(prizeImageView.frame.size.width/2, prizeImageView.frame.size.height/2);
    bigNumberContainer.text=@"O";
    bigNumberContainer.backgroundColor=[UIColor clearColor];
    bigNumberContainer.textAlignment=UITextAlignmentCenter;
    bigNumberContainer.textColor=[UIColor redColor];
    bigNumberContainer.alpha=0;
    [prizeImageView addSubview:bigNumberContainer];
    
    bigNumberLabel=[[UILabel alloc]init];
    bigNumberLabel.font=bigFont;
    bigNumberLabel.frame=CGRectMake(0, 0, 90, 90);
    bigNumberLabel.center=CGPointMake(bigNumberContainer.frame.size.width/2, bigNumberContainer.frame.size.height/2);
    bigNumberLabel.text=@"5";
    bigNumberLabel.backgroundColor=[UIColor clearColor];
    bigNumberLabel.textAlignment=UITextAlignmentCenter;
    bigNumberLabel.textColor=[UIColor redColor];
    [bigNumberContainer addSubview:bigNumberLabel];
    bigNumberLabel.shadowColor = [UIColor blackColor];
	bigNumberLabel.shadowOffset = CGSizeMake(1,1);
    bigNumberContainer.shadowColor = [UIColor blackColor];
	bigNumberContainer.shadowOffset = CGSizeMake(1,1);
    
    
    
    //Auction kind set
    NSLog(@"active %i",active);
    if (auctionCategory ==1) {
        if (active) {
            thisTag=100;
            [bidButton setTag:thisTag];
            bidButton.alpha=1;
            bidPlaceHolder.image=[UIImage imageNamed:@"goldenBid.png"];
            footerLabel.text=@"1BID = 1000";
            bidPrice=@"1000";
            [self timerSetConContador:contador];
        }
        else{
            [bidButton setEnabled:NO];
            bidButton.alpha=0;
            bidPlaceHolder.image=[UIImage imageNamed:@"goldenBidBW.png"];
            footerLabel.text=@"Auction finished!";
            timerLabel.text=@"00:00:00";
            bidPrice=@"0";
            prizeImageView.image=[BlackAndWhiter turnImageToBlackAndWhite:prizeImageView.image];
        }
    }
    else if (auctionCategory ==2) {
        if (active){
            thisTag=101;
            [bidButton setTag:thisTag];
            bidButton.alpha=1;
            bidPlaceHolder.image=[UIImage imageNamed:@"silverBid.png"];
            footerLabel.text=@"1BID = 500";
            bidPrice=@"500";
            [self timerSetConContador:contador];
            
        }
        else{
            [bidButton setEnabled:NO];
            bidButton.alpha=0;
            bidPlaceHolder.image=[UIImage imageNamed:@"silverBidBW.png"];
            footerLabel.text=@"Auction finished!";
            timerLabel.text=@"00:00:00";
            bidPrice=@"0";
            prizeImageView.image=[BlackAndWhiter turnImageToBlackAndWhite:prizeImageView.image];
        }
    }
    else if (auctionCategory ==3) {
        if (active) {
            thisTag=102;
            [bidButton setTag:thisTag];
            bidButton.alpha=1;
            bidPlaceHolder.image=[UIImage imageNamed:@"bronzeBid.png"];
            footerLabel.text=@"1BID = 125";
            bidPrice=@"125";
            [self timerSetConContador:contador];
        }
        else{
            [bidButton setEnabled:NO];
            bidButton.alpha=0;
            bidPlaceHolder.image=[UIImage imageNamed:@"bronzeBidBW.png"];
            footerLabel.text=@"Auction finished!";
            bidPrice=@"0";
            timerLabel.text=@"00:00:00";
            prizeImageView.image=[BlackAndWhiter turnImageToBlackAndWhite:prizeImageView.image];
        }
    }
    
    [bidPlaceHolder addSubview:footerLabel];
    [bidPlaceHolder addSubview:timerLabel];
    [self addSubview:bidPlaceHolder];
    NSLog(@"user id %@",user.ID);
    
    //[self performSelector:@selector(callServer) withObject:nil afterDelay:5];
    label15plusFrame=CGRectMake(80, 30, 108, 34);
    label15plusFrameEnd=CGRectMake(80, 0, 108, 34);
    label15plus = [[UILabel alloc]initWithFrame:label15plusFrame];
    label15plus.backgroundColor=[UIColor clearColor];
    label15plus.text=@"+15";
    label15plus.alpha=0;
    label15plus.font = [UIFont fontWithName:@"Helvetica" size: 25.0];
    label15plus.textColor=[UIColor redColor];
    [bidPlaceHolder addSubview:label15plus];
    [self threadStartRefresher];
}
-(void)threadStartRefresher{
    NSThread *cThread=[[NSThread alloc]initWithTarget:self
                                             selector:@selector(startRefresher)
                                               object:nil];
    [cThread start];
}
-(NSString*)currentWinnerNameControl:(NSString*)currentWinnerName{
    if ([currentWinnerName isEqualToString:@""]) {
        int rand=arc4random()%3;
        switch (rand) {
            case 0:
                currentWinnerName=@"Bid Now and win!";
                break;
                
            case 1:
                currentWinnerName=@"Come on! Be the new PrizeKing";
                break;
                
            case 2:
                currentWinnerName=@"Be the next PrizeKing";
                break;
            default:
                break;
        }
        return currentWinnerName;
    }
    else{
        return currentWinnerName;
    }
}


-(void)backGroundThreadForImageWithDictionary:(NSDictionary*)bidDic{
    if ([[bidDic objectForKey:@"PrizeImageUrl"] isKindOfClass:[NSNull class]]) {
    }
    else{
        prizeImageView.image=[CacheImage getCachedImage:[bidDic objectForKey:@"PrizeImageUrl"] noThread:nil];
    }
}


-(void)placeBid:(UIButton*)sender{
    peticion=1;
    [self letsBid];
}
#pragma mark - timer set
-(void)timerSetConContador:(int)contador{
    continuaElTimer = YES;
    bThread=[[NSThread alloc]initWithTarget:self
                                   selector:@selector(secondThreadTimer)
                                     object:nil];
    [self secAndMinSetConContador:contador];
    [bThread start];
}
-(void)secAndMinSetConContador:(int)contador{
    segundos=(contador%60);
    minutos=((contador/60)%60);
    horas=(contador/(3600));
}

#pragma mark-timer
-(void)secondThreadTimer{
    
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                           selector:@selector(theTimerFormatted) userInfo:nil repeats:YES];
    
    while (continuaElTimer && [theRL runMode:NSDefaultRunLoopMode
                                  beforeDate:[NSDate distantFuture]]);
}
-(void)startRefresher{
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    refresher = [NSTimer scheduledTimerWithTimeInterval:15 target:self
                                               selector:@selector(refreshAuction) userInfo:nil repeats:YES];
    
    while (continuaElTimer && [theRL runMode:NSDefaultRunLoopMode
                                  beforeDate:[NSDate distantFuture]]);
}
-(void)theTimer{
    if (continuaElTimer) {
        if (minutos<10 && minutos>=0) {
            timerLabel.textColor=[UIColor redColor];
        }
        segundos--;
        if (segundos<0) {
            minutos--;
            segundos=59;
            timerLabel.text=[NSString stringWithFormat:@"%i:%i",minutos,segundos];
        }
        else if (segundos<10) {
            timerLabel.text=[NSString stringWithFormat:@"%i:0%i",minutos,segundos];
        }
        else {
            timerLabel.text=[NSString stringWithFormat:@"%i:%i",minutos,segundos];
        }
        if (minutos==0 && segundos<10) {
            bigNumberContainer.alpha=1;
            bigNumberLabel.text=[NSString stringWithFormat:@"%i",segundos];
            if (segundos<1) {
                segundos=1;
            }
        }
        else {
            bigNumberContainer.alpha=0;
        }
    }
    else {
        if ([timer isValid]) {
            [bThread cancel];
            [timer invalidate];
            NSLog(@"El timer terminó");
        }
    }
}
-(void)theTimerFormatted{
    if (continuaElTimer) {
        if (horas ==0 && minutos==0 && segundos>=0) {timerLabel.textColor=[UIColor redColor];}
        else{timerLabel.textColor=[UIColor brownColor];}
        segundos--;
        if (segundos<0){
            segundos=59;
            minutos--;
            if (minutos<0){
                minutos=59;
                horas--;
                if (horas<0){horas=0;}
            }
        }
        timerLabel.text=[NSString stringWithFormat:@"%.2i:%.2i:%.2i",horas,minutos,segundos];
        if (horas ==0 && minutos==0 && segundos<10) {
            bigNumberContainer.alpha=1;
            bigNumberLabel.text=[NSString stringWithFormat:@"%i",segundos];
            if (segundos<1) {
                segundos=1;
            }
        }
        else {
            bigNumberContainer.alpha=0;
        }
    }
    else {
        if ([timer isValid]) {
            [bThread cancel];
            [timer invalidate];
            NSLog(@"El timer terminó");
        }
    }
}

#pragma mark - view creators and updaters

-(void)lightCallWithDic:(NSDictionary*)dictionary{
    NSDictionary *bidDic=dictionary;
    //auctionID=[bidDic objectForKey:@"AuctionID"];
    NSString *currentWinnerName=[bidDic objectForKey:@"CurrentWinnerName"];
    NSString *currentWinnerImageUrl=[bidDic objectForKey:@"CurrentWinnerImageUrl"];
    //NSNumber *currentWinnerBidsString=[bidDic objectForKey:@"WinnerBids"];
    
    int contador=[[bidDic objectForKey:@"Timer"]intValue];
    active=[[bidDic objectForKey:@"Active"]boolValue];
    contador=contador*1;
    currentWinnerLabel.text=[self currentWinnerNameControl:currentWinnerName];
    //currentWinnerBids.text=[NSString stringWithFormat:@"Bids made %@",currentWinnerBidsString];
    
    currentWinnerImageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[IAmCoder decodeURL:currentWinnerImageUrl]]]];
    if (currentWinnerImageView.image==nil) {
        currentWinnerImageView.image=[UIImage imageNamed:@"kingHead.png"];
    }
    [self secAndMinSetConContador:contador];
}

-(void)invalidateTimer{
    if ([refresher isValid]) {
        [refresher invalidate];
    }
}
-(void)refreshAuction{
    if (active) {
        if (peticion==0) {
            [self bringLight];
            //[self performSelectorInBackground:@selector(bringLight) withObject:nil];
            spinner.alpha=1;
            [spinner startAnimating];
            NSLog(@"Refreshing");
        }
    }
    else{
        [self invalidateTimer];
    }
    
}
#pragma mark - server request
-(void)letsBid{
    //[server callServerWithMethod:@"GetActiveAuctionsLight" andParameter:auctionID];
    NSString *parameters=[NSString stringWithFormat:@"%@/%@/%@",auctionID,bidPrice,user.ID];
    NSLog(@"parameters %@",parameters);
    if (user.coins>=[bidPrice doubleValue]) {
        NSLog(@"coins vs coins %.0f vs bidprice %.0f",user.coins,[bidPrice doubleValue]);
        [server callServerWithMethod:@"CreateBid" andParameter:parameters];
        [currentBVC bidHudOn];
    }
    else{
        [currentBVC buyViewAppear];
    }
    
}
-(void)bringLight{
    peticion=2;
    [server callServerWithMethod:@"GetActiveAuctionsLight" andParameter:auctionID];
}
#pragma mark - server response
-(void)receivedDataFromServerWithError:(id)sender{
    if (peticion==2) {
        [spinner stopAnimating];
        spinner.alpha=0;
        peticion=0;
    }
    if (peticion==1) {
        [currentBVC bidHudOffError];
    }
}
-(void)receivedDataFromServer:(id)sender{
    //preguntar a daniel si el puede hacer la comprobacion para no hacer doble llamado al server
    //que implemente el control para que el ganador no pueda volver a hacer bid si va ganando
    
    server=sender;
    NSMutableDictionary *res=server.resDic;
    if (peticion==1) {
        NSLog(@"server bidlight response %@",res);
        if ([[res objectForKey:@"Auction"]isKindOfClass:[NSNull class]]) {
            res = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"0",@"result",nil];
            [currentBVC bidHudOffError];
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"Attention" message:@"You are the current winner of this auction and can't place bids while being the leader." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [av show];
        }
        else{
            [self lightCallWithDic:[res objectForKey:@"Auction"]];
            if ([[res objectForKey:@"Successful"]intValue]==1) {
                user.coins=[[res objectForKey:@"Balance"]doubleValue];
                [currentBVC userInfo];
                [self animateExtraTime:label15plusFrame finish:label15plusFrameEnd];
                [currentBVC bidHudOffOK];
            }
            else{
                user.coins=[[res objectForKey:@"Balance"]doubleValue];
                [currentBVC userInfo];
                [currentBVC bidHudOffError];
            }
        }
        peticion=0;
    }
    else if(peticion==2){
        //[self lightCallWithDic:res];
        [self performSelectorInBackground:@selector(lightCallWithDic:) withObject:res];
        [spinner stopAnimating];
        spinner.alpha=0;
        //NSLog(@"Light auction res %@",res);
        peticion=0;
    }
}
#pragma mark gesture recognizer action
-(void)ClickEventOnImage:(id)sender{
    NSLog(@"toqué la imagen");
    if (description.alpha==0) {
        [self textViewAlpha:1];
    }
    else{
        [self textViewAlpha:0];
    }
}
#pragma mark - animations
-(void)textViewAlpha:(int)alpha{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    description.alpha=alpha;
    [UIView commitAnimations];
}
-(void)animateExtraTime:(CGRect)start finish:(CGRect)finish{
    label15plus.alpha=1;
    label15plus.frame=start;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:3];
    label15plus.alpha=0;
    label15plus.frame=finish;
    [UIView commitAnimations];
}
@end
