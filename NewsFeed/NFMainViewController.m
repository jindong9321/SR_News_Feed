//
//  NFMainViewController.m
//  NewsFeed
//
//  Created by RDMac on 2015. 9. 25..
//  Copyright (c) 2015년 RDmac. All rights reserved.
//

#import "NFMainViewController.h"
#import <UIKit/UIStringDrawing.h>
#import "TFHpple.h"
#import "Tutorial.h"
#import "Contributor.h"
#import "QuartzCore/QuartzCore.h"



@interface NFMainViewController ()

@end

@implementation NFMainViewController

@synthesize usernamelabel;
@synthesize roginviewcontroller = _roginviewcontroller;

//NSUserDefaults Load
+ (id) loadFromUserDefaults:(id) key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    id val = nil;
    if (userDefaults && key) {
        val = [userDefaults objectForKey:key];
    }
    return val;
}

- (void)load_img
{
    
    NSURL *url = [NSURL URLWithString:@"http://www.sugarain.kr/login/accounts/sns_do_login"];
    NSURL *url_1;
    ASIFormDataRequest *request;
    
    NSLog(@"table_url scheme => %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"url_scheme"]);
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"url_scheme" ] == nil ){
        url_1 = [NSURL URLWithString:@"http://www.sugarain.kr/login/accounts/do_login"];
        request = [ASIFormDataRequest requestWithURL:url_1];
        [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"saveID"] forKey:@"userid"];
        [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"textPW"] forKey:@"passwd"];
        
        
    }else{
        //         httpUrlCon.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        NSString *token = @"CAAMfZB1boHKUBADbpH7dDxTuD6CfvrDf07CsMMM16AzM3FZCSSPzJeG2WPIXkq1xwdEONxR1ZCap6yB7Hhfyw5dVzjwSvEojbWke5BpTsHhBSt8byAjsDou5l5n1LZBQYqOcJVtNWjehtZACGzDTGGM1zl7C2rGIUCgoMm9PP7ydRH7ZBL2P5QiMNPJXZAi2rXaJjomPTZB82xA0rLjOK6Aj";
        
        request = [ASIFormDataRequest requestWithURL:url];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [request setPostValue:@"facebook" forKey:@"sns"];
        [request setPostValue:[defaults objectForKey:@"FB_user_id"]forKey:@"snsid"];
        [request setPostValue:[defaults objectForKey:@"FB_user_name"]forKey:@"name"];
        [request setPostValue:[defaults objectForKey:@"user_email"] forKey:@"email"];
        [request setPostValue:@"https://graph.facebook.com/824671480985431/picture?type=large" forKey:@"picture"];
        [request setPostValue:token forKey:@"token"];
        [request setResponseEncoding:NSUTF8StringEncoding];
        
        
        //        NSString *contentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded"];
        //        [request setPostValue:contentType forKey:@"Content-Type"];
        //        [request setPostValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
    }

    [request setDelegate:self];
    [request startSynchronous];
    [request setCompletionBlock:^{
        [request responseString];
        
    }];
    [request setFailedBlock:^{
        
    }];
    
    
    
    NSString *path=@"";
    NSError *error;
    NSString *stringFromURL = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://sugarain.kr/dashboard"] encoding:NSUTF8StringEncoding error:&error];
    if(stringFromURL == nil)
    {
        NSLog(@"Error reading URL at %@\n%@", path, [error localizedFailureReason]);
        
    }
    
    NSData *data = [stringFromURL dataUsingEncoding:NSUnicodeStringEncoding];
    
    //Create parser // 저장
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
    
    NSArray *elements=[xpathParser searchWithXPathQuery:XPATH_QUERY2];
    
    for(int i=0;i<[elements count];i++)
    {
        
        NSLog(@"elements_count[%d], %@",i,[[elements objectAtIndex:i] content]);
        
        NSLog(@"2 %@", [[[elements objectAtIndex:i]attributes]valueForKey:@"pagespeed_lazy_src"]);
        
         urlneed = [[[elements objectAtIndex:i]attributes]valueForKey:@"pagespeed_lazy_src"];
     
         if(urlneed==nil){
            urlneed = [[[elements objectAtIndex:i]attributes]valueForKey:@"src"];
        }
        else {
            urlneed = [[[elements objectAtIndex:i]attributes]valueForKey:@"pagespeed_lazy_src"];
        }
        
        xpathParser = nil;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    
    [self load_img];
    
    NSLog (@"\n\n 5 %@", urlneed);
   
    BOOL prefix = [urlneed hasPrefix:@"http://www.sugarain.kr/"];
    if (!prefix)
    {
        urlStr2=[@"http://www.sugarain.kr/" stringByAppendingString: urlneed];
        
    }
    
    
    NSLog(@"%@",urlStr2);
    NSURL *url               = [NSURL URLWithString:urlStr2];
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
    NSLog(@"%@", requestURL);
    
    [_Profile_view loadRequest:requestURL];
    
    self.navigationController.navigationBarHidden = NO; //YES : 숨기기, NO : 보이기
    

    [_inconnectionButton setBackgroundColor:[UIColor  colorWithRed:77/255.0 green:182/255.0 blue:232/255.0 alpha:1.0]];
    _inconnectionButton.layer.cornerRadius = 6;

    
    _Profile_view.layer.cornerRadius = _Profile_view.frame.size.height/1.899f;

    
    // webview 스크롤 막기
    _Profile_view.scrollView.scrollEnabled = NO;
    _Profile_view.scrollView.bounces = NO;
    
    
}

-(void) viewWillAppear:(BOOL)animated{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"saveID"];
    
    [usernamelabel setText:username];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma Acitons
- (IBAction)domainButton_Click:(UIButton *)sender {
    
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"서비스 양해 공지"
                                                        message: @"이 웹사이트는 PC에 최적화되어있습니다.     사용이 원활하지 않을 수 있으니 PC에서 접속해주시기 바랍니다. "
                                                       delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
    
}

- (IBAction)inconnection:(UIButton *)sender {
    
    
    //[self alertStatus:@"연결을 해제하면 알림을 받으실 수 없습니다." :@"계정연결 해제" :0];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"계정연결 해제"
                                                        message: @"연결을 해제하면 알림을 받으실 수 없습니다."
                                                       delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:@"취소", nil];
    [alertView show];
    [alertView release];
}



-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // yes 클릭시
    if([[alertView title] isEqualToString:@"계정연결 해제"] ){
        
        if(buttonIndex != 1){
            //userdefault 삭제
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"saveID"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"savePW"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"member_id"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FB_user_id"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GG_user_id"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_email"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"url_scheme"];
            NSLog(@"remove_url_scheme => %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"url_scheme"]);
            
            NFRoginViewController *loginView =[self.storyboard instantiateViewControllerWithIdentifier:@"NFSRLoginViewController"];
            [loginView setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentViewController:loginView animated:YES completion:nil];
            
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else{
        return;
    }
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)dealloc {

    [_inconnectionButton release];
    [usernamelabel release];
    [super dealloc];
}

@end
