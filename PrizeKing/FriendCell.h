//
//  FriendCell.h
//  PrizeKing
//
//  Created by Andrés Abril on 27/07/12.
//
//

#import <UIKit/UIKit.h>
#import "FacebookInviteViewController.h"
#import "CacheImage.h"
@class FacebookInviteViewController;
@interface FriendCell : UIView<UIGestureRecognizerDelegate>{
    NSString *dTag;
    UILabel *checkLabel;
    BOOL flag;
    BOOL isCheck;
    NSThread *athread;
}

@property(nonatomic,retain)UIViewController *ftVC;
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *imageUrl;

-(void)constructObjectWithFriend:(Friend*)friend inContext:(UIViewController*)viewController andPosition:(float)posY andCheck:(BOOL)check andThread:(NSThread*)thread;
-(void)cellInitWithY:(float)y andThread:(NSThread*)thread;
-(void)gotoView;
@end
