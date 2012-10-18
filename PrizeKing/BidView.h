//
//  BidView.h
//  PrizeKing
//
//  Created by Andres Abril on 16/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BidViewController.h"
#import "SoundController.h"
#import "ServerCommunicator.h"
#import "CustomButton.h"
#import "User.h"
#import "IAmCoder.h"
#import "CacheImage.h"
#import "BlackAndWhiter.h"
@class BidViewController;
@interface BidView : UIView<UIGestureRecognizerDelegate>{
    UILabel *timerLabel;
    
    NSTimer *timer;
    NSTimer *refresher;
    NSThread *bThread;
    
    UIImageView *prizeImageView;
    UILabel *prizeNameLabel;
    UIImageView *currentWinnerImageView;
    UILabel *currentWinnerLabel;
    UILabel *currentWinnerBids;

    
    UILabel *bigNumberContainer;
    UILabel *bigNumberLabel;
    
    ServerCommunicator *server;
    BOOL active;
    NSString *bidPrice;
    
    UIActivityIndicatorView *spinner;
    
    UITextView *description;
    int peticion;//0 null, 1 place bid, 2 refresh
    
    UILabel *label15plus;
    CGRect label15plusFrame;
    CGRect label15plusFrameEnd;
    
    
}
@property(nonatomic,retain)UILabel *timerLabel;
@property(nonatomic)int segundos;
@property(nonatomic)int minutos;
@property(nonatomic)int horas;
@property(nonatomic,retain)NSString *auctionID;
@property(nonatomic)int thisTag;
@property(nonatomic)BOOL continuaElTimer;
@property(nonatomic,retain)BidViewController *currentBVC;
@property(nonatomic,retain)User *user;
@property(nonatomic,retain)NSTimer *refresher;



-(void)initBidWithDictionary:(NSMutableDictionary*)dic andContext:(BidViewController*)bVC;

@end
