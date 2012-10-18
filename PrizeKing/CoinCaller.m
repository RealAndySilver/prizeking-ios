//
//  CoinCaller.m
//  PrizeKing
//
//  Created by Andres Abril on 14/10/12.
//
//

#import "CoinCaller.h"

@implementation CoinCaller
@synthesize caller;
-(void)getCoinsWithUserId:(NSString*)userId{
    server=[[ServerCommunicator alloc]init];
    server.caller=self;
    [server callServerWithMethod:@"GetUserCoins" andParameter:userId];
}
-(void)receivedDataFromServer:(id)sender{
    server=sender;
    if ([caller respondsToSelector:@selector(receivedFromCoinSubClass:)]) {
        [caller performSelector:@selector(receivedFromCoinSubClass:) withObject:server.resDic];
    }
}
@end
