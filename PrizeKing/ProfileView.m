//
//  ProfileView.m
//  PrizeKing
//
//  Created by Andrés Abril on 31/07/12.
//
//

#import "ProfileView.h"

@implementation ProfileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // [self bgInit];
    }
    return self;
}
-(void)bgInitWithVC:(UIViewController*)VC andUser:(User*)user{
    contextVC=VC;
    profileUser=user;
    server=[[ServerCommunicator alloc]init];
    server.caller = self;
    NSLog(@"Le VC %@",contextVC);
    CGRect viewFrame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIView *elView=[[UIView alloc]initWithFrame:viewFrame];
    [elView setClipsToBounds:YES];
    elView.backgroundColor=[UIColor blackColor];
    elView.alpha=0.6;
    UIImage *bgImage=[UIImage imageNamed:@"coinsBG.png"];
    bgImageView=[[UIImageView alloc]initWithImage:bgImage];
    [bgImageView setUserInteractionEnabled:YES];
    CGRect imageViewRect=CGRectMake(0, 0, 362, 284);
    bgImageView.frame=imageViewRect;
    //bgImageView.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    bgImageView.center=CGPointMake(self.frame.size.width/2, 1000);
    [bgImageView setClipsToBounds:YES];
    
    UIImage *getCoinsImage=[UIImage imageNamed:@"getCoinsBanner.png"];
    UIImageView *getCoinsBanner=[[UIImageView alloc]initWithImage:getCoinsImage];
    CGRect getCoinsBannerRect=CGRectMake(0, 0, 238, 39);
    getCoinsBanner.frame=getCoinsBannerRect;
    getCoinsBanner.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2-92);
    [self addSubview:elView];
    [self addSubview:bgImageView];
    //[self addSubview:getCoinsBanner];
    [self buttonInitWithUser:user];
    numberFormatter=[[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterScientificStyle];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];

    self.alpha=0;
}
-(void)buttonInitWithUser:(User*)user{
    int posY1=30;
    UIButton *coins1=[[UIButton alloc]init];
    coins1.frame=CGRectMake(25, posY1, 77, 77);
    [coins1 setTag:50];
    UITapGestureRecognizer *imageTapRecognizer = [[UITapGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(ClickEventOnImage:)];
    [imageTapRecognizer setNumberOfTouchesRequired:1];
    [imageTapRecognizer setDelegate:self];
    profileImageView=[[UIImageView alloc]initWithImage:profileUser.image];
    profileImageView.frame=CGRectMake(35, posY1, 80, 80);
    profileImageView.layer.cornerRadius = 5.0;
    profileImageView.layer.masksToBounds = YES;
    [profileImageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [profileImageView.layer setBorderWidth: 5.0];
    profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    profileImageView.userInteractionEnabled = YES;
    [profileImageView addGestureRecognizer:imageTapRecognizer];
    [bgImageView addSubview:profileImageView];
    
    UIView *editLayer=[[UIView alloc]init];
    editLayer.frame=CGRectMake(0, 0, profileImageView.frame.size.width, profileImageView.frame.size.height/4);
    editLayer.center=CGPointMake(profileImageView.frame.size.width/2, profileImageView.frame.size.height-editLayer.frame.size.height/2);
    editLayer.backgroundColor=[UIColor blackColor];
    editLayer.alpha=0.5;
    [profileImageView addSubview:editLayer];
    
    UILabel *editLabel=[[UILabel alloc]init];
    editLabel.frame=CGRectMake(0, 0, editLayer.frame.size.width, editLayer.frame.size.height);
    editLabel.text=@"Edit Avatar";
    UIFont *leFont=[UIFont boldSystemFontOfSize:10];
    editLabel.font=leFont;
    editLabel.backgroundColor=[UIColor clearColor];
    editLabel.textColor=[UIColor whiteColor];
    editLabel.textAlignment=UITextAlignmentCenter;
    [editLayer addSubview:editLabel];
    
    profileNameLabel=[[UILabel alloc]init];
    profileNameLabel.frame=CGRectMake(125, posY1, 190, 30);
    profileNameLabel.numberOfLines=2;
    UIFont *font = [UIFont boldSystemFontOfSize:23];
    profileNameLabel.font=font;
    profileNameLabel.backgroundColor=[UIColor clearColor];
    profileNameLabel.textColor=[UIColor whiteColor];
    profileNameLabel.textAlignment=UITextAlignmentLeft;
    [bgImageView addSubview:profileNameLabel];
    
    mailLabel=[[UILabel alloc]init];
    mailLabel.frame=CGRectMake(125, posY1+30, 190, 30);
    mailLabel.numberOfLines=2;
    UIFont *mailFont=[UIFont boldSystemFontOfSize:10];
    mailLabel.font=mailFont;
    mailLabel.backgroundColor=[UIColor clearColor];
    mailLabel.textColor=[UIColor whiteColor];
    mailLabel.textAlignment=UITextAlignmentLeft;
    [bgImageView addSubview:mailLabel];
    
    UIView *line=[[UIView alloc]init];
    line.frame=CGRectMake(35, 50, bgImageView.frame.size.width-60, 1);
    line.center=CGPointMake(bgImageView.frame.size.width/2, posY1+profileImageView.frame.size.height+10);
    line.backgroundColor=[UIColor whiteColor];
    [bgImageView addSubview:line];
    
    
    [self titleInsertion:@"Current Coins:" inPosition:0];
    [self titleInsertion:@"Total Coins Collected:" inPosition:1];
    [self titleInsertion:@"Auctions Played:" inPosition:2];
    [self titleInsertion:@"Auctions Won:" inPosition:3];

    
    coinsText=[self valueInsertion:@"" inPosition:0];
    totalCoinsCollectedText=[self valueInsertion:@"" inPosition:1];
    auctionsPlayedText=[self valueInsertion:@"" inPosition:2];
    auctionsWonText=[self valueInsertion:@"" inPosition:3];

        
    UIButton *closeBuyCoinsBtn2=[[UIButton alloc]init];
    UIImage *closeImage2=[UIImage imageNamed:@"closeBtn.png"];
    CGRect closeBtnFrame=CGRectMake(325, -5, 40, 40);
    closeBuyCoinsBtn2.frame=closeBtnFrame;
    [closeBuyCoinsBtn2 setBackgroundImage:closeImage2 forState:UIControlStateNormal];
    [closeBuyCoinsBtn2 setTag:56];
    [closeBuyCoinsBtn2 addTarget:self 
                          action:@selector(setViewAlphaToCero)
                forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:closeBuyCoinsBtn2];
    
}
-(void)userInfo{
    profileImageView.image=profileUser.image;
    NSString *formattedString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:profileUser.coins]];
    coinsText.text=[NSString stringWithFormat:@"§%@",formattedString];
    mailLabel.text=[NSString stringWithFormat:@"Contact e-mail: \n%@",profileUser.mail];
    profileNameLabel.text=profileUser.firstName;
    NSString *formattedString2 = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:profileUser.adWonCoinsHistory+profileUser.freeCoinsHistory+profileUser.payedCoinsHistory]];
    totalCoinsCollectedText.text=[NSString stringWithFormat:@"§%@",formattedString2];
    auctionsPlayedText.text=[NSString stringWithFormat:@"%.0f",profileUser.auctionsPlayed];
    auctionsWonText.text=[NSString stringWithFormat:@"%.0f",profileUser.auctionsWon];

}
#pragma mark - alphas
-(void)setViewAlphaToCero{
    [self userInfo];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    self.alpha=0;
    [UIView commitAnimations];
    [self moveOut];
}
-(void)setViewAlphaToOne{
    [self userInfo];
    [self serverCaller];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    self.alpha=1;
    [UIView commitAnimations];
    [self moveIn];
}
-(void)moveOut{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    bgImageView.center=CGPointMake(self.frame.size.width/2, 1000);
    [UIView commitAnimations];
}
-(void)moveIn{
    [self userInfo];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    bgImageView.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [UIView commitAnimations];
}
#pragma mark - touch
-(void) ClickEventOnImage:(id) sender{
    NSLog(@"Edit Avatar");
}

