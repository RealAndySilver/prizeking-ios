//
//  FacebookTeamViewController.m
//  PrizeKing
//
//  Created by Andrés Abril on 27/07/12.
//
//

#import "MyTeamVC.h"

@interface MyTeamVC ()

#define anchoScroll 200
@end
@implementation MyTeamVC
@synthesize user;

-(void)viewDidLoad{
    [super viewDidLoad];
    initialFrame=CGRectMake(260, 61, anchoScroll, 234);
    finalFrame=CGRectMake(560, 61, anchoScroll, 234);
    
    
    server=[[ServerCommunicator alloc]init];
    server.caller=self;
    [self getPartners];
    scrollView=[[UIScrollView alloc]init];
    scrollView.frame=CGRectMake(21, 61, anchoScroll, 234);
    scrollView.backgroundColor=[UIColor whiteColor];
    scrollView.layer.cornerRadius = 5.0;
    scrollView.layer.masksToBounds = YES;
    [scrollView.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [scrollView.layer setBorderWidth: 2.0];
    scrollView.alpha=0;
    [self.view addSubview:scrollView];
    
    scrollView2=[[UIScrollView alloc]init];
    scrollView2.frame=initialFrame;
    scrollView2.backgroundColor=[UIColor colorWithWhite:0.1 alpha:1];
    scrollView2.layer.cornerRadius = 30.0;
    scrollView2.layer.masksToBounds = YES;
    [scrollView2.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [scrollView2.layer setBorderWidth: 2.0];
    scrollView2.alpha=0;
    [self.view addSubview:scrollView2];
    
    rightArray=[[NSMutableArray alloc]init];
    idArray=[[NSMutableArray alloc]init];
    
    textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, anchoScroll, 180)];
    textView.backgroundColor=[UIColor clearColor];
    textView.textColor=[UIColor whiteColor];
    UIFont *font=[UIFont fontWithName:@"Arial Rounded MT Bold" size:10];
    textView.font=font;
    //[textView setUserInteractionEnabled:NO];
    [textView setEditable:NO];
    //[scrollView2 addSubview:textView];
    
    UIFont *font3=[UIFont fontWithName:@"Arial Rounded MT Bold" size:18];
    UIFont *font2=[UIFont fontWithName:@"Verdana-Bold" size:16];


    CGRect infoFrame=CGRectMake(0, 65, 200, 100);
    infoLabel=[[UILabel alloc]initWithFrame:infoFrame];
    infoLabel.numberOfLines=4;
    infoLabel.font=font3;
    infoLabel.backgroundColor=[UIColor blackColor];
    infoLabel.textAlignment=UITextAlignmentCenter;
    infoLabel.textColor=[UIColor whiteColor];
    infoLabel.layer.cornerRadius = 4.0;
    infoLabel.layer.masksToBounds = YES;
    [infoLabel.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [infoLabel.layer setBorderWidth: 2.0];
    [scrollView2 addSubview:infoLabel];
    
    inviteButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    inviteButton.frame=CGRectMake(40, 190, 120, 37);
    //[inviteButton setTitle:@"Remove from my team" forState:UIControlStateNormal];
    [inviteButton addTarget:self action:@selector(deleteUserFromTeam) forControlEvents:UIControlEventTouchUpInside];
    inviteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [inviteButton setBackgroundImage:[self imageSetWithName:@"removeFriend.png"] forState:UIControlStateNormal];
    [scrollView2 addSubview:inviteButton];
    
    spinner=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
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
    [self buttonToggle];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Loading Friends";
    //[self performSelector:@selector(startCall) withObject:nil afterDelay:0.0];
    //[self startCall];
    //[self performSelectorInBackground:@selector(startCall) withObject:nil ];
}
-(UIImage*)imageSetWithName:(NSString*)name{
    UIImage *buttonImageNormal = [UIImage imageNamed:name];
    return buttonImageNormal;
}
-(void)buttonToggle{
    if (idArray.count==1) {
        inviteButton.alpha=1;
        inviteButton.enabled=YES;
        NSString *title=@"";
        infoLabel.text=@"";
        infoLabel.alpha=0;
        friendName.alpha=1;
        [inviteButton setTitle:title forState:UIControlStateNormal];
    }
    else{
        //inviteButton.alpha=0;
        inviteButton.enabled=NO;
        friendName.alpha=0;
        infoLabel.text=@"Tap to choose and remove any member of your team.";
        infoLabel.alpha=1;
    }
}
-(void)startCall{
    int i=0;
    for (Friend *friend in user.friendsList) {
        [self addFriend:i WithFriend:friend];
        i++;
    }
    NSLog(@"i = %i",i);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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

-(void)animarEntradaDeFriends:(UIView*)cell conTiempo:(float)tiempo{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:tiempo];
    cell.alpha=1;
    [UIView commitAnimations];
}
-(void)animarSalidaDeView:(UIView*)view conTiempo:(float)tiempo yFrame:(CGRect)frame{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:tiempo];
    view.frame=frame;
    [UIView commitAnimations];
}

