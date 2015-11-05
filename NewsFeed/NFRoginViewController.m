//
//  NFRoginViewController.m
//  NewsFeed
//
//  Created by RDMac on 2015. 9. 25..
//  Copyright (c) 2015년 RDmac. All rights reserved.
//

#include <stdlib.h>

#import "NFRoginViewController.h"
#include "NFSRTableViewController.h"
#import "NSString+NSHash.h"
#import "KeyChainUUID.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface NFRoginViewController ()

@end

@implementation NFRoginViewController
SHARED_SINGLETON_CLASS(NFRoginViewController);


@synthesize srxmlrpcmanager = _srxmlrpcmanager;
@synthesize NFSRtableViewController = _NFSRtableViewController;

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    
    const unsigned *tokenBytes = [devToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _fbloginButton.readPermissions = @[@"public_profile",@"email"];
    _fbloginButton.delegate = self;
    
    
    self.navigationController.navigationBarHidden = YES;
    [[NFSRTableViewController alloc] init];
    
//    // Google
//   [GIDSignIn sharedInstance].uiDelegate = self;
//    
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self
//     selector:@selector(receiveToggleAuthUINotification:)
//     name:@"ToggleAuthUINotification"
//     object:nil];
//    
//    [self toggleAuthUI];
//    // google_end

   
    // 백그라운드 컬러 적용
    _BGview.backgroundColor = [UIColor colorWithRed:77/255.0 green:182/255.0 blue:232/255.0 alpha:1.0];
    
    // 로고 이미지 적용
    _MainImageView.image = [UIImage imageNamed:@"sugarain_logo.png"];
    
    // 버튼 바탕 색
    [_connectionButton setBackgroundColor:[UIColor whiteColor]];
    // 버튼테두리 
    _connectionButton.layer.cornerRadius = 6;
    
    
    // 버튼 바탕 색
    [_joinButton setBackgroundColor:[UIColor whiteColor]];
    // 버튼테두리
    _joinButton.layer.cornerRadius = 6;
    
}

#pragma mark - FBLoginViewDelegate

//facebook login
-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    
    NSLog(@"You're logged in");
    
}

//facebook login
-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    
    NSLog(@"You're logged out");
}

//facebook login
-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    
    
      NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:user.id forKey:@"FB_user_id"];
    NSLog(@"username => %@", user.name);
 
    NSString *FB_email = [user objectForKey:@"email"];
    
    [prefs setObject:FB_email forKey:@"user_email"];
      [ prefs setObject:user.name forKey:@"FB_user_name"];
    NSLog(@"GG_usr_email_fa => %@",[prefs objectForKey:@"user_email"]);
    
    //request post lis
     
    [[SRXMLRPCManager sharedManager]SNSType:@"facebook"
                                       userid:[prefs objectForKey: @"FB_user_id"]
                                       isForced:NO
                             successHandler:^(id XMLData) {
                                 NSString *FB_id = XMLData[@"member_id"];
                                 [[NSUserDefaults standardUserDefaults] setObject:FB_id forKey:@"member_id"];
                                                                 UINavigationController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"navigationview"];
                                 [self presentViewController:controller animated:YES completion:nil];
                                 
                                 
                             }
                                failHandler:^(NSError *error, id XMLData) {
                                 
                             }];
    NSLog(@" FB_member_id => %@",[prefs objectForKey:@"member_id"]);
    NSLog(@"user => %@",user);
    
       [prefs synchronize];
}

//facebook login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
}

