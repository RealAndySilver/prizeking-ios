//
//  LoginViewController.h
//  PrizeKing
//
//  Created by Andres Abril on 18/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenuViewController.h"
#import "FacebookSingleton.h"
#import "User.h"
#import "FileSaver.h"
#import "Friend.h"
#import "ServerCommunicator.h"
#import "IAmCoder.h"
#import "CacheImage.h"
//#import "FBRequest.h"


@interface LoginViewController : UIViewController<FBSessionDelegate,FBRequestDelegate,FBDialogDelegate>{
    MainMenuViewController *mVC;
    Facebook *facebook;
    FileSaver *file;
    NSMutableArray *friendsList;
    NSMutableArray *friendsListInstalled;
    NSMutableArray *friendsListNOTInstalled;

    UIActivityIndicatorView *spinner;
    NSString *facebookId;
    NSString *deviceToken;
    NSString *firstName;
    NSString *lastName;
    NSString *eMail;
    NSString *imageURL;
    IBOutlet UILabel *loadingLabel;
    IBOutlet UIButton *loginButton;

    ServerCommunicator *server;
    int peticion;//0 null, 1 comprobando, 2 creando usuario, 3 creando device
}
@property (nonatomic, retain) Facebook *facebook;
@end
