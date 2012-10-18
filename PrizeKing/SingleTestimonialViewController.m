//
//  SingleTestimonialViewController.m
//  PrizeKing
//
//  Created by Andres Abril on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SingleTestimonialViewController.h"

@interface SingleTestimonialViewController ()

@end

@implementation SingleTestimonialViewController
@synthesize name,description;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    winnerNameLabel.text=name;
    winnerDescriptionTextView.text=description;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
