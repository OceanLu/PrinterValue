//
//  SettingViewController.m
//  PalmPrintery
//
//  Created by Jia Xiaochao on 14/12/24.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "SectionHeaderView.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


/* add by Liuhy 2015-3-23 将菜单分割多段，添加CGContext相关属性*/
- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SectionHeaderView *header = [[SectionHeaderView alloc] init];
    header.backgroundColor = tableView.backgroundColor;
    header.type = HearderLineAll;
    if(section == BasicSettingSection)
    {
        header.type = HearderDonwLineOnly;
    }
    else if(section == SectionHeaderMax)
    {
        header.type = HearderUpLineOnly;
    }
    [header setFrame:CGRectMake(0, 0, self.view.frame.size.width, tableView.sectionHeaderHeight)];

    return header;
}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    CGFloat height;
    if(section == BasicSettingSection || section == LogoutSection)
    {
        height = STANDARD_HIGHT;
    }
    else
    {
        height = STANDARD_STATUTBAR_HIGHT;
    }
    
    return height;
}
/*add end*/



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.section)
    {

        case 0:
            break;
        case 1:
        {
            if(indexPath.row == 2 )
            {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"版本升级"
                                                                   message:@"检测到新版本，请及时更新!"
                                                                  delegate:self
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:@"取消", nil];
                alert.tag = 100;
                [alert show];
            }
        }
            break;
        case 2:
        {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"退出"
                                                           message:@"真的要注销当前用户并退出应用吗？"
                                                          delegate:self
                                                 cancelButtonTitle:@"是"
                                                 otherButtonTitles:@"否", nil];
            alert.tag = 101;
            [alert show];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark -
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex])
    {
        if (alertView.tag == 100)
        {
            NSURL *url = [NSURL URLWithString:@"http://totemtec.sinaapp.com/PalmPrintery"];
            if([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        else if (alertView.tag == 101)
        {
            SharedAppDelegate.user = nil;
            UIWindow *window = SharedAppDelegate.window;
            [UIView animateWithDuration:1.0f animations:^{
                window.alpha = 0;
                window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
            } completion:^(BOOL finished) {
                exit(0);
            }];
        }
    }
}

@end
