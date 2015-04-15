//
//  TTGuideViewController.m
//  GHS
//
//  Created by Ma Jianglin on 9/26/14.
//  Copyright (c) 2014 ghs.net. All rights reserved.
//

#import "TTGuideViewController.h"
#import "macro.h"
#import "AppDelegate.h"
#import "SMPageControl.h"

#define GUIDE_PAGE_WIDTH    320
#define GUIDE_PAGE_COUNT    3

@interface TTGuideViewController ()
{
    BOOL pageControlUsed;
    UIScrollView    *_scrollView;
    SMPageControl   *_pageControl;
}

@end

@implementation TTGuideViewController

#define APP_HAS_LAUNCHED    @"net.ghs.app.launched"

+ (void) showGuide
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    BOOL hasLaunched = [prefs boolForKey:APP_HAS_LAUNCHED];
    if (!hasLaunched)
    {
        TTGuideViewController *guide = [[TTGuideViewController alloc] init];
        guide.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [SharedAppDelegate.window.rootViewController presentViewController:guide
                                                                  animated:NO
                                                                completion:nil];
        
        [prefs setBool:YES forKey:APP_HAS_LAUNCHED];
        [prefs synchronize];
    }
}
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
- (void)initGuideView
{
    self.view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    NSBundle *bundle = [NSBundle mainBundle];
    for (int i = 0; i < GUIDE_PAGE_COUNT; i++)
    {
        UIImageView *guideImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*GUIDE_PAGE_WIDTH, 0, GUIDE_PAGE_WIDTH, self.view.bounds.size.height)];
        guideImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        NSString *imageName;
        if (!iPhone5)
        {
            imageName = [NSString stringWithFormat:@"guide_4_%i@2x.png", i];
        }else
        {
            imageName = [NSString stringWithFormat:@"guide_%i@2x.png", i];
        }
        
        
        
        NSString *imagePath = [bundle pathForResource:imageName ofType:nil];
        guideImageView.image = [[UIImage alloc] initWithContentsOfFile:imagePath];
        [_scrollView addSubview:guideImageView];
//            if (i == GUIDE_PAGE_COUNT - 1)
//            {
//                UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 102, 33)];
//                [button setBackgroundImage:[UIImage imageNamed:@"guide_in.png"] forState:UIControlStateNormal];
//                [button addTarget:self action:@selector(enter:) forControlEvents:UIControlEventTouchUpInside];
//                button.center = CGPointMake(320*3 + 160, 240);
//                [_scrollView addSubview:button];
//            }
    }
    
    _scrollView.contentSize = CGSizeMake(GUIDE_PAGE_WIDTH*GUIDE_PAGE_COUNT, 0);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(GUIDE_PAGE_WIDTH*(GUIDE_PAGE_COUNT-1) + 35,  self.view.bounds.size.height - 145, 250, 50);
    //button.backgroundColor = [UIColor redColor];
    [button setImage:[UIImage imageNamed:@"guide_button"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(enter:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:button];

    
    _pageControl = [[SMPageControl alloc] initWithFrame:CGRectMake(30, self.view.bounds.size.height - 50, 260, 50)];
    _pageControl.numberOfPages = GUIDE_PAGE_COUNT;
    _pageControl.currentPage = 0;
    _pageControl.indicatorMargin = 8;
    _pageControl.indicatorDiameter = 6;
    _pageControl.enabled = NO;
//    _pageControl.alignment = SMPageControlAlignmentLeft;
    _pageControl.pageIndicatorTintColor = GHS_GRAY_COLOR;
    _pageControl.currentPageIndicatorTintColor = GHS_LOGO_COLOR;
    
    [self.view addSubview:_pageControl];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initGuideView];
}

- (void)enter:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x>GUIDE_PAGE_WIDTH*(GUIDE_PAGE_COUNT-1)+64)
    {
		[self enter:nil];
    }
    else
    {
        if (pageControlUsed)
        {
            return;
        }
        
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        _pageControl.currentPage = page;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

@end
