//
//  User.m
//  PrizeKing
//
//  Created by Andres Abril on 16/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "User.h"

@implementation User
@synthesize firstName;
@synthesize lastName;
@synthesize mail;
@synthesize image;
@synthesize coins;
@synthesize friendsList,friendsListInstalled,friendsListNOTInstalled,partnersDic;
@synthesize ID;
@synthesize userDeviceToken;
@synthesize payedCoinsHistory,freeCoinsHistory,adWonCoinsHistory;
-(id)initWithFirstName:(NSString*)theFirstName lastName:(NSString*)theLastName image:(NSString*)theImage andCoins:(double)theCoins withFriendList:(NSMutableArray*)theFriendsList ID:(NSString*)theID deviceToken:(NSString*)deviceToken andMail:(NSString*)theMail{
    self.firstName=theFirstName;
    self.lastName=theLastName;
    self.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[IAmCoder decodeURL:theImage]]]];
    self.userDeviceToken=deviceToken;
    self.coins=theCoins;
    self.friendsList=theFriendsList;
    self.friendsListInstalled=[theFriendsList objectAtIndex:1];
    self.friendsListNOTInstalled=[theFriendsList objectAtIndex:2];
    self.ID=theID;
    self.mail=theMail;
    
    NSLog(@"\n first name: %@ \n last name: %@ \n image %@ \n deviceToken %@ \n coins %.0f \n ID %@ \n mail %@",firstName,lastName,image,userDeviceToken,coins,ID,mail);
    return self;
}
-(id)initUserWithDictionary:(NSDictionary*)dictionary andDeviceToken:(NSString*)deviceToken{
    NSDictionary *userDic=[dictionary objectForKey:@"User"];
    NSDictionary *additionalInfo=[dictionary objectForKey:@"AdditionalInfo"];
    NSDictionary *partners=[dictionary objectForKey:@"Partners"];

    self.ID=[userDic objectForKey:@"FacebookId"];
    self.firstName=[userDic objectForKey:@"FirstName"];
    self.lastName=[userDic objectForKey:@"LastName"];
    self.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[IAmCoder decodeURL:[userDic objectForKey:@"Image"]]]]];
    self.mail=[userDic objectForKey:@"Mail"];
    self.coins=[[userDic objectForKey:@"Balance"]doubleValue];
    self.userDeviceToken=deviceToken;
         self.freeCoinsHistory=[[additionalInfo objectForKey:@"FreeCoins"]doubleValue];
    self.adWonCoinsHistory=[[additionalInfo objectForKey:@"WonCoins"]doubleValue];
    self.auctionsPlayed=[[additionalInfo objectForKey:@"AuctionsPlayed"]doubleValue];
    self.auctionsWon=[[additionalInfo objectForKey:@"AuctionsWon"]doubleValue];
    self.partnersDic=partners;
    NSLog(@"\n first name: %@ \n last name: %@ \n image %@ \n deviceToken %@ \n coins %.0f \n ID %@ \n mail %@",firstName,lastName,image,userDeviceToken,coins,ID,mail);
    
    return self;
}
-(void)updateAdditionalInfoWithDictionary:(NSDictionary*)dictionary{
    self.auctionsWon=[[[dictionary objectForKey:@"AdditionalInfo"]objectForKey:@"AuctionsWon"]doubleValue];
    self.auctionsPlayed=[[[dictionary objectForKey:@"AdditionalInfo"]objectForKey:@"AuctionsWon"]doubleValue];
    self.payedCoinsHistory=[[[dictionary objectForKey:@"AdditionalInfo"]objectForKey:@"AddCoins"]doubleValue];
    self.freeCoinsHistory=[[[dictionary objectForKey:@"AdditionalInfo"]objectForKey:@"FreeCoins"]doubleValue];
    self.adWonCoinsHistory=[[[dictionary objectForKey:@"AdditionalInfo"]objectForKey:@"WonCoins"]doubleValue];
}
@end