#pragma mark- button triggers

#pragma mark title maker
-(void)titleInsertion:(NSString*)title inPosition:(int)position{
    UIFont *titlesFont=[UIFont boldSystemFontOfSize:12];
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.frame=CGRectMake(35, profileImageView.frame.size.height+50 +(30*position), 130, 30);
    titleLabel.text=title;
    titleLabel.numberOfLines=2;
    titleLabel.font=titlesFont;
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.textAlignment=UITextAlignmentLeft;
    [bgImageView addSubview:titleLabel];
}
-(UILabel*)valueInsertion:(NSString*)title inPosition:(int)position{
    UIFont *titlesFont=[UIFont boldSystemFontOfSize:20];
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.frame=CGRectMake(182, profileImageView.frame.size.height+50 +(30*position), 130, 30);
    titleLabel.text=title;
    titleLabel.numberOfLines=2;
    titleLabel.font=titlesFont;
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.textAlignment=UITextAlignmentRight;
    [bgImageView addSubview:titleLabel];
    return titleLabel;
}

#pragma mark - partner VC caller

#pragma mark - update
-(void)updateUserInfo{
    [self userInfo];
}
#pragma mark - server receiver
-(void)serverCaller{
    [server callServerWithMethod:@"GetUserAdditionalInfo" andParameter:profileUser.ID];
}
#pragma mark - server receiver
-(void)receivedDataFromServer:(id)sender{
    server=sender;
    NSLog(@"additional info <------------------");
    profileUser.adWonCoinsHistory=[[server.resDic objectForKey:@"WonCoins"]doubleValue];
    profileUser.freeCoinsHistory=[[server.resDic objectForKey:@"FreeCoins"]doubleValue];
    profileUser.payedCoinsHistory=[[server.resDic objectForKey:@"AddCoins"]doubleValue];
    profileUser.auctionsWon=[[server.resDic objectForKey:@"AuctionsWon"]doubleValue];
    profileUser.auctionsPlayed=[[server.resDic objectForKey:@"AuctionsPlayed"]doubleValue];
    [self userInfo];
}
@end
