//
//  UIViewController+NFSRDetailView.m
//  NewsFeed_sugarain
//
//  Created by SBHR on 2015. 10. 3..
//  Copyright © 2015년 seungbin.baik. All rights reserved.
//

#import "NFSRDetailViewController.h"


@interface NFSRDetailViewController () <NSURLConnectionDataDelegate> {

}



@end

@implementation NFSRDetailViewController
@synthesize webView;
@synthesize nfsrtableviewcontroller = _nfsrtableviewcontroller;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        
    }
    return self;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *NotiURL  = [[NSUserDefaults standardUserDefaults] URLForKey:@"detail_url"];
    NSLog(@"\n\n  NotiURL ->>>> %@\n\n", NotiURL);
    NSURLRequest *requestURL = [[NSURLRequest alloc] initWithURL:NotiURL];
    NSLog(@"\n\n  requestURL ->>>> %@\n\n", requestURL);
    [webView loadRequest:requestURL];
    
    // webView
    if(!webView)
    {
        webView = [[UIWebView alloc]init];
    }
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webview
{
    if (webview.isLoading)
        return;
    //    else
    //       _webView.hidden = false;
}


- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    
}

#pragma mark block to auotorotate hybrid webview
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



- (void)dealloc {
    [webView release];
    [super dealloc];
}



#pragma mark alertView attachment file download

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@",request);
    NSString *requestStr = [[request URL] absoluteString];
    NSRange range;
    range = [requestStr rangeOfString:@"http://www.sugarain.kr/attachment/files"];
    
    if(range.location !=NSNotFound)
    {
        [[UIApplication sharedApplication] openURL:[request URL]];
        
    }
    
    return YES;
}

@end

