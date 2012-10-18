//
//  Bid.h
//  PrizeKing
//
//  Created by Andres Abril on 16/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bid : NSObject{
    NSTimer *timer;
    NSThread *bThread;
}
@property(nonatomic,retain)NSString *prizeUrl;
@property(nonatomic,retain)NSString *prizeName;
@property(nonatomic,retain)NSString *currentWinnerUrl;
@property(nonatomic,retain)NSString *currentWinnerName;
@property(nonatomic)int minutes;
@property(nonatomic)int seconds;
@property(nonatomic)BOOL continuaElTimer;



@end
