//
//  NFSettingViewController.h
//  NewsFeed
//
//  Created by RDMac on 2015. 11. 20..
//  Copyright © 2015년 RDmac. All rights reserved.
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

#import "REFrostedViewController.h"

@class NFRoginViewController;

#define XPATH_QUERY2 @"//html//body//div[@id='wrapper']//aside//div//ul//li[@class='welcome_box']//div[@class='profile_info']//span[@class='profile_img']//a//img"
#define TARGET_URL2 @"http://www.sugarain.kr/dashboard"


@interface NFSettingViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>{

    NSString *urlStr2;

    NSUserDefaults *userDefaults;

    NSString *urlneed;
    
}

@property (strong, nonatomic) NFRoginViewController *loginviewcontroller;

@end
