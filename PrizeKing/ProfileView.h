//
//  ProfileView.h
//  PrizeKing
//
//  Created by Andrés Abril on 31/07/12.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHud.h"
#import "User.h"
#import "ServerCommunicator.h"
#import "IAmCoder.h"

@interface ProfileView : UIView<UIGestureRecognizerDelegate>{
    UIImageView *bgImageView;
    int purchaseID;
    MBProgressHUD *hud;
    UIViewController *contextVC;
    User *profileUser;
    
    UIImageView *profileImageView;
    UILabel *profileNameLabel;
    UILabel *mailLabel;
    UILabel *coinsText;
    UILabel *totalCoinsCollectedText;
    UILabel *auctionsWonText;
    UILabel *auctionsPlayedText;
    
    NSNumberFormatter *numberFormatter;
    
    ServerCommunicator *server;

}
-(void)bgInitWithVC:(UIViewController*)VC andUser:(User*)user;
-(void)updateUserInfo;
-(void)setViewAlphaToOne;
@end