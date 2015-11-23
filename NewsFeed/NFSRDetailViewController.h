//
//  UIViewController+NFSRDetailView.h
//  NewsFeed_sugarain
//
//  Created by SBHR on 2015. 10. 3..
//  Copyright © 2015년 seungbin.baik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFSRTableViewController.h"

@class NFSRTableViewController;

@interface NFSRDetailViewController : UIViewController <UIWebViewDelegate, UIAlertViewDelegate>
{
    
}



@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NFSRTableViewController *nfsrtableviewcontroller;
- (IBAction)domainButton_Click:(id)sender;

@end

