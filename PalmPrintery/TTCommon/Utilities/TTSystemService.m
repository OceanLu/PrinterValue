//
//  TTSystemService.m
//  EBCCard
//
//  Created by Ma Jianglin on 3/21/13.
//  Copyright (c) 2013 totemtec.com. All rights reserved.
//

#import "TTSystemService.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import "UIView+Toast.h"
#import "macro.h"


@interface TTSystemService() <MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate>

@end

static TTSystemService *_sharedService = nil;

@implementation TTSystemService

+(id)alloc
{
    @synchronized([TTSystemService class])
    {
        NSAssert(_sharedService == nil, @"Attempted to allocate a second instance of a singleton.");
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

+ (TTSystemService*)sharedService
{
    @synchronized([TTSystemService class])
    {
        if (!_sharedService)
        {
            _sharedService = [[TTSystemService alloc] init];
        }
    }
    return _sharedService;
}

- (void)openURL:(NSString*)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    if([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)callTelephone:(NSString*)number
{
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType  isEqualToString:@"iPod touch"]||[deviceType  isEqualToString:@"iPad"]||[deviceType  isEqualToString:@"iPhone Simulator"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您的设备不能打电话" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (number.length == 0) return;
    
    NSString *urlStr = [NSString stringWithFormat:@"tel://%@", number];
    [self openURL:urlStr];
}

#pragma mark - Send Email

- (void)sendEmailTo:(NSArray*)emailAddresses withSubject:(NSString*)subject andMessageBody:(NSString*)emailBody
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        [picker setSubject:subject];
        [picker setToRecipients:emailAddresses];
        
// Attach an image to the email
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"jpg"];
//        NSData *myData = [NSData dataWithContentsOfFile:path];
//        [picker addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"rainy"];
        
        [picker setMessageBody:emailBody isHTML:NO];
        
        [SharedAppDelegate.window.rootViewController presentViewController:picker animated:YES completion:NULL];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您的设备没有配置邮箱帐号"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	switch (result)
	{
		case MFMailComposeResultCancelled:
			[SharedAppDelegate.window makeToast:@"邮件已取消"];
//            [SharedAppDelegate.window showToastWithDuration:1.0f message:@"邮件已取消" isSuccessToast:NO];
			break;
		case MFMailComposeResultSaved:
			[SharedAppDelegate.window makeToast:@"邮件已保存"];
//            [SharedAppDelegate.window showToastWithDuration:1.0f message:@"邮件已保存" isSuccessToast:YES];
			break;
		case MFMailComposeResultSent:
			[SharedAppDelegate.window makeToast:@"邮件发送成功"];
//            [SharedAppDelegate.window showToastWithDuration:1.0f message:@"邮件发送成功" isSuccessToast:YES];
			break;
		case MFMailComposeResultFailed:
			[SharedAppDelegate.window makeToast:@"邮件发送失败"];
//            [SharedAppDelegate.window showToastWithDuration:1.0f message:@"邮件发送失败" isSuccessToast:NO];
			break;
		default:
			break;
	}
    
	[SharedAppDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Send Message

- (void)sendMessageTo:(NSArray*)phoneNumbers withMessageBody:(NSString*)messageBody
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
	picker.messageComposeDelegate = self;
	picker.recipients = phoneNumbers;
    picker.body = messageBody;
    
    [SharedAppDelegate.window.rootViewController presentViewController:picker animated:YES completion:NULL];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
	switch (result)
    {
        case MessageComposeResultCancelled:
            [SharedAppDelegate.window makeToast:@"短消息已取消"];
//            [SharedAppDelegate.window showToastWithDuration:1.0f message:@"短消息已取消" isSuccessToast:YES];
            break;
        case MessageComposeResultSent:
            [SharedAppDelegate.window makeToast:@"短消息已发送"];
//            [SharedAppDelegate.window showToastWithDuration:1.0f message:@"短消息已发送" isSuccessToast:YES];
            break;
        case MessageComposeResultFailed:
            [SharedAppDelegate.window makeToast:@"短消息发送失败"];
//            [SharedAppDelegate.window showToastWithDuration:1.0f message:@"短消息发送失败" isSuccessToast:NO];
            break;
        default:
            break;
    }
    
    [SharedAppDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
