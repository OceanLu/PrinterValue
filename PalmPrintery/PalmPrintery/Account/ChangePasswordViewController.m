//
//  ChangePasswordViewController.m
//  PalmPrintery
//
//  Created by Jia Xiaochao on 14/12/24.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "APIClient.h"
#import "constant.h"
#import "DataModel.h"
#import "AppDelegate.h"

@interface ChangePasswordViewController ()

@property (strong, nonatomic) IBOutlet UITextField *passwordOldTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordNewTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordAgainTextField;
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)changeAction:(id)sender
{
    if (self.passwordOldTextField.text.length <=0)
    {
        [self showToast:@"请输入原始密码"];
        return;
    }
    else if (self.passwordNewTextField.text.length <=0)
    {
        [self showToast:@"请输入新密码"];
        return;
    }
    else if (![self.passwordAgainTextField.text isEqualToString:self.passwordNewTextField.text])
    {
        [self showToast:@"确认密码不正确"];
        return;
    }
    
    [self showLoadingView];
    [[APIClient sharedClient] requestPath:PATH_CHANGE_PASSWORD
                               parameters:@{@"userid":[NSNumber numberWithLongLong:SharedAppDelegate.user.userId]
                                            ,@"oldPassword":self.passwordOldTextField.text,
                                            @"newPassword":self.passwordNewTextField.text}
                                  success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         [self hideLoadingView];
         Response *response = [Response responseWithDict:JSON];

         if ([response isSuccess])
         {
             NSDictionary *dict = [JSON objectForKey:@"data"];
             PPUser *user = [PPUser userWithDict:dict];
             SharedAppDelegate.user = user;
             [self showToast:@"密码修改成功"];
             [self.navigationController popViewControllerAnimated:YES];
         }
         else
         {
             [self showToast:response.message];
         }
     }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self hideLoadingView];
         [self showToast:@"网络错误"];
     }];

    
}

@end
