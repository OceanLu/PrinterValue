//
//  AppDelegate.m
//  PalmPrintery
//
//  Created by Jia Xiaochao on 14/12/20.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "AppDelegate.h"
#import "TTCacheUtil.h"
#import "DataModel.h"
#import "LoginViewController.h"
#import "TTAppearance.h"

#import "APIClient.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize user = _user;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [TTAppearance setTabBarAppearanceForWindow:self.window];
    [TTAppearance setNavigationBarAppearance];
    
    if (SharedAppDelegate.user == nil)
    {
        LoginViewController *login = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.window makeKeyAndVisible];
        login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.window.rootViewController presentViewController:login animated:NO completion:nil];
    }
    
    return YES;
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - SLUer

#define kCacheFileNameUser       @"cn.com.founder.printerp.user.plist"

- (void)setUser:(PPUser *)user
{
    _user = user;
    if (_user)
    {
        [TTCacheUtil writeObject:_user toFile:kCacheFileNameUser];
    }
    else
    {
        
        [TTCacheUtil removeObjectForName:kCacheFileNameUser];
    }
}

- (PPUser*)user
{
    if (!_user)
    {
        _user = [TTCacheUtil objectFromFile:kCacheFileNameUser];
    }
    return _user;
}

@end
