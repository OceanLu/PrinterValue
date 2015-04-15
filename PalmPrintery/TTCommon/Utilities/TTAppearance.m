//
//  TTAppearance.m
//
//
//  Created by Ocean on 3/10/15.
//  Copyright (c) 2015 ocean.cn. All rights reserved.
//

#import "TTAppearance.h"


#define UIColorRGB(r, g, b)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define UIColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)/255.0]
#define UIColorHSL(h, s, l)     [UIColor colorWithHue:(h)/255.0f saturation:(s)/255.0f brightness:(l)/255.0f alpha:1.0f]
#define UIColorHSLA(h, s, l, a) [UIColor colorWithHue:(h)/255.0f saturation:(s)/255.0f brightness:(l)/255.0f alpha:(a)/255.0f]


@implementation TTAppearance

+ (void)setTabBarAppearanceForWindow:(UIWindow*)window
{
    if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_6_1)
    {
        [UITabBar.appearance setBackgroundImage:[UIImage imageNamed:@"tab_background"]];
    }
    
    [UITabBar.appearance setSelectionIndicatorImage:[[UIImage alloc] init]];

    [UITabBarItem.appearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                     UIColorRGB(165, 165, 165), NSForegroundColorAttributeName,
                                                     nil] forState:UIControlStateNormal];
    [UITabBarItem.appearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                     UIColorRGB(66, 148, 204), NSForegroundColorAttributeName,
                                                     nil] forState:UIControlStateSelected];
    
    
    
    UITabBarController *tabBarController = (UITabBarController *)window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;

    int i = 0;
    for (UITabBarItem *tabBarItem in tabBar.items)
    {
        NSString *imageName = [NSString stringWithFormat:@"tab_%i", i];
        NSString *selectedImageName = [NSString stringWithFormat:@"tab_%i_h", i];
        
        
        
        //iOS7
        if ([UIImage instancesRespondToSelector:@selector(imageWithRenderingMode:)])
        {
            UIImage *image = [[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIImage *selectedImage = [[UIImage imageNamed:selectedImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
            [tabBarItem setFinishedSelectedImage:selectedImage
                     withFinishedUnselectedImage:image];
            tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        else
        {
            UIImage *image = [UIImage imageNamed:imageName];
            UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
            
            [tabBarItem setFinishedSelectedImage:selectedImage
                     withFinishedUnselectedImage:image];
        }
        
        i++;
    }
}

+ (void)setAvatar:(UIImage *)image forWindow:(UIWindow*)window
{
    UIViewController *viewController = window.rootViewController;
    if (![viewController isKindOfClass:[UITabBarController class]])
    {
        return;
    }
    
    UITabBarController *tabBarController = (UITabBarController*)viewController;
    UITabBar *tabBar = tabBarController.tabBar;
    
    if (tabBar.items.count > 3)
    {
        UITabBarItem *profileItem = [tabBar.items objectAtIndex:3];
        
        [profileItem setFinishedSelectedImage:image withFinishedUnselectedImage:image];
        
        //iOS7
        if ([UIImage instancesRespondToSelector:@selector(imageWithRenderingMode:)])
        {
            profileItem.selectedImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
    }
}


+ (void)setNavigationBarAppearance
{
    //标题颜色
    UIColor *titleColor = [UIColor whiteColor];
    UIFont *titleFont = [UIFont boldSystemFontOfSize:18];

    //标题颜色
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{
       NSForegroundColorAttributeName:titleColor,
       UITextAttributeFont:titleFont,
       UITextAttributeTextColor:titleColor,
       UITextAttributeTextShadowColor:[UIColor clearColor],
       UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0, 0)]
       }];
    
    //iOS 7 or later
    if ([UINavigationBar instancesRespondToSelector:@selector(setBarTintColor:)])
    {
        //背景颜色
        [UINavigationBar.appearance setTintColor:titleColor];

//        UINavigationBar.appearance.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navi_bg"]];
    }
    else //iOS 6 or earlier
    {
        //背景和阴影
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
        UINavigationBar.appearance.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navi_bg"]];
        UINavigationBar.appearance.shadowImage = [UIImage new];
    }
    
}

+ (void)setNavigationBarAppearanceForWindow:(UIWindow*)window
{
    [UINavigationBar.appearance setTintColor:[UIColor whiteColor]];
    [UIBarButtonItem.appearance setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                       forBarMetrics:UIBarMetricsDefault];
    
    UIImage *backImage = [UIImage imageNamed:@"nav_back"];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor blackColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName:[UIColor whiteColor],
                                                           NSShadowAttributeName:shadow
                                                           }];
    
    
    //iOS 7 or later
    if ([UINavigationBar instancesRespondToSelector:@selector(setBarTintColor:)])
    {
//        [UINavigationBar.appearance setBarTintColor:UIColorHSLA(0, 0, 0, 192)];
        [UINavigationBar.appearance setBarTintColor:UIColorRGB(51, 51, 51)];
        
        //        [UINavigationBar.appearance setBackIndicatorImage:backImage];
        //        [UINavigationBar.appearance setBackIndicatorTransitionMaskImage:backImage];
        [UINavigationBar.appearance setTintColor:[UIColor whiteColor]];
        
    }
    else //iOS 6 or earlier
    {
        [UINavigationBar.appearance setBackgroundImage:[UIImage imageNamed:@"navi_bg"]
                                         forBarMetrics:UIBarMetricsDefault];
        //        backImage = [backImage resizableImageWithCapInsets:UIEdgeInsetsZero];
        //#pragma mark 解决出现两个返回图标的问题
        backImage = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 10)];

        [UIBarButtonItem.appearance setBackButtonBackgroundImage:backImage
                                                        forState:UIControlStateNormal
                                                      barMetrics:UIBarMetricsDefault];
        
//        UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
//        barButtonItem.imageInsets = UIEdgeInsetsZero;
        
        
        [UIBarButtonItem.appearance setTitleTextAttributes:@{
                                                             UITextAttributeTextColor:[UIColor whiteColor],
                                                             UITextAttributeFont:[UIFont systemFontOfSize:14.0f]
                                                             } forState:UIControlStateNormal];
    }
}

+ (void)setAppearanceForWindow:(UIWindow*)window
{
    if ([window.rootViewController isKindOfClass:[UITabBarController class]])
    {
        [self setTabBarAppearanceForWindow:window];
    }
    
    [self setNavigationBarAppearanceForWindow:window];

    
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
}

@end
