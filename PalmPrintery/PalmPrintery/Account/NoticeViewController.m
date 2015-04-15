//
//  NoticeViewController.m
//  PalmPrintery
//
//  Created by Jia Xiaochao on 14/12/24.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "NoticeViewController.h"

@interface NoticeViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *noticeButtons;

@end

@implementation NoticeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    for (UIButton *button in self.noticeButtons)
    {
        if (button.tag == 0)
        {
            [button setImage:[UIImage imageNamed:@"notice_not_check"] forState:UIControlStateNormal];
        }
        else
        {
            [button setImage:[UIImage imageNamed:@"notice_check"] forState:UIControlStateNormal];
        }
    }
}
- (IBAction)noticeAction:(UIButton *)button
{
    if (button.tag == 1)
    {
        [button setImage:[UIImage imageNamed:@"notice_not_check"] forState:UIControlStateNormal];
        button.tag = 0;
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"notice_check"] forState:UIControlStateNormal];
        button.tag = 1;
    }
}

@end
