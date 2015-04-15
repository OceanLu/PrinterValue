//
//  TTBaseViewController.m
//  Card
//
//  Created by chun tao on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTBaseViewController.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"
#import "UIView+Toast.h"
#import "AppDelegate.h"
#import "macro.h"
#import "MJRefresh.h"

#define TIME 1.0
@interface TTBaseViewController()
{
    MBProgressHUD *HUD;
    UIActivityIndicatorView *_activityIndicator;
}

@end

@implementation TTBaseViewController

- (void)backAction:(id)sender
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)showAlertWithTitle:(NSString*)title message:(NSString*)message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

- (void)showLoadingView
{
    [self showLoadingViewWithMessage:nil];
}

- (void)showLoadingViewWithMessage:(NSString *)message
{
    [self hideLoadingView];
    
    HUD = [[MBProgressHUD alloc] initWithView:SharedAppDelegate.window];
	[SharedAppDelegate.window addSubview:HUD];
	
//    HUD.dimBackground = YES;
    HUD.labelText = message;
    [HUD show:YES];
    HUD.removeFromSuperViewOnHide = YES;
}

- (void)hideLoadingView
{
    if (HUD)
    {
        [HUD hide:YES];
        HUD = nil;
    }
}

- (void)setBackButton
{
//    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
//    {
//        return;
//    }
    
    if (self.navigationController.viewControllers.count == 0 || self.navigationController.viewControllers[0] == self)
    {
        return;
    }

    UIImage *backImage = [UIImage imageNamed:@"navi_back"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 44);
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    [backButton setTitleColor:UIColorRGB(125,125,125) forState:UIControlStateNormal];
//    [backButton setTitleColor:UIColorRGB(94, 94, 94) forState:UIControlStateHighlighted];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
    
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [backButton addTarget:self
                   action:@selector(backAction:)
         forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    UIBarButtonItem *leftSpace = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                  target:nil action:nil];
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
    {
        leftSpace.width = -12;
    }
    else
    {
        leftSpace.width = -1;
    }
    self.navigationItem.leftBarButtonItems = @[leftSpace, backItem];
}


- (void)loadDataWithParameters:(NSDictionary *) parameters
{
    //sub Class
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navi_bg"]];
    [self setBackButton];

    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self hideLoadingView];
    
}

- (void)showConnectionTimeout
{
    
}


- (void)showNetworkNotAvailable
{
    [self showToast:@"网络连接失败，请检查网络稍后重试" duration:1.0];
}

- (void)showToast:(NSString*)message
{
    [self showToast:message duration:TIME];
}

- (void)showToast:(NSString*)message duration:(float)seconds
{
    [SharedAppDelegate.window makeToast:message duration:seconds position:@"center"];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [HUD removeFromSuperview];
    HUD = nil;
}

- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer
{
	for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]])
        {
            UITextField *textField = (UITextField*)view;
            [textField resignFirstResponder];
        }
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
}

@end
