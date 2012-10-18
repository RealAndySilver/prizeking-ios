//
//  BidView.m
//  PrizeKing
//
//  Created by Andres Abril on 16/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BuyCoinsView.h"

@implementation BuyCoinsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       // [self bgInit];
    }
    return self;
}
-(void)bgInitWithVC:(UIViewController*)VC{
    contextVC=VC;
    NSLog(@"Le VC %@",contextVC);
    CGRect viewFrame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIView *elView=[[UIView alloc]initWithFrame:viewFrame];
    [elView setClipsToBounds:YES];
    elView.backgroundColor=[UIColor blackColor];
    elView.alpha=0.6;
    UIImage *bgImage=[UIImage imageNamed:@"coinsBG.png"];
    bgImageView=[[UIImageView alloc]initWithImage:bgImage];
    [bgImageView setUserInteractionEnabled:YES];
    CGRect imageViewRect=CGRectMake(0, 0, 302, 254);
    bgImageView.frame=imageViewRect;
    bgImageView.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [bgImageView setClipsToBounds:YES];

    UIImage *getCoinsImage=[UIImage imageNamed:@"getCoinsBanner.png"];
    UIImageView *getCoinsBanner=[[UIImageView alloc]initWithImage:getCoinsImage];
    CGRect getCoinsBannerRect=CGRectMake(0, 0, 238, 39);
    getCoinsBanner.frame=getCoinsBannerRect;
    getCoinsBanner.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2-92);
    [self addSubview:elView];
    [self addSubview:bgImageView];
    [self addSubview:getCoinsBanner];
    [self buttonInit];
    self.alpha=0;
}
-(void)buttonInit{
    int posY1=60;
    int posY2=posY1+87;
    UIButton *coins1=[[UIButton alloc]init];
    coins1.frame=CGRectMake(25, posY1, 77, 77);
    [coins1 setTag:50];
    UIImage *coins1Image=[UIImage imageNamed:@"1000coins.png"];
    [coins1 setBackgroundImage:coins1Image forState:UIControlStateNormal];
    [coins1 addTarget:self 
                     action:@selector(buyCoinsWithIdentifier:)
           forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:coins1];
    
    UIButton *coins2=[[UIButton alloc]init];
    coins2.frame=CGRectMake(112, posY1, 77, 77);
    [coins2 setTag:53];
    UIImage *coins2Image=[UIImage imageNamed:@"3500coins.png"];
    [coins2 setBackgroundImage:coins2Image forState:UIControlStateNormal];
    [coins2 addTarget:self 
     action:@selector(buyCoinsWithIdentifier:)
     forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:coins2];
    
    UIButton *coins3=[[UIButton alloc]init];
    coins3.frame=CGRectMake(199, posY1, 77, 77);
    [coins3 setTag:55];
    UIImage *coins3Image=[UIImage imageNamed:@"7500coins.png"];
    [coins3 setBackgroundImage:coins3Image forState:UIControlStateNormal];
    [coins3 addTarget:self 
     action:@selector(buyCoinsWithIdentifier:)
     forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:coins3];
    
    UIButton *coins4=[[UIButton alloc]init];
    coins4.frame=CGRectMake(25, posY2, 77, 77);
    [coins4 setTag:51];
    UIImage *coins4Image=[UIImage imageNamed:@"15500coins.png"];
    [coins4 setBackgroundImage:coins4Image forState:UIControlStateNormal];
    [coins4 addTarget:self 
     action:@selector(buyCoinsWithIdentifier:)
     forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:coins4];
    
    UIButton *coins5=[[UIButton alloc]init];
    coins5.frame=CGRectMake(112, posY2, 77, 77);
    [coins5 setTag:52];
    UIImage *coins5Image=[UIImage imageNamed:@"31500coins.png"];
    [coins5 setBackgroundImage:coins5Image forState:UIControlStateNormal];
    [coins5 addTarget:self 
     action:@selector(buyCoinsWithIdentifier:)
     forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:coins5];
    
    UIButton *coins6=[[UIButton alloc]init];
    coins6.frame=CGRectMake(199, posY2, 77, 77);
    [coins6 setTag:54];
    UIImage *coins6Image=[UIImage imageNamed:@"50000coins.png"];
    [coins6 setBackgroundImage:coins6Image forState:UIControlStateNormal];
    [coins6 addTarget:self 
     action:@selector(buyCoinsWithIdentifier:)
     forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:coins6];

    UIButton *closeBuyCoinsBtn2=[[UIButton alloc]init];
    UIImage *closeImage2=[UIImage imageNamed:@"closeBtn.png"];
    
    CGRect closeBtnFrame=CGRectMake(265, -5, 40, 40);
    closeBuyCoinsBtn2.frame=closeBtnFrame;
    [closeBuyCoinsBtn2 setBackgroundImage:closeImage2 forState:UIControlStateNormal];
    [closeBuyCoinsBtn2 setTag:56];
    [closeBuyCoinsBtn2 addTarget:self 
                          action:@selector(setViewAlphaToCero)
                forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:closeBuyCoinsBtn2];

}
#pragma mark - alphas
-(void)setViewAlphaToCero{
    [self removeObservers];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    self.alpha=0;
    [UIView commitAnimations];
}
-(void)setViewAlphaToOne{
    [self addObservers];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    self.alpha=1;
    [UIView commitAnimations];
}
#pragma mark - Observers
-(void)addObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:@"ProductsLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productDismissedOnAlert:) name:@"ProductPurchaseFailedWithNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:@"ProductPurchased" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:@"ProductPurchaseFailed" object: nil];
}
-(void)removeObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ProductsLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ProductsLProductPurchaseFailedWithNotificationoaded" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ProductPurchased" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ProductPurchaseFailed" object:nil];
}

