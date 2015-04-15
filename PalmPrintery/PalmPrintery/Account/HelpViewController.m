//
//  HelpViewController.m
//  PalmPrintery
//
//  Created by Jia Xiaochao on 14/12/24.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController () <UITextViewDelegate>
{
    UITextView *_textView;
}
@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    [self viewConfig];
    // Do any additional setup after loading the view.
}


- (void) viewConfig
{
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40, self.view.frame.size.height/3)];
    [self.view addSubview:_textView];
    _textView.layer.borderColor = UIColor.grayColor.CGColor;
    _textView.layer.borderWidth = 1;
    _textView.layer.cornerRadius = 6;
    _textView.layer.masksToBounds = YES;
    
    UIButton *feedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    feedButton.frame = CGRectMake(20, _textView.frame.size.height + _textView.frame.origin.y + 20, self.view.frame.size.width-40, 44);
    [feedButton setTitle:@"发送" forState:UIControlStateNormal];
    [feedButton setTintColor:[UIColor whiteColor]];
    feedButton.backgroundColor = [UIColor colorWithRed:81/255.0 green:149/255.0 blue:201/255.0 alpha:1];
    [feedButton addTarget:self action:@selector(feedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:feedButton];

}


- (void) feedButtonClick:(UIButton*) sender
{
    [_textView resignFirstResponder];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textView resignFirstResponder];
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    [_textView resignFirstResponder];
}
@end
