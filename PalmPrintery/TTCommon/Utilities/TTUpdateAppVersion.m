//
//  TTUpdateAppVersion.m
//  SportsLottery
//
//  Created by Jia Xiaochao on 14-8-29.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TTUpdateAppVersion.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import "UIView+Toast.h"
#import "macro.h"
#import "APIClient.h"
#import "DataModel.h"
#import "NSBundle+Extensions.h"

static TTUpdateAppVersion *_sharedInstance = nil;

@interface TTUpdateAppVersion()
{
    NSString *updateString;
}
//@property (nonatomic, strong) NSString *urlString;

@end
@implementation TTUpdateAppVersion

+(id)alloc
{
    @synchronized([TTUpdateAppVersion class])
    {
        NSAssert(_sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
        return [super alloc];
    }
}

- (id)init
{
    self = [super init];
    if(self)
    {
    }
    
    return self;
}

+ (TTUpdateAppVersion*)sharedInstance
{
    @synchronized([TTUpdateAppVersion class])
    {
        if (!_sharedInstance)
        {
            _sharedInstance = [[TTUpdateAppVersion alloc] init];
        }
    }
    return _sharedInstance;
}

-(void)showToash:(NSString *)message
{
    [SharedAppDelegate.window makeToast:message duration:1.0 position:@"center"];
}

-(void)updateApp:(NSString *)urlString parameters:(NSDictionary *)parameters isShowTosh:(BOOL)flag
{
    NSString *version = [NSBundle bundleVersion];
    NSMutableDictionary *newParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [newParameters setObject:version forKey:@"version"];
    [newParameters setObject:@"iPhone" forKey:@"device_type"];
    
    [[APIClient sharedClient] requestPath:urlString
                               parameters:newParameters
                                  success:^(AFHTTPRequestOperation *operation, id JSON)
    {
        if ([[JSON valueForKey:@"code"]intValue] == 1)
        {
            NSDictionary *dict = [JSON valueForKey:@"data"];
            NSString *message = [dict valueForKey:@"summary"];

            message = [message stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];

            if (dict)
            {
                if ([version compare:[dict valueForKey:@"version"]] == NSOrderedAscending)
                {
                    updateString = [dict valueForKey:@"download_url"];
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    NSString *updateVersion = [userDefaults objectForKey:@"updateVersionDefaults"];
                    if (updateVersion == nil)
                    {
                        updateVersion = @"1.0.0";
                    }
                    if ([updateVersion compare:[dict valueForKey:@"version"]] != NSOrderedAscending)
                    {
                        if (!flag)
                        {
                            return;
                        }
                    }
                    [userDefaults setObject:[dict valueForKey:@"version"] forKey:@"updateVersionDefaults"];
                    [userDefaults synchronize];
                    
                    UIAlertView *alert;
                    if ([[dict valueForKey:@"force_update"]intValue] == 1)
                    {
                        alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                           message:@"检测到最新版本，\n是否进行更新？"
                                                          delegate: self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles: nil, nil];
                        alert.tag = 1;
                    }
                    else
                    {
                        alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                           message:@"检测到最新版本，\n是否进行更新？"
                                                          delegate: self
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles: @"确定", nil];
                        alert.tag = 2;
                    }
                    [alert show];
                }
                else
                {
                    if (flag)
                    {
                        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"提示"
                                                                     message:@"当前版本已是最新版本，\n祝您使用愉快。"
                                                                    delegate:self
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                        [alert show];
                    }
                    
                }
                
            }
            
        }
        else
        {
            if (!flag)
            {
                return;
            }
            TTLog(@"error:%@", [JSON valueForKey:@"message"]);
            [self showToash: [JSON valueForKey:@"message"]];
        }
    }
     
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        if (!flag)
        {
            return;
        }
        TTLog(@"error:%@", error);
        [self showToash:@"网络连接失败，请检查网络稍后重试"];
    }];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1 || buttonIndex != [alertView cancelButtonIndex])
    {
        NSURL *url = [NSURL URLWithString:updateString];
        if([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

-(void)willPresentAlertView:(UIAlertView *)alertView
{
    int intFlg = 0 ;//先是title intFlg = 0，当intFlg =1;message label
    for( UIView * view in alertView.subviews ){
        if( [view isKindOfClass:[UILabel class]] ){
            UILabel* label = (UILabel*) view;
            if(intFlg == 1){
                label.textAlignment = NSTextAlignmentLeft;
            }
            intFlg = 1;
        }
        
    }
}

@end
