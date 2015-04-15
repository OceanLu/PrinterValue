//
//  LoginViewController.m
//  PalmPrintery
//
//  Created by Ma Jianglin on 12/20/14.
//  Copyright (c) 2014 totem. All rights reserved.
//

#import "LoginViewController.h"
#import "APIClient.h"
#import "constant.h"
#import "DataModel.h"
#import "macro.h"
#import "AppDelegate.h"
#import "TPKeyboardAvoidingClickDone.h"

@interface LoginViewController ()<TPKeyboardAvoidingClickDone>

@property(nonatomic, strong) IBOutlet UITextField *usernameField;
@property(nonatomic, strong) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (IBAction)forgotPassword:(id)sender
{
    
}

- (IBAction)loginAction:(id)sender
{
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    if (username.length == 0 || password.length == 0)
    {
        [self showToast:@"用户名密码不能为空"];
        return;
    }
    
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    [self showLoadingViewWithMessage:@"登录中..."];
    
    NSDictionary *params = @{@"username":username, @"password":password};
    
    APIClient *client = [APIClient sharedClient];
    [client GET:PATH_LOGIN
     parameters:params
        success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         [self hideLoadingView];
         
         Response *response = [Response responseWithDict:JSON];
         if ([response isSuccess])
         {
             NSDictionary *dict = [JSON objectForKey:@"data"];
             PPUser *user = [PPUser userWithDict:dict];
             SharedAppDelegate.user = user;
             
             [self dismissViewControllerAnimated:YES completion:nil];
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

- (BOOL) TPKeyboardAvoidingCilickDone
{
    [self loginAction:nil];
    return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.usernameField.text = SharedAppDelegate.user.userName;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{

}
@end
