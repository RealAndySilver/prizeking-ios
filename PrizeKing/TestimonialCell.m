//
//  TestimonialCell.m
//  PrizeKing
//
//  Created by Andres Abril on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestimonialCell.h"

@implementation TestimonialCell
@synthesize tVC;
@synthesize prizeKingWinner,prizeWon,auctionsWon,auction,numberOfBidsMade,when, testimonial,winnerPic,description;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code        
    }
    return self;
}
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
                       inContext:(TestimonialsViewController*)viewController{
    tVC=viewController;
    self.prizeKingWinner=winner;
    self.prizeWon=prWon;
    self.auctionsWon=auctWon;
    self.auction=aucType;
    self.numberOfBidsMade=noOfBidsMade;
    self.when=wn;
    self.testimonial=test;
    self.winnerPic=wPic;
    self.description=desc;
    [self cellInitWithY:posY];
}
-(void)constructObjectWithDictionary:(NSDictionary*)dictionary inContext:(TestimonialsViewController*)viewController andPosition:(float)posY{
    NSString *firstName=[dictionary objectForKey:@"FirstName"];
    NSString *lastName=[dictionary objectForKey:@"LastName"];
    NSString *PrizeWon=[dictionary objectForKey:@"PrizeWon"];
    NSString *PrizeWinnerWon=[dictionary objectForKey:@"PrizeWinnerWon"];
    NSString *CountBids=[dictionary objectForKey:@"CountBids"];
    NSString *WhenLastBid=[dictionary objectForKey:@"WhenLastBid"];
    NSString *CommentsWinner=[dictionary objectForKey:@"CommentsWinner"];
    NSString *WinnerImage=[dictionary objectForKey:@"WinnerImage"];

    int AuctionCategory=[[dictionary objectForKey:@"AuctionCategory"] intValue];
    if (AuctionCategory==1) {
        self.auction=@"Gold";
    }
    else if (AuctionCategory==2) {
        self.auction=@"Silver";
    }
    else if (AuctionCategory==3) {
        self.auction=@"Bronze";
    }
    tVC=viewController;
    self.prizeKingWinner=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
    self.prizeWon=PrizeWon;
    self.auctionsWon=[PrizeWinnerWon intValue];
    self.numberOfBidsMade=[CountBids intValue];
    self.when=WhenLastBid;
    self.testimonial=CommentsWinner;
    NSData *data=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[IAmCoder decodeURL:WinnerImage]]];
    self.winnerPic=[UIImage imageWithData:data];
    self.description=CommentsWinner;
    [self cellInitWithY:posY];
}
-(void)cellInitWithY:(float)y{
    self.frame=CGRectMake(0, y, 438, 36);
    float posY=0;
    float height=36;
    UIImageView *backGround=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backGround.image=[UIImage imageNamed:@"gradientBar.png"];
    [self addSubview:backGround];
    UIImageView *wPic=[[UIImageView alloc]initWithFrame:CGRectMake(3, 3, 30, 30)];
    wPic.image=self.winnerPic;
    //wPic.layer.cornerRadius = 4.0;
    wPic.layer.masksToBounds = YES;
    wPic.contentMode = UIViewContentModeScaleAspectFill;
    //[wPic.layer setBorderColor: [[UIColor blackColor] CGColor]];
    //[wPic.layer setBorderWidth: 2.0];
    [self addSubview:wPic];
    UIFont *leFont=[UIFont fontWithName:@"Helvetica" size:10.0];
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(40, 0, 60, 36)];
    [button addTarget:self 
               action:@selector(gotoView) 
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:self.prizeKingWinner forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //button.backgroundColor=[UIColor redColor];
    [button.titleLabel setFont:leFont];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self addSubview:button];                      
    
    UILabel *prizeWonLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, posY, 70, height)];
    prizeWonLabel.text=self.prizeWon;
    prizeWonLabel.font=leFont;
    [prizeWonLabel setTextAlignment:UITextAlignmentLeft];
    prizeWonLabel.backgroundColor=[UIColor clearColor];
    [self addSubview:prizeWonLabel];
    
    UILabel *auctionsWonLabel=[[UILabel alloc]initWithFrame:CGRectMake(190, posY, 40, height)];
    auctionsWonLabel.text=[NSString stringWithFormat:@"%i", self.auctionsWon];
    auctionsWonLabel.font=leFont;
    [auctionsWonLabel setTextAlignment:UITextAlignmentCenter];
    auctionsWonLabel.backgroundColor=[UIColor clearColor];
    [self addSubview:auctionsWonLabel];
    
    UILabel *auctionLabel=[[UILabel alloc]initWithFrame:CGRectMake(247, posY, 50, height)];
    auctionLabel.text=self.auction;
    auctionLabel.font=leFont;
    [auctionLabel setTextAlignment:UITextAlignmentCenter];
    auctionLabel.backgroundColor=[UIColor clearColor];
    [self addSubview:auctionLabel];
    
    UILabel *noOfBidsMadeLabel=[[UILabel alloc]initWithFrame:CGRectMake(320, posY, 50, height)];
    noOfBidsMadeLabel.text=[NSString stringWithFormat:@"%i", self.numberOfBidsMade];
    noOfBidsMadeLabel.font=leFont;
    [noOfBidsMadeLabel setTextAlignment:UITextAlignmentCenter];
    noOfBidsMadeLabel.backgroundColor=[UIColor clearColor];
    [self addSubview:noOfBidsMadeLabel];
    
    UILabel *whenLabel=[[UILabel alloc]initWithFrame:CGRectMake(380, posY, 50, height)];
    whenLabel.text=self.when;
    whenLabel.font=leFont;
    [whenLabel setTextAlignment:UITextAlignmentCenter];
    whenLabel.backgroundColor=[UIColor clearColor];
    [self addSubview:whenLabel];
    
    UIButton *button2=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 36)];
    [button2 addTarget:self 
               action:@selector(gotoView) 
     forControlEvents:UIControlEventTouchUpInside];
    [button2 setTitle:@"" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button2.backgroundColor=[UIColor clearColor];
    [button2.titleLabel setFont:leFont];
    [button2 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self addSubview:button2];
}
-(void)gotoView{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    [array addObject:self.description];
    [array addObject:self.prizeKingWinner];
    [tVC irADescripcionConArreglo:array];
}
@end
