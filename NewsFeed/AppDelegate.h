//
//  AppDelegate.h
//  NewsFeed
//
//  Created by RDMac on 2015. 9. 25..
//  Copyright (c) 2015년 RDmac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFRoginViewController.h"
#import "SRManagerKit.h"
#import <Google/SignIn.h>


@class NFRoginViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,GIDSignInDelegate>{
    
    NSUserDefaults *userDefaults;
}

@property (strong, nonatomic) UIWindow *window;

@property(strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) NFRoginViewController *roginviewcontroller;

//@property (strong,nonatomic) NSString *deviceToken_id;

@property (retain, nonatomic) NSUserDefaults *deviceToken_id;

@property (strong, nonatomic) NSString *bIS4;



//- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window;

@end

