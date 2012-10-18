//
//  FriendsTeamVC.h
//  PrizeKing
//
//  Created by Andrés Abril on 27/08/12.
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


@interface FriendsTeamVC : UIViewController{
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
    UILabel *invitationsNumberLabel;
    
    NSThread *thread;
    MBProgressHUD *hud;
    
    CGRect initialFrame;
    CGRect finalFrame;
    
    NSString *leaderID;
    
    ServerCommunicator *server;
    int peticion;//1 para obtener invitaciones, 2 para aceptar, 0 null
}
@property(nonatomic,retain)User *user;

@end