//// Present a view that prompts the user to sign in with Google
//- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
//    [self presentViewController:viewController animated:YES completion:nil];
//
//
//}
//
//// Dismiss the "Sign in with Google" view
//- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//// google
//- (void)toggleAuthUI {
//    if ([GIDSignIn sharedInstance].currentUser.authentication == nil) {
//        // Not signed in
//        self.GGloginButton.hidden = NO;
//        self.GGsignout.hidden = YES;
//        } else {
//        // Signed in
//        self.GGloginButton.hidden = YES;
//        self.GGsignout.hidden = NO;
//    }
//}
//
//// google logout 메소드
//- (IBAction)didTapSignOut:(id)sender {
//    [[GIDSignIn sharedInstance] signOut];
//    // [START_EXCLUDE silent]
//    [self toggleAuthUI];
//    // [END_EXCLUDE]
//}
//
//
//
//// google
//- (void) receiveToggleAuthUINotification:(NSNotification *) notification {
//    if ([[notification name] isEqualToString:@"ToggleAuthUINotification"]) {
//        
//            [self toggleAuthUI];
//        
//        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//        [[SRXMLRPCManager sharedManager]SNSType:@"google"
//                                         userid:[prefs objectForKey: @"GG_user_id"]
//                                               isForced:NO
//                                 successHandler:^(id XMLData) {
//                                     NSLog(@" Success type id ");
//                                     NSString *GG_id = XMLData[@"member_id"];
//                                     NSLog(@"GG_id => %@", GG_id);
//                                  	  [prefs setObject:GG_id forKey:@"member_id"];
//                                    
//                                 } failHandler:^(NSError *error, id XMLData) {
//                                     
//                                 }];
//        
//        [prefs synchronize];
//    }
//    UINavigationController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"navigationview"];
//    [controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//    [self presentViewController:controller animated:YES completion:nil];
//    
//    NSLog(@" GGmemeber_id -> %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"memeber_id"]);
//
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



   // 계정연결 버튼 클릭시 NFMainViewController 이동
- (IBAction)connectionButton_Click:(UIButton *)sender {
    
    
    if([[self.textID text] isEqualToString:@""] || [[self.textPassword text] isEqualToString:@""] ) {
        
        [self alertStatus:@"입력된 이메일 또는 비밀번호를 입력하세요" :@"잘못된 정보" :0];
    }
    
    else{
        
        
        NSURL *url = [NSURL URLWithString:@"http://www.sugarain.kr/login/accounts/do_login"];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setPostValue:self.textID.text forKey:@"userid"];
        [request setPostValue:self.textPassword.text forKey:@"passwd"];
        //[request setPostValue:@"Y" forKey:@"autologin"];
        [request setDelegate:self];
        [request startSynchronous];

        
        NSString *userID = _textID.text;
        NSString *userPW = _textPassword.text;
       NSString* string = userPW;
        NSLog(@"\n\nSHA256: %@\n\n", [string SHA256]);
        
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:userID forKey:@"saveID"];
        [prefs setObject:userPW forKey:@"textPW"];
        [prefs setObject:[string SHA256] forKey:@"savePW"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        
        //SRXMLRPCManager 호출
        [[SRXMLRPCManager sharedManager] saveID:userID savePW:[string SHA256] successHandler:^(id XMLData){ NSString *memberd = XMLData[@"member_id"];
            NSLog (@"memberid=%@", memberd);
            [[NSUserDefaults standardUserDefaults] setObject:memberd forKey:@"member_id"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *deviceToken = [defaults objectForKey:@"deviceToken_id"];
            NSLog(@"deviceToken: %@", deviceToken);
            NSLog(@"\n\n\n------- keychainUUID -------  %@ ------- \n\n\n",[KeyChainUUID Value]);
            
            [[SRXMLRPCManager sharedManager]member_id:[defaults objectForKey:@"member_id"]
                                                                    requestInitializeWithDeviceId:[KeyChainUUID Value]
                                                                    token:deviceToken
                                                                    isForced:NO
                                                            successHandler:^(id XMLData) {
                                                                
                                                            } failHandler:^(NSError *error, id XMLData) {
                                                                
                                                            }];
            
            UINavigationController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"navigationview"];
            [controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentViewController:controller animated:YES completion:nil];
        
            
        }
         
        failHandler:^(NSError *error, id XMLData) {
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"로그인 실패"
                                          message:@"로그인을 다시 시도해주시기 바랍니다."
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"확인"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action){
                                 }];
            
            
            [alert addAction:ok];

            
            [self presentViewController:alert animated:YES completion:nil];
            
        }];
        
        

    }
}



- (IBAction)joinButton_Click:(UIButton *)sender {
    NFWebViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"webViewController"];
    [controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:controller animated:YES completion:nil];
   
}



- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
}

// 텍스트 입력 후 배경 터치시 키보드 내림
- (IBAction)backgroudTouch:(id)sender {
    [_textID resignFirstResponder];
    [_textPassword resignFirstResponder];
}


- (void)dealloc {
    [_textID release];
    [_textPassword release];
    [_connectionButton release];
    [_joinButton release];
    [_connectionButton release];
    [_fbloginButton release];
    [_GGloginButton release];
    [_GGsignout release];
    [_GGsignout release];
    [super dealloc];
}

@end
