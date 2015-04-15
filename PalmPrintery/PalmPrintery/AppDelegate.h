//
//  AppDelegate.h
//  PalmPrintery
//
//  Created by Jia Xiaochao on 14/12/20.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPUser;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PPUser *user;

@end

