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
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize roginviewcontroller = _roginviewcontroller;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    //facebook
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [FBLoginView class];
    [FBSDKLoginButton class];
    
//    //Google
//    NSError *configureError;
//    [[GGLContext sharedInstance] configureWithError: &configureError];
//    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
//    
//    [GIDSignIn sharedInstance].delegate = self;

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
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    NSString *url_scheme = [url scheme];
    [[NSUserDefaults standardUserDefaults] setObject:url_scheme forKey:@"url_scheme"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"app_url => %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"url_scheme"]);
//
//    if([[url scheme] isEqualToString:@"fb879589285436581"]){
//        return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
//    }
//    else{
//        return [[GIDSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];
//    }
//    return NO;
    
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    //facebook
//    if( [FBAppCall handleOpenURL:url sourceApplication:sourceApplication]){
//        return YES;
//    }else{
//        return [[GIDSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];
//    }
}

//// google
//- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user  withError:(NSError *)error {
//    
//    NSDictionary *statusText = @{@"statusText": @"Disconnected user" };
//    [[NSNotificationCenter defaultCenter]
//     postNotificationName:@"ToggleAuthUINotification"
//     object:nil
//     userInfo:statusText];
//    
//}
//
//// google
//- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user  withError:(NSError *)error {
//    
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//   
//        //Perform any operations on signed in user here.
//        NSString *userId = user.userID;                                 // For client-side use only!
//        [prefs setObject:userId forKey:@"GG_user_id"];
//    
//
//        NSString *idToken = user.authentication.idToken; // Safe to send to the server
//        NSString *name = user.profile.name;
//        NSString *email = user.profile.email;
//        [prefs setObject:email forKey:@"user_email"];
//       NSLog(@"user_email => %@",[prefs objectForKey:@"user_email"]);
//    
//    
//        NSLog(@" userId => %@\n idToken-> %@\n name-> %@\n email-> %@\n",userId, idToken,name,email);
//    
//        NSDictionary *statusText = @{@"statusText":
//                                         [NSString stringWithFormat:@"Signed in user: %@",
//                                          name]};
//        [[NSNotificationCenter defaultCenter]
//         postNotificationName:@"ToggleAuthUINotification"
//         object:nil
//         userInfo:statusText];
//    
//    [prefs synchronize];
//
//}





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
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
