//
//  SingleTestimonialViewController.h
//  PrizeKing
//
//  Created by Andres Abril on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleTestimonialViewController : UIViewController{
    IBOutlet UILabel *winnerNameLabel;
    IBOutlet UITextView *winnerDescriptionTextView;
}
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *description;
@end
