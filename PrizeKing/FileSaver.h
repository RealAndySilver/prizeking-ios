//
//  FileSaver.h
//  PrizeKing
//
//  Created by Andres Abril on 18/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileSaver : NSObject{
    NSDictionary *datos;
    NSDictionary *datosFriendList;

}
-(double)getCoinsQuantity;
-(void)setCoinsQuantity:(double)numero;
-(void)setDeviceToken:(NSString*)token;
-(NSString*)getDeviceToken;

@end
