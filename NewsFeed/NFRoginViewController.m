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
    
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                       allowLoginUI:NO
                                  completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                      // Handler for session state changes
                                      // This method will be called EACH time the session state changes,
                                      // also for intermediate states and NOT just when the session open
                                      [self sessionStateChanged:session state:state error:error];
                                  }];
    
    
    self.navigationController.navigationBarHidden = YES;
    [[NFSRTableViewController alloc] init];
    
    // Google
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(receiveToggleAuthUINotification:)
     name:@"ToggleAuthUINotification"
     object:nil];
    
    [self toggleAuthUI];
    // google_end
    
    
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
    
    _textID.backgroundColor = [UIColor whiteColor];
    _textPassword.backgroundColor = [UIColor whiteColor];
    
    //facebook button & google button
    _gg_loginbutton.layer.cornerRadius = 6;
    _loginbutton.layer.cornerRadius = 6;
    
    
    
}

 - (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error{
     // If the session was opened successfully
     if (!error && state == FBSessionStateOpen){
         
         
         
         NSLog(@"Session opened");
         // Show the user the logged-in UI
         [self userLoggedIn];
         return;
     }
     if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
         // If the session is closed
         NSLog(@"Session closed");
         // Show the user the logged-out UI
         [self userLoggedOut];
     }
     
     // Handle errors
     if (error){
         NSLog(@"Error");
         NSString *alertText;
         NSString *alertTitle;
         // If the error requires people using an app to make an action outside of the app in order to recover
         if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
             alertTitle = @"Something went wrong";
             alertText = [FBErrorUtility userMessageForError:error];
             [self showMessage:alertText withTitle:alertTitle];
         } else {
             
             // If the user cancelled login, do nothing
             if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                 NSLog(@"User cancelled login");
                 
                 // Handle session closures that happen outside of the app
             } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                 alertTitle = @"Session Error";
                 alertText = @"Your current session is no longer valid. Please log in again.";
                 [self showMessage:alertText withTitle:alertTitle];
                 
                 // For simplicity, here we just show a generic message for all other errors
                 // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
             } else {
                 //Get more error information from the error
                 NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                 
                 // Show the user an error message
                 alertTitle = @"Something went wrong";
                 alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                 [self showMessage:alertText withTitle:alertTitle];
             }
         }
         
         // Clear this token
         [FBSession.activeSession closeAndClearTokenInformation];
         // Show the user the logged-out UI
         [self userLoggedOut];
     }
 }


// Show the user the logged-in UI
- (void)userLoggedIn{
    // Set the button title as "Log out"
  //  [_loginbutton setTitle:@"Log out" forState:UIControlStateNormal];
}


- (void)userLoggedOut
{
    // Set the button title as "Log in with Facebook"
    [_loginbutton setTitle:@"f" forState:UIControlStateNormal];
    // Confirm logout message
    //[self showMessage:@"You're now logged out" withTitle:@""];
}


// Show an alert message
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
}


//facebook login
- (IBAction)FB_loginButton_Click:(id)sender {

    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"] allowLoginUI:YES completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
         
         [[FBRequest requestForMe] startWithCompletionHandler: ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             NSLog(@"user info => %@", user);
             NSLog(@" user link = > %@", user.link);
             
             NSLog(@"user token => %@", session.accessTokenData.accessToken);
             
             NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
             [prefs setObject:user.id forKey:@"SNS_user_id"];
             NSString *FB_email = [user objectForKey:@"email"];
             [prefs setObject:FB_email forKey:@"SNS_user_email"];
              [ prefs setObject:FB_email forKey:@"user_nameString"];
             [ prefs setObject:user.name forKey:@"SNS_user_name"];
             [ prefs setObject:user.link forKey:@"SNS_link"];
             [prefs setObject:session.accessTokenData.accessToken forKey:@"SNS_user_Token"];
             
             
             NSLog(@"username => %@", [prefs objectForKey:@"SNS_user_name"]);
             NSLog(@" SNS_user_id => %@",[prefs objectForKey:@"SNS_user_id"]);
             NSLog(@"fa_SNS_user_email => %@",[prefs objectForKey:@"SNS_user_email"]);

             if([prefs objectForKey:@"SNS_user_id"] != nil){
             [[SRXMLRPCManager sharedManager]SNSType:@"facebook"
                                              userid:[prefs objectForKey: @"SNS_user_id"]
                                            isForced:YES
                                      successHandler:^(id XMLData) {
                                          NSLog(@"\n\n Success \n\n");
                                          NSString  *FB_id = [[NSString alloc]init];
                                          FB_id = XMLData[@"member_id"];
                                          [[NSUserDefaults standardUserDefaults] setObject:FB_id forKey:@"member_id"];
                                          
                                          NSLog(@"FB_member_id => %@",[prefs objectForKey:@"member_id"]);
                                          [prefs setObject:[KeyChainUUID Value] forKey:@"keychain_UUID"];
                                          
                                          
                                          
                                          [[SRXMLRPCManager sharedManager]member_id:[prefs objectForKey:@"member_id"]
                                                      requestInitializeWithDeviceId:[prefs objectForKey:@"keychain_UUID"]
                                                                              token:[prefs objectForKey:@"deviceToken_id"]
                                                                               aram:@"Y"
                                                                           isForced:YES
                                                                     successHandler:^(id XMLData) {
                                                                         
                                                                         
                                                                     } failHandler:^(NSError *error, id XMLData) {
                                                                         
                                                                     }];

                                          UINavigationController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"navigationview"];
                                          [controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                                          [self presentViewController:controller animated:YES completion:nil];
                                  
                                      }
                                         failHandler:^(NSError *error, id XMLData) {
                                             NSLog(@" \n\nfailHandler ");
                                             NFWebViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"webViewController"];
                                             [controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                                             [self presentViewController:controller animated:YES completion:nil];
                                             
                                         }];

             NSLog(@"You're logged in");
             
              [prefs synchronize];
             }
         }];
         
     }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gg_loginButton_Click:(id)sender {
    [[GIDSignIn sharedInstance]signIn];
    
}
// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
    
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {

    [self dismissViewControllerAnimated:YES completion:nil];
}

