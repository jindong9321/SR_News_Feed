//
//  NFWebViewController.h
//  NewsFeed
//
//  Created by RDMac on 2015. 9. 30..
//  Copyright (c) 2015년 RDmac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFRoginViewController.h"

@interface NFWebViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIWebView *Webview;
@property (retain, nonatomic) IBOutlet UIView *WebTopview;


@property (retain, nonatomic) IBOutlet UIImageView *sugaImageView;

- (IBAction)closeButton_Click:(UIButton *)sender;
- (IBAction)domainButton_Click:(UIButton *)sender;

@end
