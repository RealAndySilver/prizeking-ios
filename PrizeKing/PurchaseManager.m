//
//  PurchaseManager.m
//  PrizeKing
//
//  Created by Andrés Abril on 17/07/12.
//
//

#import "PurchaseManager.h"

@implementation PurchaseManager
@synthesize productIdentifiers = _productIdentifiers;
@synthesize products = _products;
@synthesize purchasedProducts = _purchasedProducts;
@synthesize request = _request;

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    if ((self = [super init])) {
        // Store product identifiers
        _productIdentifiers = productIdentifiers;
        NSLog(@"identifiers %@",_productIdentifiers);
        // Check for previously purchased products
        NSMutableSet * purchasedProducts = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [purchasedProducts addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
            }
            else
            NSLog(@"Not purchased: %@", productIdentifier);
        }
        self.purchasedProducts = purchasedProducts;
    }
    return self;
}

- (void)requestProducts {
    self.request = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _request.delegate = self;
    [_request start];    
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    self.products = response.products;
    self.request = nil;    
    //NSLog(@"Received products results...%@",response.products);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProductsLoaded" object:_products];
}

- (void)recordTransaction:(SKPaymentTransaction *)transaction {    
    // TODO: Record the transaction on the server side...
    //NSString *data=[[NSString alloc]initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"ProductPurchased" object:data];
}

- (void)provideContent:(NSString *)productIdentifier {
    //Método de guardado con NSDefault --> no me agrada
    NSLog(@"Toggling flag for: %@", productIdentifier);
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_purchasedProducts addObject:productIdentifier];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedNotification object:productIdentifier];
    
    //Mi método de guardado utilizando la clase Modelador para comunicación con DB
    //Modelador *guardar=[[Modelador alloc]init];
    if ([productIdentifier isEqualToString:@"com.iamstudio.iAmLucky.RedPack"]) {
        //[guardar setPackPurchaseWithID:1];
    }
    else if ([productIdentifier isEqualToString:@"com.iamstudio.iAmLucky.BluePack"]) {
        //[guardar setPackPurchaseWithID:2];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProductPurchased" object:productIdentifier];
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    //NSLog(@"completeTransaction...");
    
    [self recordTransaction: transaction];
    [self provideContent: transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    
    //NSLog(@"restoreTransaction...");
    
    [self recordTransaction: transaction];
    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        //NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProductPurchaseFailedWithNotification" object:transaction];
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"Buy");
                
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"Fail");
                
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Restore");
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void)buyProductIdentifier:(NSString *)productIdentifier {
    
    //NSLog(@"Buying %@...", productIdentifier);
    
    SKMutablePayment *payment = [[SKMutablePayment alloc] init];
    payment.productIdentifier = productIdentifier;
    payment.quantity=1;
    [[SKPaymentQueue defaultQueue] addPayment:payment];    
}

- (void)dealloc
{
    _productIdentifiers = nil;
    _products = nil;
    _purchasedProducts = nil;
    _request = nil;
}

@end
