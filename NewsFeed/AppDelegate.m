//
//  AppDelegate.m
//  NewsFeed
//
//  Created by RDMac on 2015. 9. 25..
//  Copyright (c) 2015년 RDmac. All rights reserved.
//

#import "AppDelegate.h"
#import "NFRoginViewController.h"
#import "SRManager.h"
#import "SRManagerKit.h"
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate (){
    
}

@end

@implementation AppDelegate
@synthesize roginviewcontroller = roginviewcontroller;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
      //facebook
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSLog(@"Found a cached session");
        
        // If there's no cached session, we will show a login button
    } else {
        UIButton *inconnectButton = [self.nfmainviewcontroller inconnectionButton];
        [inconnectButton setTitle:@"" forState:UIControlStateNormal];
    }

    
    
    //Google
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    [GIDSignIn sharedInstance].delegate = self;
            // APNS
        application.applicationIconBadgeNumber = 0;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            UIUserNotificationSettings *notiType = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
            
            [[UIApplication sharedApplication] registerUserNotificationSettings:notiType];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
        else
        {
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
             (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
        }
        
        if(launchOptions!=nil){
            NSString *msg = [NSString stringWithFormat:@"%@", launchOptions];
            NSLog(@" %@",msg);
            
        }
        
        //여기서부터 수정함. 노티 수신했을 때 alert 출력
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo != nil) {
            NSDictionary *aps = [userInfo valueForKey:@"aps"];
            NSLog(@"userInfo Alert : %@", [aps valueForKey:@"alert"]);
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"알림"
                                                         message:[aps valueForKey:@"alert"]
                                                        delegate:nil
                                               cancelButtonTitle:@"확인"
                                               otherButtonTitles:nil];
            [av show];
            [av release];
        }
    
   NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
        return YES;
}


void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"\n\n || Crash ||: %@ \n\n",exception);
    NSLog(@"\n\n || Stack Trace||: %@ \n\n", [exception callStackSymbols]);
    // Internal error reporting
}



// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
// Override application:openURL:sourceApplication:annotation to call the FBsession object that handles the incoming URL
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *url_scheme = [[NSString alloc] init];
    url_scheme = [url scheme];
    NSLog(@" \n\n url_scheme => %@" ,[url scheme]);
    [[NSUserDefaults standardUserDefaults] setObject:url_scheme forKey:@"url_scheme"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"app_url => %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"url_scheme"]);
    
    if([[url scheme] isEqualToString:@"fb879589285436581"]){
        return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    }
    else{
        return [[GIDSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    return NO;

}

// google
- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user  withError:(NSError *)error {
    NSLog(@"\n\n didDisconnectWithUser[1] \n\n");
    NSDictionary *statusText = @{@"statusText": @"Disconnected user" };
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ToggleAuthUINotification"
     object:nil
     userInfo:statusText];
    
}

// google
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user  withError:(NSError *)error {
    NSLog(@"\n\n didSignInForUser[2] \n\n");
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    
    //Perform any operations on signed in user here.
    NSString *userId = user.userID;                                 // For client-side use only!
    
    
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *name = user.profile.name;
    NSString *email = user.profile.email;
    
    
    [prefs setObject:userId forKey:@"SNS_user_id"];
     [prefs setObject:name forKey:@"SNS_user_name"];
     [prefs setObject:email forKey:@"SNS_user_email"];
     [prefs setObject:email forKey:@"user_nameString"];
     [prefs setObject:@"" forKey:@"SNS_link"];
    [prefs setObject:idToken forKey:@"SNS_user_Token"];

    
    NSLog(@" userId => %@\n idToken-> %@\n name-> %@\n email-> %@\n",userId, idToken,name,email);
    NSDictionary *statusText = @{@"statusText":
                                     [NSString stringWithFormat:@"Signed in user: %@",
                                      name]};
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ToggleAuthUINotification"
     object:nil
     userInfo:statusText];
    
    [prefs synchronize];
    
}

-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    
        NSLog(@"deviceToken: %@", deviceToken);
        NSString *stringToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        stringToken = [stringToken stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:stringToken forKey:@"deviceToken_id"];
        [prefs synchronize];

        
        NSString *deviceToken_id = stringToken;
        
        NSLog(@" deviceToken => %@",deviceToken_id);
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
        NSDictionary *aps = [userInfo valueForKey:@"aps"];
        NSLog(@"userInfo Alert : %@", [aps valueForKey:@"alert"]);
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"알림"
                                                     message:[aps valueForKey:@"alert"]
                                                    delegate:nil
                                           cancelButtonTitle:@"확인"
                                           otherButtonTitles:nil];
        [av show];
        [av release];
}

- (void) setApplicationBadgeCount:(NSInteger)badgeCount {
    if (badgeCount < 0)
        badgeCount = 0;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = badgeCount;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    //Google

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    //facebook
    [FBAppCall handleDidBecomeActive];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
