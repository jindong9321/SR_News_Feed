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
#import "NFWebViewController.h"



@interface NFMainViewController ()

@end

@implementation NFMainViewController

@synthesize usernamelabel;
@synthesize loginviewcontroller = _loginviewcontroller;

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
    NSLog(@" link = > %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"SNS_link"]);
    if(([[NSUserDefaults standardUserDefaults] objectForKey:@"url_scheme" ] == nil) && ([[NSUserDefaults standardUserDefaults] objectForKey:@"SNS_link"] == nil)  ){
        url_1 = [NSURL URLWithString:@"http://www.sugarain.kr/login/accounts/do_login"];
        request = [ASIFormDataRequest requestWithURL:url_1];
        [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"saveID"] forKey:@"userid"];
        [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"textPW"] forKey:@"passwd"];
        
        
    }else{
        
        NSLog(@"url-scheme = > %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"url_scheme"]);
        request = [ASIFormDataRequest requestWithURL:url];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSLog(@" SNS_link = > %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"SNS_link"]);
        if( [[defaults objectForKey:@"SNS_link"] isEqualToString:@""] /*&&([defaults objectForKey:@"SNS_link"] == nil)*/){
            NSLog(@" \n\n google \n\n");
            [request setPostValue:@"google" forKey:@"sns"];
        }
        else{
            NSLog(@"\n\nfacebook\n\n");
            [request setPostValue:@"facebook" forKey:@"sns"];
            
            
        }
        
        NSLog(@" SNS_user_id => %@",[defaults objectForKey:@"SNS_user_id"]);
        NSLog(@" SNS_user_name => %@",[defaults objectForKey:@"SNS_user_name"]);
        NSLog(@" SNS_user_email => %@",[defaults objectForKey:@"SNS_user_email"]);
        [request setPostValue:[defaults objectForKey:@"SNS_user_id"]forKey:@"snsid"];
        [request setPostValue:[defaults objectForKey:@"SNS_user_name"]forKey:@"name"];
        [request setPostValue:[defaults objectForKey:@"SNS_user_email"] forKey:@"email"];
        [request setPostValue:[defaults objectForKey:@"SNS_user_Token"] forKey:@"token"];
        
        //        [request setPostValue:@"https://graph.facebook.com/824671480985431/picture?type=large" forKey:@"picture"];
        [request setResponseEncoding:NSUTF8StringEncoding];
        
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
    
    
    _Profile_view.layer.cornerRadius = _Profile_view.frame.size.height/2.0f;
    _Profile_view.layer.cornerRadius = _Profile_view.frame.size.width/2.0f;
    
    
    // webview 스크롤 막기
    _Profile_view.scrollView.scrollEnabled = NO;
    _Profile_view.scrollView.bounces = NO;
    
    _aramLabel.text = @" 알림 설정";
    
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_nameString"];
    [usernamelabel setText:username];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _switchButton.on = YES;
    
}

-(void) viewWillAppear:(BOOL)animated{
    
    NSString *_value = [[NSUserDefaults standardUserDefaults] stringForKey:@"stateOfSwitch"];
    
    if([_value compare:@"ON"] == NSOrderedSame){
        _switchButton.on = YES;
    }
    else{
        _switchButton.on = NO;
    }
    
    [super viewWillAppear:animated];
    
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



- (void) member_id:(NSString *)memberID requestInitializeWithDeviceId:(NSString *)deviceId token:(NSString *)token  aram:(NSString *)aram isForced:(BOOL)isForced successHandler:(SRXMLRPCSuccessHandler)successHandler failHandler:(SRXMLRPCFailHandler)failHandler;{
    
    [[SRXMLRPCManager sharedManager]member_id:memberID
                requestInitializeWithDeviceId:deviceId
                                        token:token
                                         aram:aram
                                     isForced:isForced
                               successHandler:^(id XMLData){
                                   NSLog(@" \n\n  success  \n\n ");
                                   
                               } failHandler:^(NSError *error, id XMLData){
                                   NSLog(@" \n\n  failHandler  \n\n ");
                               }
     ];
    
    
    NSLog(@" \n === aram state = %@ === \n", aram);
    
}

- (IBAction)switchButton:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = @"ON";
    
    
    if(_switchButton.on){
        NSLog(@" \n switch on \n %d",_switchButton.on);
        [defaults setObject:value forKey:@"stateOfSwitch"];
        
        [self member_id:[defaults  objectForKey:@"member_id"] requestInitializeWithDeviceId:[defaults  objectForKey:@"keychain_UUID"] token:[defaults  objectForKey:@"deviceToken_id"] aram:@"Y" isForced:YES successHandler:^(id XMLData) {
        }failHandler:^(NSError *error, id XMLData) {}];
        
    }
    else{
        NSLog(@" \n switch on \n %d",_switchButton.on);
        value = @"OFF";
        [defaults setObject:value forKey:@"stateOfSwitch"];
        [self member_id:[defaults  objectForKey:@"member_id"] requestInitializeWithDeviceId:[defaults  objectForKey:@"keychain_UUID"] token:[defaults  objectForKey:@"deviceToken_id"] aram:@"N" isForced:YES successHandler:^(id XMLData) {
        }failHandler:^(NSError *error, id XMLData) {}];
        
    }
    
    [defaults synchronize];
}



-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // yes 클릭시
    if([[alertView title] isEqualToString:@"계정연결 해제"] ){
        
        if(buttonIndex != 1){
            //userdefault 삭제
            
            [self member_id:[defaults  objectForKey:@"member_id"] requestInitializeWithDeviceId:[defaults  objectForKey:@"keychain_UUID"] token:[defaults  objectForKey:@"deviceToken_id"] aram:@"N" isForced:YES successHandler:^(id XMLData) {
                
                
            }failHandler:^(NSError *error, id XMLData) {}];
            
            [defaults removeObjectForKey:@"saveID"];
            [defaults removeObjectForKey:@"savePW"];
            [defaults removeObjectForKey:@"member_id"];
            [defaults removeObjectForKey:@"SNS_user_id"];
            [defaults removeObjectForKey:@"SNS_user_email"];
            [defaults removeObjectForKey:@"SNS_user_name"];
            [defaults removeObjectForKey:@"url_scheme"];
            [defaults removeObjectForKey:@"keychain_UUID"];
            [defaults removeObjectForKey:@"user_nameString"];
            [defaults removeObjectForKey:@"SNS_link"];
            [defaults removeObjectForKey:@"SNS_user_Token"];
            [defaults removeObjectForKey:@"stateOfSwitch"];
            NSLog(@"SNS_user_Token => %@",[defaults objectForKey:@"SNS_user_Token"]);
            
            //facebook
            if (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
                // Close the session and remove the access token from the cache
                // The session state handler (in the app delegate) will be called automatically
                [FBSession.activeSession closeAndClearTokenInformation];
                [_loginviewcontroller userLoggedOut];
            }
            
            // google
            [[GIDSignIn sharedInstance] signOut];
            
            NFRoginViewController *loginView =[self.storyboard instantiateViewControllerWithIdentifier:@"NFSRLoginViewController"];
            [loginView setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentViewController:loginView animated:YES completion:nil];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        
    }
    else{
        
    }
    [defaults synchronize];
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *simpleTableIdentifier = @"SimpleTableItem";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//    }
//    
//    
//    return cell;
//}
//
//-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
//
//
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    
//    [self.detailViewController.webView loadRequest:requestURL];
//    if (!self.detailViewController) {
//        NFSRDetailViewController *detailView =[self.storyboard instantiateViewControllerWithIdentifier:@"NFSRDetailViewController"];
//        [self.navigationController pushViewController:detailView animated:YES];
//    }
//}



- (void)dealloc {
    
    [_inconnectionButton release];
    [usernamelabel release];
    [_aramLabel release];
    [_switchButton release];
    [_aramSettingCell release];
    [super dealloc];
}

@end
