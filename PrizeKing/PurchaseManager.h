//
//  PurchaseManager.h
//  PrizeKing
//
//  Created by Andrés Abril on 17/07/12.
//
//

#import <Foundation/Foundation.h>
#import "StoreKit/StoreKit.h"

#define kProductsLoadedNotification         @"ProductsLoaded"
#define kProductPurchasedNotification       @"ProductPurchased"
#define kProductPurchaseFailedNotification  @"ProductPurchaseFailed"

@interface PurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver> {
    NSSet *_productIdentifiers;    
    NSArray *_products;
    NSMutableSet *_purchasedProducts;
    SKProductsRequest * _request;    
}

@property (retain) NSSet *productIdentifiers;
@property (retain) NSArray *products;
@property (retain) NSMutableSet *purchasedProducts;
@property (retain) SKProductsRequest *request;

- (void)requestProducts;
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)buyProductIdentifier:(NSString *)productIdentifier;

@end