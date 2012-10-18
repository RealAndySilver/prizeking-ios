//
//  FirstViewController.h
//  PrizeKing
//
//  Created by Andres Abril on 10/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "User.h"
#import "BuyCoinsView.h"
#import "BidViewController.h"
#import "FileSaver.h"
#import "NotificationThanks.h"
#import "TestimonialsViewController.h"
#import "OfferWallViewController.h"
#import "NavAnimations.h"
#import "ServerCommunicator.h"
#import "FacebookInviteViewController.h"
#import "SoundController.h"
#import "ProfileView.h"
#import "FacebookMainVC.h"
#import "Tapjoyconnect.h"
#import "OptionsViewController.h"
#import "CoinCaller.h"

@interface MainMenuViewController : UIViewController<UIGestureRecognizerDelegate>{
    NSMutableArray *btnArray;
    UIScrollView *scrollView;
    UIImageView *bubbleImageView;
    
    //Outlets
    IBOutlet UILabel *userName;
    IBOutlet UILabel *userCoins;
    IBOutlet UIImageView *userImage;
    
    SoundController *soundObject;
    
    BuyCoinsView *buyView;
    ProfileView *profileView;

    NotificationThanks *notiView;
    FileSaver *file;
    
    //Objects
    User *user;
    double monedasTemporales;
    
    ServerCommunicator *server;
    int peticion; //1 chargeCoins, 2 getCoins,3 free coins from notification, 0 nill
    
    CoinCaller *coin;
    
    UIActivityIndicatorView *coinSpinner;
    NSTimer *timer;//timer para agregar botón random
}
@property(nonatomic,retain)User *user;
@end
