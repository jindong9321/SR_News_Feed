//
//  NFRoginViewController.h
//  NewsFeed
//
//  Created by RDMac on 2015. 9. 25..
//  Copyright (c) 2015년 RDmac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIAuthenticationDialog.h"
#import "ASICacheDelegate.h"
#import "ASIDataCompressor.h"
#import "ASIDataDecompressor.h"
#import "ASIDownloadCache.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequestConfig.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASINetworkQueue.h"
#import "ASIProgressDelegate.h"
#import "ASIWebPageRequest.h"
#import "ASIInputStream.h"

#import "NFSRTableViewController.h"
#import "NFWebViewController.h"
#import "SRManagerKit.h"
#import "SRXMLRPCManager.h"

#import <FacebookSDK/FacebookSDK.h>
#import <Google/SignIn.h>

@class SRXMLRPCManager;
@class NFSRTableViewController;

@interface NFRoginViewController : UIViewController <UITextFieldDelegate, FBLoginViewDelegate, GIDSignInUIDelegate>{
    NSString *urlStr;
    NFSRTableViewController *tableView;
    NSUserDefaults *userDefaults;
    
    NSString *app_id;
    NSString *hextoken;
}


@property (strong, nonatomic) IBOutlet UIView *BGview;

@property (retain, nonatomic) IBOutlet UITextField *textID;
@property (retain, nonatomic) IBOutlet UIImageView *MainImageView;
@property (retain, nonatomic) IBOutlet UITextField *textPassword;
@property (retain, nonatomic) IBOutlet UIButton *connectionButton;
@property (retain, nonatomic) IBOutlet UIButton *joinButton;

- (IBAction)backgroudTouch:(id)sender;

@property (retain, nonatomic) IBOutlet UIButton *loginbutton;  //facebook loginbutton
- (IBAction)FB_loginButton_Click:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *gg_loginbutton;
- (IBAction)gg_loginButton_Click:(id)sender;



@property (retain, nonatomic) NSUserDefaults *saveID;
@property (retain, nonatomic) NSUserDefaults *savePW;
@property (retain, nonatomic) NSUserDefaults *member_id;
@property (retain,nonatomic) NSUserDefaults *SNS_user_id;
@property (retain,nonatomic) NSUserDefaults *SNS_user_name;
@property (retain,nonatomic) NSUserDefaults *SNS_user_email;
@property (retain,nonatomic) NSUserDefaults *user_nameString;
@property (retain,nonatomic) NSUserDefaults *SNS_link;
@property (retain,nonatomic) NSUserDefaults *SNS_user_Token;

@property(strong, nonatomic) SRXMLRPCManager *srxmlrpcmanager;
@property(strong, nonatomic)NFSRTableViewController *NFSRtableViewController;




- (IBAction)connectionButton_Click:(UIButton *)sender;
- (IBAction)joinButton_Click:(UIButton *)sender;

- (void)userLoggedOut;
-(void) toggleAuthUI;



@end
