//
//  FacebookMainVC.h
//  PrizeKing
//
//  Created by Andrés Abril on 11/08/12.
//
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Friend.h"
#import "NavAnimations.h"
#import "FriendCell.h"
#import "MBProgressHud.h"
#import "CacheImage.h"
#import "ServerCommunicator.h"


@interface MyTeamVC : UIViewController<UIAlertViewDelegate>{
    UIScrollView *scrollView;
    UIScrollView *scrollView2;
    NSMutableArray *rightArray;
    NSMutableArray *idArray;
    UIButton * inviteButton;
    UIActivityIndicatorView *spinner;
    UIImageView *friendPic;
    UILabel *friendName;
    
    UITextView *textView;
    UILabel *infoLabel;

    NSThread *thread;
    MBProgressHUD *hud;
    
    CGRect initialFrame;
    CGRect finalFrame;
    
    ServerCommunicator *server;
    int peticion;//1=get partners
    
}
@property(nonatomic,retain)User *user;

@end
