//
//  BidView.h
//  PrizeKing
//
//  Created by Andres Abril on 16/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseHelper.h"
#import "MBProgressHud.h"
@interface BuyCoinsView : UIView{
    UIImageView *bgImageView;
    int purchaseID;
    MBProgressHUD *hud;
    UIViewController *contextVC;
}
-(void)bgInitWithVC:(UIViewController*)VC;
-(void)setViewAlphaToOne;
@end
