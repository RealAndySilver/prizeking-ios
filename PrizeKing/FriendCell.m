//
//  FriendCell.m
//  PrizeKing
//
//  Created by Andrés Abril on 27/07/12.
//
//

#import "FriendCell.h"

@implementation FriendCell
@synthesize name,imageUrl,ftVC;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)constructObjectWithFriend:(Friend*)friend inContext:(FacebookInviteViewController*)viewController andPosition:(float)posY andCheck:(BOOL)check andThread:(NSThread *)thread{
    name=friend.name;
    imageUrl=[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=small",friend.ID];
    ftVC=viewController;
    //dTag=[friend.ID doubleValue];
    dTag=friend.ID;

    isCheck=check;
    [self cellInitWithY:posY andThread:thread];
}
-(void)cellInitWithY:(float)y andThread:(NSThread*)thread{
    self.frame=CGRectMake(0, y, 200, 36);
    UIImageView *backGround=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backGround.image=[UIImage imageNamed:@"gradientBar.png"];
    [self addSubview:backGround];
    //NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(secondThread) object:nil];
    //athread=[[NSThread alloc]initWithTarget:self selector:@selector(secondThread) object:nil];
    //[athread start];
    
    //[self performSelectorInBackground:@selector(secondThread) withObject:nil];
    [self secondThread];
    UIFont *leFont=[UIFont fontWithName:@"Helvetica" size:10.0];
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 115, 36)];
    nameLabel.backgroundColor=[UIColor clearColor];
    [nameLabel setFont:leFont];
    nameLabel.textColor=[UIColor blackColor];
    nameLabel.text=name;
    
    [self addSubview:nameLabel];
    if (isCheck) {
        checkLabel=[[UILabel alloc]initWithFrame:CGRectMake(170, 8, 20, 20)];
        checkLabel.backgroundColor=[UIColor whiteColor];
        checkLabel.textAlignment=UITextAlignmentCenter;
        checkLabel.layer.cornerRadius=5;
        UIFont *font=[UIFont fontWithName:@"Zapf Dingbats" size:15];
        checkLabel.font=font;
        checkLabel.textColor=[UIColor colorWithWhite:0.9 alpha:0.5];
        checkLabel.text=@"✔";
        
        flag=NO;
        [self addSubview:checkLabel];
    }
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(ClickEventOnCell:)];
    [tapRecognizer setNumberOfTouchesRequired:1];
    [tapRecognizer setDelegate:self];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapRecognizer];
    
}
-(void)secondThread{
    UIImageView *wPic=[[UIImageView alloc]initWithFrame:CGRectMake(3, 3, 30, 30)];
    //wPic.layer.cornerRadius = 4.0;
    //wPic.layer.masksToBounds = YES;
    //[wPic.layer setBorderColor: [[UIColor blackColor] CGColor]];
    //[wPic.layer setBorderWidth: 2.0];
    wPic.contentMode = UIViewContentModeScaleAspectFill;
    [wPic setClipsToBounds:YES];
    wPic.image=[CacheImage getCachedImage:imageUrl];
    [self addSubview:wPic];
}

-(void)thirdThread{
    if (!flag) {
        checkLabel.textColor=[UIColor colorWithWhite:0 alpha:1];
        flag=YES;
        return;
    }
    else{
        checkLabel.textColor=[UIColor colorWithWhite:0.9 alpha:0.5];
        flag=NO;
        return;
    }
}
-(void) ClickEventOnCell:(id) sender{
    if ([ftVC respondsToSelector:@selector(addFriend:)]) {
        Friend *friend=[[Friend alloc]init];
        friend.name=name;
        //friend.ID=[NSString stringWithFormat:@"%.0f",dTag];
        friend.ID=dTag;
        [ftVC performSelector:@selector(addFriend:) withObject:friend];
    }
    if (isCheck) {
        //NSThread *athread=[[NSThread alloc]initWithTarget:self selector:@selector(thirdThread) object:nil];
        //[athread start];
        [self thirdThread];
    }
    
}
@end