#pragma mark -  friend creation
-(void)addFriend:(int)numberOfFriend WithFriend:(Friend*)friend{
    int altoDeCelda=40;
    int position=numberOfFriend*altoDeCelda;
    float alturaScrollview=numberOfFriend*altoDeCelda+altoDeCelda;
    FriendCell *cell=[[FriendCell alloc]initWithFrame:CGRectMake(0, 0, anchoScroll, 43)];
    [cell constructObjectWithFriend:friend inContext:self andPosition:position andCheck:NO andThread:nil];
    cell.alpha=0;
    [self animarEntradaDeFriends:cell conTiempo:numberOfFriend*0];
    if (alturaScrollview<=scrollView.frame.size.height) {
        scrollView.contentSize=CGSizeMake(anchoScroll, scrollView.frame.size.height+1);
    }
    else{
        scrollView.contentSize=CGSizeMake(anchoScroll, alturaScrollview);
    }
    [scrollView addSubview:cell];
}

-(void)addFriend:(Friend*)friend{
    [spinner startAnimating];
    [idArray removeAllObjects];
    [self buttonToggle];
    friendPic.alpha=0;
    [self animarSalidaDeView:scrollView2 conTiempo:0.5 yFrame:finalFrame];
    //NSThread *athread=[[NSThread alloc]initWithTarget:self selector:@selector(secondThread:) object:friend];
    //[athread start];
    [self performSelectorInBackground:@selector(secondThread:) withObject:friend];
}

-(void)secondThread:(Friend*)friend{
    [idArray addObject:friend.ID];
    //NSString *url=[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",friend.ID];
    //friendPic.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    friendName.text=@"";
    friendPic.image=nil;
    friendPic.image=[CacheImage getCachedImage:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",friend.ID] noThread:nil];
    friendName.text=friend.name;
    friendPic.alpha=1;
    [self buttonToggle];
    [self animarSalidaDeView:scrollView2 conTiempo:0.5 yFrame:initialFrame];
}
-(void)getPartners{
    peticion=1;
    [server callServerWithMethod:@"GetUserPartners" andParameter:user.ID];
}
-(void)deleteUserFromTeam{
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                    message:@"Are you sure you want to remove this friend from your team?"
                                                   delegate:self
                                          cancelButtonTitle:@"NO"
                                          otherButtonTitles:@"Yes, I'm sure",nil];
    [alert show];
}
-(void)kick{
    /*NSString *string=@"";
    for (int i=0; i<idArray.count; i++) {
        string=[string stringByAppendingString:[NSString stringWithFormat:@"%@",[idArray objectAtIndex:i]]];
    }
    NSLog(@"Removing... %@",string);
    
    NSString *str = @"1232348778932|372189372190|678234698712349782314|2346783246781|0987681234|2347890234|8dhsjkdhjad9879a87d";
    NSMutableArray *target = [NSMutableArray array];
    NSScanner *scanner = [NSScanner scannerWithString:str];
    NSString *tmp;
    
    while ([scanner isAtEnd] == NO){
        [scanner scanUpToString:@"|" intoString:&tmp];
        //if ([scanner isAtEnd] == NO)
        [target addObject:tmp];
        [scanner scanString:@"|" intoString:NULL];
    }
    NSLog(@"%@", target);*/
}
-(void)receivedDataFromServer:(id)sender{
    server=sender;
    if (peticion==1) {
        [[scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        int i=0;
        for (NSDictionary *dic in server.resDic) {
            Friend *friend=[[Friend alloc]init];
            friend.name=[dic objectForKey:@"Name"];
            friend.ID=[dic objectForKey:@"FaceBookId"];
            [self addFriend:i WithFriend:friend];
            i++;
        }
        if (i==0) {
            UIFont *leFont=[UIFont fontWithName:@"Helvetica" size:18.0];
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 400, 50)];
            label.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
            label.textAlignment=UITextAlignmentCenter;
            label.numberOfLines=2;
            label.font=leFont;
            label.textColor=[UIColor whiteColor];
            label.backgroundColor=[UIColor clearColor];
            label.text=@"There are no members on your team";
            [self.view addSubview:label];
        }
        else if (i>0) {
            user.partnersDic=server.resDic;
            scrollView.alpha=1;
            scrollView2.alpha=1;
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        i=0;
        peticion=0;
        return;
    }
    else if (peticion==2){
        peticion=0;
        [self getPartners];
    }
    
}

#pragma mark - alert view delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        peticion=2;
        NSString *parameters=[NSString stringWithFormat:@"%@/%@",user.ID,[idArray objectAtIndex:0]];
        [server callServerWithMethod:@"DeleteUserFromTeam" andParameter:parameters];
        NSLog(@"delete %@",[idArray objectAtIndex:0]);
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText=@"Removing Friend";
        [self animarSalidaDeView:scrollView2 conTiempo:0.3 yFrame:finalFrame];
    }
}
@end
