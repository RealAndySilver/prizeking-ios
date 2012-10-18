//
//  PurchaseHelper.m
//  PrizeKing
//
//  Created by Andrés Abril on 17/07/12.
//
//

#import "PurchaseHelper.h"
#import "PurchaseManager.h"

@implementation PurchaseHelper

static PurchaseHelper *_sharedHelper;

+ (PurchaseHelper *)sharedHelper{
    
    if (_sharedHelper != nil) {
        return _sharedHelper;
    }
    _sharedHelper = [[PurchaseHelper alloc] init];
    return _sharedHelper;
    
}

- (id)init {
    
    NSSet *productIdentifiers = [NSSet setWithObjects:
                                 @"com.iamstudio.prizeKing.1000coins",
                                 @"com.iamstudio.prizeKing.3500coins",
                                 @"com.iamstudio.prizeKing.7500coins",
                                 @"com.iamstudio.prizeKing.15500coins",
                                 @"com.iamstudio.prizeKing.31500coins",
                                 @"com.iamstudio.prizeKing.50000coins",
                                 //@"com.iamstudio.prizeKing.test",
                                 nil];
    //NSLog(@"Product id =%@",productIdentifiers);
    if ((self = [super initWithProductIdentifiers:productIdentifiers])) {                
        
    }
    return self;
    
}

@end
