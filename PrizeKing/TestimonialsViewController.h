//
//  TestimonialsTableViewControllerViewController.h
//  PrizeKing
//
//  Created by Andres Abril on 18/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestimonialCell.h"
#import "SingleTestimonialViewController.h"
#import "NavAnimations.h"
#import "ServerCommunicator.h"
#import "MBProgressHud.h"

@interface TestimonialsViewController : UIViewController{
    UIScrollView *scrollView;
    ServerCommunicator *server;
    UIActivityIndicatorView *spinner;
    
    MBProgressHUD *hud;
}
-(void)irADescripcionConArreglo:(NSMutableArray*)description;
@end
