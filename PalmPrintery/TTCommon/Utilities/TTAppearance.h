//
//  TTAppearance.m
//
//
//  Created by Ocean on 3/10/15.
//  Copyright (c) 2015 ocean.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


@interface TTAppearance : NSObject

+ (void)setNavigationBarAppearance;

+ (void)setTabBarAppearanceForWindow:(UIWindow*)window;

+ (void)setAppearanceForWindow:(UIWindow*)window;

+ (void)setAvatar:(UIImage *)image forWindow:(UIWindow*)window;

@end
