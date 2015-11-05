//
//  SRManager.h
//  sugarain
//
//  Created by SonMintak on 4/25/15.
//  Copyright (c) 2015 Mintak Son. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SHARED_SINGLETON_CLASS(class) \
static dispatch_once_t onceToken;\
static class* shared = nil;\
+(class*) sharedManager {\
@synchronized(self){\
dispatch_once(&onceToken, ^{\
shared = [[class alloc] init];\
});\
return shared;\
}\
}\
+(void) deinitialize {\
if(shared == nil) {\
return;\
}\
@synchronized(self){\
shared = nil;\
onceToken = 0;\
}\
}

@interface SRManager : NSObject
+ (instancetype) sharedManager;
+ (void) deinitialize;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)applicationWillResignActive:(UIApplication *)application;
- (void)applicationDidEnterBackground:(UIApplication *)application;
- (void)applicationWillEnterForeground:(UIApplication *)application;
- (void)applicationDidBecomeActive:(UIApplication *)application;
- (void)applicationWillTerminate:(UIApplication *)application;
@end