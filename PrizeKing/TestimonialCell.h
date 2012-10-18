//
//  TestimonialCell.h
//  PrizeKing
//
//  Created by Andres Abril on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestimonialsViewController.h"
#import "IAmCoder.h"
@class TestimonialsViewController;
@interface TestimonialCell : UIView{    
}
@property(nonatomic,retain)TestimonialsViewController *tVC;
@property(nonatomic,retain)NSString *prizeKingWinner;
@property(nonatomic,retain)NSString *prizeWon;
@property(nonatomic)int auctionsWon;
@property(nonatomic,retain)NSString *auction;
@property(nonatomic)int numberOfBidsMade;
@property(nonatomic,retain)NSString *when;
@property(nonatomic,retain)UIImage *winnerPic;
@property(nonatomic,retain)NSString *testimonial;
@property(nonatomic,retain)NSString *description;

-(void)constructObjectWithWinner:(NSString*)winner 
                        prizeWon:(NSString*)prWon 
                     auctionsWon:(int)auctWon 
                     auctionType:(NSString*)aucType
                numberOfBidsMade:(int)noOfBidsMade 
                            when:(NSString*)wn
                     testimonial:(NSString*)test
                     positionInY:(float)posY
                       winnerPic:(UIImage*)wPic
                     description:(NSString*)desc
                       inContext:(TestimonialsViewController*)viewController;

-(void)constructObjectWithDictionary:(NSDictionary*)dictionary 
                           inContext:(TestimonialsViewController*)viewController 
                         andPosition:(float)posY;
-(void)cellInitWithY:(float)y;
-(void)gotoView;
@end
