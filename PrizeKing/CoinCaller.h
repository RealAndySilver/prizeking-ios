//
//  CoinCaller.h
//  PrizeKing
//
//  Created by Andres Abril on 14/10/12.
//
//

#import <Foundation/Foundation.h>
#import "ServerCommunicator.h"

@interface CoinCaller : NSObject{
    ServerCommunicator *server;
}
@property(nonatomic,retain)id caller;
-(void)getCoinsWithUserId:(NSString*)userId;
@end
