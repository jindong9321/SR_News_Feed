//
//  NFPikerViewController.h
//  NewsFeed
//
//  Created by RDMac on 2015. 11. 18..
//  Copyright © 2015년 RDmac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFPikerViewController : UIViewController
@property (retain, nonatomic) IBOutlet UILabel *start_time;
@property (retain, nonatomic) IBOutlet UILabel *end_time;

@property (retain, nonatomic) IBOutlet UITextField *start_timeText;
@property (retain, nonatomic) IBOutlet UITextField *end_timeText;

- (IBAction)start_timeText_Button:(id)sender;
- (IBAction)end_timeText_Button:(id)sender;



@end
