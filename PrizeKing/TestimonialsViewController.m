//
//  TestimonialsTableViewControllerViewController.m
//  PrizeKing
//
//  Created by Andres Abril on 18/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestimonialsViewController.h"

@interface TestimonialsViewController ()

@end

@implementation TestimonialsViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    scrollView=[[UIScrollView alloc]init];
    scrollView.frame=CGRectMake(21, 61, 438, 234);
    scrollView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:scrollView];
    spinner=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame=CGRectMake(0, 0, 20, 20);
    spinner.center=CGPointMake(scrollView.frame.size.width/2, scrollView.frame.size.height/2);
    [scrollView addSubview:spinner];
    [spinner startAnimating];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Loading Testimonials";
    server=[[ServerCommunicator alloc]init];
    server.caller = self;
    [server callServerWithMethod:@"GetTestimonials" andParameter:@"5"];
    
}
-(void)addTestimonial:(int)numberOfTestimonial WithDictionary:(NSDictionary*)dictionary{
    int altoDeCelda=40;
    int position=numberOfTestimonial*altoDeCelda;
    TestimonialCell *cell=[[TestimonialCell alloc]initWithFrame:CGRectMake(0, 0, 438, 43)];
    [cell constructObjectWithDictionary:dictionary inContext:self andPosition:position];
    cell.alpha=0;
    [self animarEntradaDeTestimonials:cell conTiempo:numberOfTestimonial*0.3];
    [scrollView addSubview:cell];
    if (position<234) {
        scrollView.contentSize=CGSizeMake(435, 235);
    }
    else{
        scrollView.contentSize=CGSizeMake(435, numberOfTestimonial*altoDeCelda+altoDeCelda);
    }
}
-(void)animarEntradaDeTestimonials:(UIView*)cell conTiempo:(float)tiempo{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:tiempo];
    cell.alpha=1;
    [UIView commitAnimations];
}
-(IBAction)back:(id)sender{
    [self.navigationController.view.layer addAnimation:[NavAnimations navAlphaAnimation] forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || 
    (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
-(void)irADescripcionConArreglo:(NSMutableArray*)description{
    NSLog(@"%@",[description objectAtIndex:0]);
    SingleTestimonialViewController *stVC=[[SingleTestimonialViewController alloc]init];
    stVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SingleTestimonial"];
    stVC.name=[description objectAtIndex:1];
    stVC.description=[description objectAtIndex:0];
    [self.navigationController pushViewController:stVC animated:YES];
}

-(void)receivedDataFromServer:(id)sender{
    server=sender;
    int i=0;
    for (NSDictionary *dictionary in server.resDic) {
    NSLog(@"Dictionary received %@",dictionary);
    [self addTestimonial:i WithDictionary:dictionary];
        i++;
    }
    if (i==0) {
        //Mensaje de No hay conexión o no se encontró testimonio
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0, 0, 200, 100);
        label.center=CGPointMake(scrollView.frame.size.width/2, scrollView.frame.size.height/2);
        label.text=@"No testimonials found :(";
        [scrollView addSubview:label];
    }
    [spinner stopAnimating];
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    i=0;
}

@end
