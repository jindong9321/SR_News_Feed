//
//  NFMainViewController.h
//  NewsFeed
//
//  Created by RDMac on 2015. 9. 25..
//  Copyright (c) 2015년 RDmac. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "NFRoginViewController.h"

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

@class NFRoginViewController;

//*[@id="wrapper"]/aside/div/ul/li[1]/div[1]/span[1]/a/img
//[@class='slimScrollDiv']//div[@class='leftcol']

#define XPATH_QUERY2 @"//html//body//div[@id='wrapper']//aside//div//ul//li[@class='welcome_box']//div[@class='profile_info']//span[@class='profile_img']//a//img"
#define TARGET_URL2 @"http://www.sugarain.kr/dashboard"

@interface NFMainViewController : UIViewController <UIAlertViewDelegate>{
//    NSMutableArray *arrNewsList;
//    NSMutableArray *noarrNewsList;
//    NSMutableArray *nameNewsList;
//    NSString *urlStr;
    NSString *urlStr2;
//    NSMutableArray *linkurl;
//  NSString *urllist;
//    NSMutableArray *arrList;
//    NFRoginViewController *firstView;
    NSUserDefaults *userDefaults;
//    NSMutableData *firstdata;
//    NSMutableData *seconddata;
    NSString *urlneed;

}


@property (strong, nonatomic) NFRoginViewController *loginviewcontroller;

@property (retain, nonatomic) IBOutlet UIWebView *Profile_view;
@property (retain, nonatomic) IBOutlet UIButton *inconnectionButton;

@property (retain, nonatomic) IBOutlet UILabel *usernamelabel;
@property (retain, nonatomic) IBOutlet UILabel *aramLabel;

@property (retain, nonatomic) IBOutlet UISwitch *switchButton;
@property (retain, nonatomic) IBOutlet UITableViewCell *aramSettingCell;

- (IBAction)domainButton_Click:(UIButton *)sender;
- (IBAction)inconnection:(UIButton *)sender;
- (IBAction)switchButton:(id)sender;


@end
