//
//  FacebookMainVC.m
//  PrizeKing
//
//  Created by Andrés Abril on 11/08/12.
//
//

#import "FacebookMainVC.h"

@interface FacebookMainVC ()

@end


@implementation FacebookMainVC
@synthesize user;

-(void)viewDidLoad{
    [super viewDidLoad];
    	// Do any additional setup after loading the view.
    [self startButtons];
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
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

-(void)animarEntradaDeFriends:(UIView*)cell conTiempo:(float)tiempo{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:tiempo];
    cell.alpha=1;
    [UIView commitAnimations];
}
-(void)startButtons{
    int buttonWidth=150;
    int buttonHeight=103;
    int buttonMargin=70;


    UIButton *myTeam=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    myTeam.frame=CGRectMake(buttonMargin, 70, buttonWidth, buttonHeight);
    myTeam.tag=10;
    //[myTeam setTitle:@"My Team" forState:UIControlStateNormal];
    [myTeam addTarget:self action:@selector(goToNextVC:) forControlEvents:UIControlEventTouchUpInside];
    myTeam.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [myTeam setBackgroundImage:[self imageSetWithName:@"myTeam.png"] forState:UIControlStateNormal];
    [self.view addSubview:myTeam];
    
    UIButton *invite=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    invite.frame=CGRectMake(buttonMargin, 170, buttonWidth, buttonHeight);
    invite.tag=11;
    //[invite setTitle:@"Invite" forState:UIControlStateNormal];
    [invite addTarget:self action:@selector(goToNextVC:) forControlEvents:UIControlEventTouchUpInside];
    invite.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [invite setBackgroundImage:[self imageSetWithName:@"inviteFriends.png"] forState:UIControlStateNormal];
    [self.view addSubview:invite];
    
    UIButton *Friendsteam=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    Friendsteam.frame=CGRectMake((buttonMargin*1.5)+buttonWidth, 70, buttonWidth, buttonHeight);
    Friendsteam.tag=12;
    //[Friendsteam setTitle:@"Member Of" forState:UIControlStateNormal];
    [Friendsteam addTarget:self action:@selector(goToNextVC:) forControlEvents:UIControlEventTouchUpInside];
    Friendsteam.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [Friendsteam setBackgroundImage:[self imageSetWithName:@"friendsTeam.png"] forState:UIControlStateNormal];
    [self.view addSubview:Friendsteam];
    
    UIButton *invitations=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    invitations.frame=CGRectMake((buttonMargin*1.5)+buttonWidth, 170, buttonWidth, buttonHeight);
    invitations.tag=13;
    //[invitations setTitle:@"Invitations" forState:UIControlStateNormal];
    [invitations addTarget:self action:@selector(goToNextVC:) forControlEvents:UIControlEventTouchUpInside];
    invitations.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [invitations setBackgroundImage:[self imageSetWithName:@"myInvitations.png"] forState:UIControlStateNormal];
    [self.view addSubview:invitations];
}
-(UIImage*)imageSetWithName:(NSString*)name{
    UIImage *buttonImageNormal = [UIImage imageNamed:name];
    return buttonImageNormal;
}
-(void)goToNextVC:(UIButton*)sender{
    NSLog(@"Tag vc %i",sender.tag);
    
    if (sender.tag==10) {
        MyTeamVC *ftVC=[[MyTeamVC alloc]init];
        ftVC=[self.storyboard instantiateViewControllerWithIdentifier:@"MyTeam"];
        ftVC.user=user;
        [self.navigationController pushViewController:ftVC animated:NO];
    }
    else if(sender.tag==11){
        FacebookInviteViewController *ftVC=[[FacebookInviteViewController alloc]init];
        ftVC=[self.storyboard instantiateViewControllerWithIdentifier:@"FacebookInvite"];
        ftVC.user=user;
        [self.navigationController pushViewController:ftVC animated:NO];
    }
    else if(sender.tag==12){
        FriendsTeamVC *ftVC=[[FriendsTeamVC alloc]init];
        ftVC=[self.storyboard instantiateViewControllerWithIdentifier:@"FriendsTeam"];
        ftVC.user=user;
        [self.navigationController pushViewController:ftVC animated:NO];
    }
    else if(sender.tag==13){
        MyInvitations *ftVC=[[MyInvitations alloc]init];
        ftVC=[self.storyboard instantiateViewControllerWithIdentifier:@"MyInvitations"];
        ftVC.user=user;
        [self.navigationController pushViewController:ftVC animated:NO];
    }
}
@end
