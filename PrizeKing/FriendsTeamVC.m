//
//  FriendsTeamVC.m
//  PrizeKing
//
//  Created by Andrés Abril on 27/08/12.
//
//

#import "FriendsTeamVC.h"

@interface FriendsTeamVC ()

#define anchoScroll 200
@end
@implementation FriendsTeamVC
@synthesize user;

-(void)viewDidLoad{
    [super viewDidLoad];
    initialFrame=CGRectMake(140, 61, anchoScroll, 234);
    finalFrame=CGRectMake(560, 61, anchoScroll, 234);
    server=[[ServerCommunicator alloc]init];
    server.caller=self;
    peticion=0;
    
    scrollView2=[[UIScrollView alloc]init];
    scrollView2.frame=initialFrame;
    scrollView2.backgroundColor=[UIColor colorWithWhite:0.1 alpha:1];
    scrollView2.layer.cornerRadius = 30.0;
    scrollView2.layer.masksToBounds = YES;
    [scrollView2.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [scrollView2.layer setBorderWidth: 2.0];
    scrollView2.alpha=1;
    [self.view addSubview:scrollView2];

    textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, anchoScroll, 180)];
    textView.backgroundColor=[UIColor clearColor];
    textView.textColor=[UIColor whiteColor];
    UIFont *font=[UIFont fontWithName:@"Arial Rounded MT Bold" size:10];
    textView.font=font;
    //[textView setUserInteractionEnabled:NO];
    [textView setEditable:NO];
    //[scrollView2 addSubview:textView];
    
    UIFont *font2=[UIFont fontWithName:@"Verdana-Bold" size:16];
    

    
    inviteButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    inviteButton.frame=CGRectMake(40, 190, 120, 37);
    //[inviteButton setTitle:@"Remove from my team" forState:UIControlStateNormal];
    [inviteButton addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    inviteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [inviteButton setBackgroundImage:[self imageSetWithName:@"removeFriend.png"] forState:UIControlStateNormal];
    [scrollView2 addSubview:inviteButton];

    spinner.frame=CGRectMake(90, 40, 20, 20);
    [scrollView2 addSubview:spinner];
    friendPic=[[UIImageView alloc]initWithFrame:CGRectMake(40, 10, 120, 120)];
    friendPic.layer.cornerRadius = 10.0;
    friendPic.alpha=0;
    friendPic.layer.masksToBounds = YES;
    [friendPic.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [friendPic.layer setBorderWidth: 5.0];
    friendPic.contentMode = UIViewContentModeScaleAspectFill;
    [scrollView2 addSubview:friendPic];
    friendName=[[UILabel alloc]initWithFrame:CGRectMake(10, 135, 180, 45)];
    friendName.backgroundColor=[UIColor clearColor];
    friendName.textAlignment=UITextAlignmentCenter;
    friendName.font=font2;
    friendName.numberOfLines=2;
    friendName.textColor=[UIColor whiteColor];
    [scrollView2 addSubview:friendName];
    inviteButton.alpha=0;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Loading Leader";
    peticion=1;
    [server callServerWithMethod:@"GetUserTeamLeader" andParameter:user.ID];

}
-(UIImage*)imageSetWithName:(NSString*)name{
    UIImage *buttonImageNormal = [UIImage imageNamed:name];
    return buttonImageNormal;
}

-(void)didReceiveMemoryWarning{
    //[super didReceiveMemoryWarning];
    NSLog(@"Mem Warning dude");
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||
    (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(IBAction)back:(id)sender{
    [self.navigationController.view.layer addAnimation:[NavAnimations navAlphaAnimation] forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)remove{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                    message:@"Are you sure you want to leave this team?"
                                                   delegate:self
                                          cancelButtonTitle:@"NO"
                                          otherButtonTitles:@"Yes, I'm sure",nil];
    [alert show];
}
#pragma mark - server call
-(void)receivedDataFromServer:(id)sender{
    server=sender;
    if (peticion==1) {
        peticion=0;
        if (server.resDic) {
            inviteButton.alpha=1;
            leaderID=[server.resDic objectForKey:@"FaceBookId"];
            NSString *friendUrl=[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",leaderID];
            friendPic.image=[CacheImage getCachedImage:friendUrl noThread:nil];
            friendPic.alpha=1;
            friendName.text=[server.resDic objectForKey:@"Name"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            friendPic.alpha=0;
            inviteButton.alpha=0;
            friendName.text=@"No team";
        }
        
    }
    else if(peticion==2){
        peticion=0;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[server.resDic objectForKey:@"Response"]boolValue]) {
            friendPic.alpha=0;
            inviteButton.alpha=0;
            friendName.text=@"No team";
        }
    }
}

#pragma mark - alert view delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        peticion=2;
        NSString *parameters=[NSString stringWithFormat:@"%@/%@",leaderID,user.ID];
        [server callServerWithMethod:@"AutoRemoveUserFromTeam" andParameter:user.ID];
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText=@"Removing from team";
    }
}
@end
