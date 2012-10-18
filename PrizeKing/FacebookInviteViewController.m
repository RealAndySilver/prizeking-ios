//
//  FacebookTeamViewController.m
//  PrizeKing
//
//  Created by Andrés Abril on 27/07/12.
//
//

#import "FacebookInviteViewController.h"

@interface FacebookInviteViewController ()

#define anchoScroll 200
@end
@implementation FacebookInviteViewController
@synthesize user;

-(void)viewDidLoad{
    [super viewDidLoad];
    scrollView=[[UIScrollView alloc]init];
    scrollView.frame=CGRectMake(21, 61, anchoScroll, 234);
    scrollView.backgroundColor=[UIColor whiteColor];
    scrollView.layer.cornerRadius = 5.0;
    scrollView.layer.masksToBounds = YES;
    [scrollView.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [scrollView.layer setBorderWidth: 2.0];
    [self.view addSubview:scrollView];
    
    scrollView2=[[UIScrollView alloc]init];
    scrollView2.frame=CGRectMake(260, 61, anchoScroll, 180);
    scrollView2.backgroundColor=[UIColor blackColor];
    scrollView2.layer.cornerRadius = 5.0;
    scrollView2.layer.masksToBounds = YES;
    [scrollView2.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [scrollView2.layer setBorderWidth: 2.0];
    [self.view addSubview:scrollView2];
    
    rightArray=[[NSMutableArray alloc]init];
    idArray=[[NSMutableArray alloc]init];
    partnersIdArray=[[NSMutableArray alloc]init];

    if (![user.partnersDic isKindOfClass:[NSNull class]]) {
        for (NSDictionary *dic  in user.partnersDic) {
            [partnersIdArray addObject:[dic objectForKey:@"FaceBookId"]];
        }
    }
    
    server=[[ServerCommunicator alloc]init];
    server.caller=self;

    textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, anchoScroll, 180)];
    textView.backgroundColor=[UIColor clearColor];
    textView.textColor=[UIColor whiteColor];
    UIFont *font=[UIFont fontWithName:@"Arial Rounded MT Bold" size:10];
    textView.font=font;
    //[textView setUserInteractionEnabled:NO];
    [textView setEditable:NO];
    [scrollView2 addSubview:textView];
    
    UIFont *font2=[UIFont fontWithName:@"Verdana-Bold" size:12];
    inviteButton=[UIButton buttonWithType:UIButtonTypeCustom];
    inviteButton.titleLabel.font=font2;
    inviteButton.frame=CGRectMake(285, 245, 150, 46);
    [inviteButton setTitle:@"Invite" forState:UIControlStateNormal];
    [inviteButton addTarget:self action:@selector(invite) forControlEvents:UIControlEventTouchUpInside];
    inviteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [inviteButton setBackgroundImage:[self imageSetWithName:@"inviteButton.png"] forState:UIControlStateNormal];
    [self.view addSubview:inviteButton];
    
    [self buttonToggle];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Loading Friends";
    [self performSelector:@selector(startCall) withObject:nil afterDelay:0.1];
	// Do any additional setup after loading the view.
}
-(UIImage*)imageSetWithName:(NSString*)name{
    UIImage *buttonImageNormal = [UIImage imageNamed:name];
    return buttonImageNormal;
}
-(void)buttonToggle{
    if (idArray.count>0) {
        inviteButton.alpha=1;
        inviteButton.enabled=YES;
        NSString *title=@"";
        if (idArray.count==1) {
            title=[NSString stringWithFormat:@"Send Invitation"];
        }
        else{
            title=[NSString stringWithFormat:@"Send %i Invitations",idArray.count];
        }
        [inviteButton setTitle:title forState:UIControlStateNormal];
    }
    else{
        inviteButton.alpha=0.5;
        inviteButton.enabled=NO;
        [inviteButton setTitle:@"Invite" forState:UIControlStateNormal];
    }
}
-(void)startCall{
    int i=0;
    for (Friend *friend in user.friendsList) {
        //Arreglo temporal, reemplazar por el que llega de la lista de partners
        if ([partnersIdArray containsObject:friend.ID]) {
            
        }
        else{
            [self addFriend:i WithFriend:friend];
            i++;
        }
    }
    NSLog(@"i = %i",i);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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

#pragma mark -  friend creation
-(void)addFriend:(int)numberOfFriend WithFriend:(Friend*)friend{
    int altoDeCelda=40;
    int position=numberOfFriend*altoDeCelda;
    float alturaScrollview=numberOfFriend*altoDeCelda+altoDeCelda;
    FriendCell *cell=[[FriendCell alloc]initWithFrame:CGRectMake(0, 0, anchoScroll, 43)];
    NSThread *thread=[[NSThread alloc]init];
    
    [cell constructObjectWithFriend:friend inContext:self andPosition:position andCheck:YES andThread:thread];
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
    NSInteger index = [rightArray indexOfObject:friend.name];
    if (index == NSNotFound) {
        [rightArray addObject:friend.name];
        [idArray addObject:friend.ID];
    }
    else{
        [rightArray removeObject:friend.name];
        [idArray removeObject:friend.ID];
    }
    NSString *string=@"";
    for (int i=0; i<[rightArray count]; i++) {
        string=[string stringByAppendingString:[NSString stringWithFormat:@"·%@\n",[rightArray objectAtIndex:i]]];
    }
    textView.text=string;
    [textView scrollRangeToVisible:NSMakeRange([textView.text length], 0)];
    [self buttonToggle];
    NSLog(@"stringed %@ id count %i",string,idArray.count);
}
-(void)invite{
    NSString *string=@"";
    for (int i=0; i<idArray.count; i++) {
        string=[string stringByAppendingString:[NSString stringWithFormat:@"%@,",[idArray objectAtIndex:i]]];
    }
    NSLog(@"Inviting... %@",string);
    NSString *newString = [NSString stringWithFormat:@"%@/%@remove",user.ID,string];
    newString = [newString stringByReplacingOccurrencesOfString:@",remove" withString:@""];
    [server callServerWithMethod:@"AddUserToTeam" andParameter:newString];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Sending Invitations";
    
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    [params setObject:@"Check out this awesome app." forKey:@"message"];
    if([idArray count] != 0){
        NSString * stringOfFriends = [idArray componentsJoinedByString:@","];
        [params setObject:stringOfFriends forKey:@"to"];
        NSLog(@"%@", params);
    }
    
    // show the request dialog
    [[Facebook shared] dialog:@"apprequests" andParams:params andDelegate: nil];
    
    
    
}

#pragma mark - server call
-(void)receivedDataFromServer:(id)sender{
    server=sender;
    NSLog(@"response %@",server.resDic);
    BOOL boolServer=[[server.resDic objectForKey:@"Response"]boolValue];
    if (boolServer){
        [self.navigationController popViewControllerAnimated:YES];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)receivedDataFromServerWithError:(id)sender{
    server=sender;
    [self bidHudOffError];
}
-(void)bidHudOffError{
    hud.labelText = NSLocalizedString(@"Error",nil);
    hud.detailsLabelText = NSLocalizedString(@"Please try again.",nil);
	hud.mode = MBProgressHUDModeCustomView;
    [self performSelector:@selector(bidHudHide) withObject:nil afterDelay:1.5];
}
-(void)bidHudHide{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
@end
