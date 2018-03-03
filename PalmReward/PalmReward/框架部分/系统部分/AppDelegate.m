//
//  AppDelegate.m
//  PalmReward
//
//  Created by rimi on 16/12/7.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import <SMS_SDK/SMSSDK.h>
#import <RongIMKit/RongIMKit.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setSomeThing];
    
    return YES;
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)setSomeThing{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
    [[RCIM sharedRCIM] initWithAppKey:@"y745wfm8yoknv"];
    //19efdf2f3d398
    //7ac65b5c9658260342a7ebd5ce3f6d5e
    [SMSSDK registerApp:@"1975276bb3098" withSecret:@"cd98925f3f6cc0cc11b6dcdc2a400149"];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[MainTabBarController alloc] init];
    [self.window makeKeyAndVisible];
}
@end
