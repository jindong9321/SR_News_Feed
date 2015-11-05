//
//  UIViewController+NFSRTableView.h
//  NewsFeed_sugarain
//
//  Created by SBHR on 2015. 10. 3..
//  Copyright © 2015년 seungbin.baik. All rights reserved.
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
#import "NFRoginViewController.h"
#import "NFMainViewController.h"


@class NFSRDetailViewController;
@class NFSRLoginViewController;

#define XPATH_QUERY @"//html//body//div[@id='wrapper']//div[@class='page_wrapper']//div[@id='content']//div//div[@class='feeds_notice_body panel panel-default']//div//div[@class='notice']//ul//li//a"

#define TARGET_URL @"http://www.sugarain.kr/feeds"


@interface NFSRTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *arrNewsList;
    NSMutableArray *noarrNewsList;
    NSMutableArray *nameNewsList;
    NSMutableArray *linkurl;
    NSMutableArray *arrList;
    NSMutableData *Original_firstdata;
    NSMutableData *added_seconddata;
    
    NSString *urlStr;
    NSString *urlStr2;
    
    NSString *removeNewLine;
    NSString *urllist;
    
    NFSRLoginViewController *firstView;
    NSUserDefaults *userDefaults;
    
    
    
}

@property (strong, nonatomic) NFSRDetailViewController *detailViewController;
@property (strong, nonatomic) NFSRLoginViewController *loginviewcontroller;
@property (retain, nonatomic) IBOutlet UIButton *logOut;
@property (retain, nonatomic) NSUserDefaults *detail_Url;

-(void) resetData;

@end