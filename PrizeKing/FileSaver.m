//
//  FileSaver.m
//  PrizeKing
//
//  Created by Andres Abril on 18/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FileSaver.h"
#define DATAFILENAME @"savefile.plist"
#define FRIENDLISTFILE @"friendList.plist"

@implementation FileSaver
-(id) init{
	if ((self = [super init])) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *Path = [paths objectAtIndex:0];
		//NSString *Path = [[NSBundle mainBundle] bundlePath];
		NSString *DataPath = [Path stringByAppendingPathComponent:DATAFILENAME];
		NSDictionary *tempDict = [[NSDictionary alloc] initWithContentsOfFile:DataPath];
		
        if (!tempDict) {
			tempDict = [[NSDictionary alloc] init];
		}
        datos = tempDict;
        
        NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *Path2 = [paths2 objectAtIndex:0];
		//NSString *Path = [[NSBundle mainBundle] bundlePath];
		NSString *DataPath2 = [Path2 stringByAppendingPathComponent:FRIENDLISTFILE];
		NSDictionary *tempDict2 = [[NSDictionary alloc] initWithContentsOfFile:DataPath2];
		
        if (!tempDict2) {
			tempDict2 = [[NSDictionary alloc] init];
		}
        datosFriendList = tempDict2;
	}    
	return self;
}
-(BOOL)guardar{
	NSData *xmlData;  
	NSString *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *Path = [paths objectAtIndex:0];
	//NSString *Path = [[NSBundle mainBundle] bundlePath];
    //NSLog(@"guardar %@",datosConf);
	NSString *DataPath = [Path stringByAppendingPathComponent:DATAFILENAME];
	xmlData = [NSPropertyListSerialization dataFromPropertyList:datos format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];  
	if (xmlData) {  
		[xmlData writeToFile:DataPath atomically:YES];  
		return YES;
	} else {  
		NSLog(@"Error writing plist to file '%s', error = '%s'", [DataPath UTF8String], [error UTF8String]);  
		return NO;
	}
}
-(BOOL)guardarFriendList{
	NSData *xmlData;  
	NSString *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *Path = [paths objectAtIndex:0];
	//NSString *Path = [[NSBundle mainBundle] bundlePath];
    //NSLog(@"guardar %@",datosConf);
	NSString *DataPath = [Path stringByAppendingPathComponent:FRIENDLISTFILE];
	xmlData = [NSPropertyListSerialization dataFromPropertyList:datosFriendList format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
	if (xmlData) {  
		[xmlData writeToFile:DataPath atomically:YES];  
		return YES;
	} else {  
		NSLog(@"Error writing plist to file '%s', error = '%s'", [DataPath UTF8String], [error UTF8String]);  
		return NO;
	}
}
-(double)getCoinsQuantity{
    return [[datos objectForKey:@"Coins"]doubleValue];
}
-(void)setCoinsQuantity:(double)numero{
	NSMutableDictionary *newData = [datos mutableCopy];
	[newData setObject:[NSNumber numberWithDouble:numero] forKey:@"Coins"];
	datos = newData;
	[self guardar];
}
-(NSString*)getDeviceToken{
    return [datos objectForKey:@"deviceToken"];
}
-(void)setDeviceToken:(NSString*)token{
	NSMutableDictionary *newData = [datos mutableCopy];
	[newData setObject:token forKey:@"deviceToken"];
	datos = newData;
	[self guardar];
}



@end
