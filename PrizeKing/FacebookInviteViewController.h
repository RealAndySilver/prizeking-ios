//
//  FacebookTeamViewController.h
//  PrizeKing
//
//  Created by Andrés Abril on 27/07/12.
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
#import "FacebookSingleton.h"


@interface FacebookInviteViewController : UIViewController<FBDialogDelegate,FBSessionDelegate>{
    UIScrollView *scrollView;
    UIScrollView *scrollView2;
    NSMutableArray *rightArray;
    NSMutableArray *idArray;
    UIButton * inviteButton;
    Facebook *facebook;

    UITextView *textView;
    MBProgressHUD *hud;
    NSMutableArray *partnersIdArray;
    ServerCommunicator *server;
}
@property(nonatomic,retain)User *user;

@end
