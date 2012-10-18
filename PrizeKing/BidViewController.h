//
//  BidViewController.h
//  PrizeKing
//
//  Created by Andres Abril on 15/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BuyCoinsView.h"
#import "User.h"
#import "BidView.h"
#import "FileSaver.h"
#import "TestimonialsViewController.h"
#import "NavAnimations.h"
#import "OfferWallViewController.h"
#import "ServerCommunicator.h"
#import "MBProgressHud.h"
#import "ProfileView.h"
#import "OptionsViewController.h"
#import "CoinCaller.h"
@class BidView;


@interface BidViewController : UIViewController<UIGestureRecognizerDelegate>{
    BuyCoinsView *buyView;
    IBOutlet UILabel *userName;
    IBOutlet UILabel *userCoins;
    IBOutlet UIImageView *userImage;
    
    NSMutableArray *bidArray;
    UIScrollView *scrollView;
    
    //The Bids
    BidView *bid1;
    BidView *bid2;
    BidView *bid3;
    BidView *bid4;
    BidView *bid5;
    BidView *bid6;
            
    FileSaver *file;
    
    ServerCommunicator *server;
    CoinCaller *coin;
    MBProgressHUD *hud;
    
    int peticion;//0 null, 1 traer auctions, 2 traer monedas, 3 cargar monedas
    int descontar;
    double monedasTemporales;
    
    ProfileView *profileView;
    UIActivityIndicatorView *coinSpinner;


}
@property(nonatomic,retain)User *user;
-(void)placeBidWithTag:(int)tag;
-(void)userInfo;
-(void)bidHudOn;
-(void)bidHudOffOK;
-(void)bidHudOffError;
-(void)buyViewAppear;

@end