#pragma mark- button triggers
-(void)buyCoinsWithIdentifier:(UIButton*)sender{
    /*purchaseID=sender.tag-50;
    hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    [self performSelector:@selector(timeout:) withObject:nil afterDelay:60.0];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    [[PurchaseHelper sharedHelper] requestProducts];*/
    
    /*if (sender.tag==50) {
        NSLog(@"Este botón da la orden para comprar 1000 monedas");
    }
    else if (sender.tag==51) {
        NSLog(@"Este botón da la orden para comprar 3500 monedas");
    }
    else if (sender.tag==52) {
        NSLog(@"Este botón da la orden para comprar 7500 monedas");
    }
    else if (sender.tag==53) {
        NSLog(@"Este botón da la orden para comprar 15500 monedas");
    }
    else if (sender.tag==54) {
        NSLog(@"Este botón da la orden para comprar 31500 monedas");
    }
    else if (sender.tag==55) {
        NSLog(@"Este botón da la orden para comprar 50000 monedas");
    }*/
}
#pragma mark - notification center messages
- (void)productsLoaded:(NSNotification *)notification {
    NSLog(@"products loaded %@",notification.object);
    SKProduct *product = [[PurchaseHelper sharedHelper].products objectAtIndex:purchaseID];
    [[PurchaseHelper sharedHelper] buyProductIdentifier:product.productIdentifier];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //[NSObject cancelPreviousPerformRequestsWithTarget:self];
}
- (void)productDismissedOnAlert:(NSNotification *)notification {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self animated:YES];
    hud=nil;
}
- (void)productPurchased:(NSNotification *)notification {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    NSLog(@"product purchased %@",notification.object);
    [self callPartnerVCMethodUsingString:notification.object];
    hud.labelText = NSLocalizedString(@"Great",nil);
    hud.detailsLabelText = NSLocalizedString(@"Successful Purchase",nil);
    [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:3.0];
}

- (void)productPurchaseFailed:(NSNotification *)notification {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self animated:YES];
    
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notification.object;    
    if (transaction.error.code != SKErrorPaymentCancelled) {    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" 
                                                        message:transaction.error.localizedDescription 
                                                       delegate:nil 
                                              cancelButtonTitle:nil 
                                              otherButtonTitles:@"OK", nil];
        
        [alert show];
    }
}
#pragma mark hud methods
- (void)dismissHUD:(id)arg {
    [MBProgressHUD hideHUDForView:self animated:YES];
    hud = nil;
}
- (void)timeout:(id)arg {
    hud.labelText = NSLocalizedString(@"Timeout",nil);
    hud.detailsLabelText = NSLocalizedString(@"Please try again later",nil);
    //hud.customView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1-bg.png"]];
	hud.mode = MBProgressHUDModeCustomView;
    [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:3.0];
    
}
#pragma mark - partner VC caller
-(void)callPartnerVCMethodUsingString:(NSString*)string{
    NSString *bundle=@"iamstudio";
    NSString *res=@"";
    if ([string isEqualToString:[NSString stringWithFormat:@"com.%@.prizeKing.%@",bundle,@"1000coins"]]) {
        res=@"1000";
    }
    else if ([string isEqualToString:[NSString stringWithFormat:@"com.%@.prizeKing.%@",bundle,@"3500coins"]]) {
        res=@"3500";
    }
    else if ([string isEqualToString:[NSString stringWithFormat:@"com.%@.prizeKing.%@",bundle,@"7500coins"]]) {
        res=@"7500";
    }
    else if ([string isEqualToString:[NSString stringWithFormat:@"com.%@.prizeKing.%@",bundle,@"15500coins"]]) {
        res=@"15500";
    }
    else if ([string isEqualToString:[NSString stringWithFormat:@"com.%@.prizeKing.%@",bundle,@"31500coins"]]) {
        res=@"31500";
    }
    else if ([string isEqualToString:[NSString stringWithFormat:@"com.%@.prizeKing.%@",bundle,@"50000coins"]]) {
        res=@"50000";
    }
    
    if ([contextVC respondsToSelector:@selector(getCurrentCoinsAndAdd:)]) {
        [contextVC performSelector:@selector(getCurrentCoinsAndAdd:) withObject:res];
    }
}
@end
