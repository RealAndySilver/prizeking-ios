//
//  NotificationThanks.m
//  PrizeKing
//
//  Created by Andres Abril on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotificationThanks.h"

@implementation NotificationThanks

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self bgInit];
    }
    return self;
}

-(void)bgInit{
    CGRect viewFrame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIView *elView=[[UIView alloc]initWithFrame:viewFrame];
    [elView setClipsToBounds:YES];
    elView.backgroundColor=[UIColor blackColor];
    elView.alpha=0.6;
    UIImage *bgImage=[UIImage imageNamed:@"coinsBG.png"];
    bgImageView=[[UIImageView alloc]initWithImage:bgImage];
    [bgImageView setUserInteractionEnabled:YES];
    CGRect imageViewRect=CGRectMake(0, 0, 302, 254);
    bgImageView.frame=imageViewRect;
    bgImageView.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [bgImageView setClipsToBounds:YES];
    
    UIImage *getCoinsImage=[UIImage imageNamed:@"getCoinsBanner.png"];
    UIImageView *getCoinsBanner=[[UIImageView alloc]initWithImage:getCoinsImage];
    CGRect getCoinsBannerRect=CGRectMake(0, 0, 238, 39);
    getCoinsBanner.frame=getCoinsBannerRect;
    getCoinsBanner.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2-92);
    [self addSubview:elView];
    [self addSubview:bgImageView];
    //[self addSubview:getCoinsBanner];
    [self buttonInit];
}
-(void)buttonInit{
    UIButton *closeBuyCoinsBtn2=[[UIButton alloc]init];
    UIImage *closeImage2=[UIImage imageNamed:@"closeBtn.png"];
    
    CGRect closeBtnFrame=CGRectMake(265, -5, 40, 40);
    closeBuyCoinsBtn2.frame=closeBtnFrame;
    [closeBuyCoinsBtn2 setBackgroundImage:closeImage2 forState:UIControlStateNormal];
    [closeBuyCoinsBtn2 setTag:56];
    [closeBuyCoinsBtn2 addTarget:self 
                          action:@selector(setViewAlphaToCero)
                forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:closeBuyCoinsBtn2];
    
}
-(void)setViewAlphaToCero{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    self.alpha=0;
    [UIView commitAnimations];
}
-(void)buyCoinsWithIdentifier:(UIButton*)sender{
    if (sender.tag==50) {
        NSLog(@"Este botón da la orden para comprar 1000 monedas");
    }
    else if (sender.tag==51) {
        NSLog(@"Este botón da la orden para comprar 3500 monedas");
    }
    else if (sender.tag==52) {
        NSLog(@"Este botón da la orden para comprar 7500 monedas");
    }
    else if (sender.tag==53) {
        NSLog(@"Este botón da la orden para comprar 15500 monedas");
    }
    else if (sender.tag==54) {
        NSLog(@"Este botón da la orden para comprar 31500 monedas");
    }
    else if (sender.tag==55) {
        NSLog(@"Este botón da la orden para comprar 50000 monedas");
    }
}



@end