// google
- (void)toggleAuthUI {
    if ([GIDSignIn sharedInstance].currentUser.authentication == nil) {
        // Not signed in
        _gg_loginbutton.hidden = NO;
        } else {
        // Signed in
        _gg_loginbutton.hidden = NO;
        NSLog(@" google loginout");
    }
}



// google
- (void) receiveToggleAuthUINotification:(NSNotification *) notification {
    
    
    if ([[notification name] isEqualToString:@"ToggleAuthUINotification"]) {

            [self toggleAuthUI];

        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [[SRXMLRPCManager sharedManager]SNSType:@"google"
                                         userid:[prefs objectForKey: @"SNS_user_id"]
                                               isForced:YES
                                 successHandler:^(id XMLData) {
                                     NSLog(@" Success type id ");
                                     NSString *GG_id = XMLData[@"member_id"];
                                     NSLog(@"GG_id => %@", GG_id);
                                  	  [prefs setObject:GG_id forKey:@"member_id"];
                                     
                                     NSLog(@"\n\n\n------- keychainUUID -------  %@ ------- \n\n\n",[KeyChainUUID Value]);
                                     [[NSUserDefaults standardUserDefaults] setObject:[KeyChainUUID Value] forKey:@"keychain_UUID"];

                                     [[SRXMLRPCManager sharedManager]member_id:[prefs objectForKey:@"member_id"]
                                                 requestInitializeWithDeviceId:[prefs objectForKey:@"keychain_UUID"]
                                                                         token:[prefs objectForKey:@"deviceToken_id"]
                                                                          aram:@"Y"
                                                                      isForced:YES
                                                                successHandler:^(id XMLData) {
                                                                    
                                                                    
                                                                } failHandler:^(NSError *error, id XMLData) {
                                                                    
                                                                }];

                                     
                                     UINavigationController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"navigationview"];
                                     [controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                                     [self presentViewController:controller animated:YES completion:nil];


                                 } failHandler:^(NSError *error, id XMLData) {
                                     NSLog(@"\ngoogle login fail\n");
                                     NFWebViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"webViewController"];
                                     [controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                                     [self presentViewController:controller animated:YES completion:nil];
                                     [[GIDSignIn sharedInstance] signOut];
                                     
                                }];

        [prefs synchronize];
    }

   
    NSLog(@" GGmemeber_id -> %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"memeber_id"]);

}


// 계정연결 버튼 클릭시 NFMainViewController 이동
- (IBAction)connectionButton_Click:(UIButton *)sender {
    
    
        if([[self.textID text] isEqualToString:@""] || [[self.textPassword text] isEqualToString:@""] ) {
            
            [self alertStatus:@"입력된 이메일 또는 비밀번호를 입력하세요" :@"잘못된 정보" :0];
        }
        
        else{
            
            
//            NSURL *url = [NSURL URLWithString:@"http://www.sugarain.kr/login/accounts/do_login"];
//            
//            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//            [request setPostValue:self.textID.text forKey:@"userid"];
//            [request setPostValue:self.textPassword.text forKey:@"passwd"];
//            //[request setPostValue:@"Y" forKey:@"autologin"];
//            [request setDelegate:self];
//            [request startSynchronous];
            
            
            NSString *userID = _textID.text;
            NSString *userPW = _textPassword.text;
            NSString* string = userPW;
            NSLog(@"\n\nSHA256: %@\n\n", [string SHA256]);
            
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:userID forKey:@"saveID"];
            [prefs setObject:userID forKey:@"user_nameString"];
            [prefs setObject:userPW forKey:@"textPW"];
            [prefs setObject:[string SHA256] forKey:@"savePW"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            //SRXMLRPCManager 호출
            [[SRXMLRPCManager sharedManager] saveID:userID savePW:[string SHA256] successHandler:^(id XMLData){
                NSString *memberd = [[NSString alloc]init];
                memberd = XMLData[@"member_id"];
                NSLog (@"memberid=%@", memberd);
                
                [[NSUserDefaults standardUserDefaults] setObject:memberd forKey:@"member_id"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                //NSString *deviceToken = [defaults objectForKey:@"deviceToken_id"];
                //                NSLog(@"deviceToken: %@", deviceToken);
                NSLog(@"\n\n\n------- keychainUUID -------  %@ ------- \n\n\n",[KeyChainUUID Value]);
                [[NSUserDefaults standardUserDefaults] setObject:[KeyChainUUID Value] forKey:@"keychain_UUID"];
                
                
                [[SRXMLRPCManager sharedManager]member_id:[defaults objectForKey:@"member_id"]
                            requestInitializeWithDeviceId:[defaults objectForKey:@"keychain_UUID"]
                                                    token:[defaults objectForKey:@"deviceToken_id"]
                                                     aram:@"Y"
                                                 isForced:YES
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
    [_loginbutton release];
    [_gg_loginbutton release];
    [super dealloc];
}




@end
