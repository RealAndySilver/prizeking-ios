//
//  User.h
//  PrizeKing
//
//  Created by Andres Abril on 16/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAmCoder.h"

@interface User : NSObject{
}
@property(nonatomic,retain)NSString *firstName;
@property(nonatomic,retain)NSString *lastName;
@property(nonatomic,retain)NSString *mail;
@property(nonatomic,retain)NSString *ID;
@property(nonatomic)double payedCoinsHistory;
@property(nonatomic)double freeCoinsHistory;
@property(nonatomic)double adWonCoinsHistory;
@property(nonatomic)double auctionsPlayed;
@property(nonatomic)double auctionsWon;
@property(nonatomic,retain)UIImage *image;
@property(nonatomic,retain)NSString *userDeviceToken;
@property(nonatomic,retain)NSArray *friendsList;
@property(nonatomic,retain)NSArray *friendsListInstalled;
@property(nonatomic,retain)NSArray *friendsListNOTInstalled;
@property(nonatomic,retain)NSDictionary *partnersDic;


@property(nonatomic)double coins;
-(id)initWithFirstName:(NSString*)theFirstName lastName:(NSString*)theLastName image:(NSString*)theImage andCoins:(double)theCoins withFriendList:(NSMutableArray*)theFriendsList ID:(NSString*)theID deviceToken:(NSString*)deviceToken andMail:(NSString*)theMail;
-(id)initUserWithDictionary:(NSDictionary*)dictionary andDeviceToken:(NSString*)deviceToken;
-(void)updateAdditionalInfoWithDictionary:(NSDictionary*)dictionary;
@end
