//
//  BackButton.m
//  MYReporter
//
//  Created by jiaxiaochao on 14-3-7.
//  Copyright (c) 2014年 铭扬网. All rights reserved.
//

#import "BackButton.h"
#import "macro.h"
@implementation BackButton

+ (UIBarButtonItem*)backButton:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    
    button.frame = CGRectMake(0, 0, 30, 40);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return leftItem;
}

+ (NSArray *) leftButton:(id)target action:(SEL)action
{
    return [BackButton leftButton:target action:action title:@"返回"];
}

+ (NSArray *)leftButton:(id)target action:(SEL)action title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 44);
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColorRGB(125,125,125) forState:UIControlStateNormal];
    [button setTitleColor:UIColorRGB(94, 94, 94) forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
    [button setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [button sizeToFit];
    CGRect frame = button.frame;
    frame.size.width += 16;
    button.frame = frame;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
    {
        negativeSpacer.width = -12;
    }
    else
    {
        negativeSpacer.width = -1;
    }
    return [NSArray arrayWithObjects:negativeSpacer, leftItem, nil];
}

@end
