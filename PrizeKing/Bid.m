//
//  Bid.m
//  PrizeKing
//
//  Created by Andres Abril on 16/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Bid.h"

@implementation Bid
@synthesize prizeUrl,prizeName,currentWinnerUrl,currentWinnerName;
@synthesize minutes,seconds;
@synthesize continuaElTimer;

-(id)initWithMinutes:(int)minutos andSeconds:(int)segundos{
    continuaElTimer = YES;
    bThread=[[NSThread alloc]initWithTarget:self
                                   selector:@selector(secondThreadTest) 
                                     object:nil];
    [bThread start];
    return  self;
}

#pragma mark-timer
-(void)secondThreadTest{
    
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                           selector:@selector(pruebaTimer) userInfo:nil repeats:YES];
    
    while (continuaElTimer && [theRL runMode:NSDefaultRunLoopMode 
                                  beforeDate:[NSDate distantFuture]]);
}
-(void)pruebaTimer{
    if (continuaElTimer) {
        if (minutes<10 && minutes>=0) {
            //timerLabel.textColor=[UIColor redColor];
        }
        seconds--;
        if (seconds<0) {
            minutes--;
            seconds=59;
            //timerLabel.text=[NSString stringWithFormat:@"%i:%i",minutos,segundos];
        }
        else if (seconds<10) {
            //timerLabel.text=[NSString stringWithFormat:@"%i:0%i",minutes,seconds];
        }
        else {
            //timerLabel.text=[NSString stringWithFormat:@"%i:%i",minutos,segundos];
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
@end
