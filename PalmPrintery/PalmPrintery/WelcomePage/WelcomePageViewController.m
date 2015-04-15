//
//  WelcomePageViewController.m
//  PalmPrintery
//
//  Created by zhiyong on 14/12/20.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "WelcomePageViewController.h"
#import "SMPageControl.h"
#import "WethrView.h"
@interface WelcomePageViewController ()
@property (weak, nonatomic) IBOutlet GBInfiniteScrollView *scrollView;
@property (weak, nonatomic) IBOutlet SMPageControl *pageControl;

@property (strong, nonatomic) NSArray *welcomeImageList;

@end

@implementation WelcomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
/*
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
    {
        
        UIView *statusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        statusBar.backgroundColor = [UIColor blackColor];
        [self.view addSubview:statusBar];
    }
   */ 
    // Do any additional setup after loading the view.
    self.scrollView.infiniteScrollViewDataSource = self;
    self.scrollView.infiniteScrollViewDelegate = self;
    self.scrollView.pageIndex = 0;
    
    self.pageControl.indicatorMargin = 8;
    self.pageControl.indicatorDiameter = 10;
    self.pageControl.alignment = SMPageControlAlignmentCenter;
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    
    [self.scrollView reloadData];
    
    
//    [self.scrollView startAutoScroll];
    
    self.pageControl.numberOfPages = self.welcomeImageList.count;
    
    if (self.welcomeImageList.count <= 1)
    {
        self.pageControl.hidden = YES;
    }
    else
    {
        self.pageControl.hidden = NO;
    }
    self.pageControl.currentPage = 0;

    WethrView *weather = [[WethrView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame) - 190, 10, 180, 180)];
    weather.canChangeTempType = YES;
    weather.showsTempType = YES;
    [self.view addSubview:weather];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - BGInfiniteScrollViewDelegate


- (void)infiniteScrollViewDidScrollNextPage:(GBInfiniteScrollView *)infiniteScrollView
{
    if (self.pageControl.currentPage + 1 < self.welcomeImageList.count)
    {
        self.pageControl.currentPage++;
    }
    else
    {
        self.pageControl.currentPage = 0;
    }
}


- (void)infiniteScrollViewDidScrollPreviousPage:(GBInfiniteScrollView *)infiniteScrollView
{
    if (self.pageControl.currentPage - 1 >= 0)
    {
        self.pageControl.currentPage--;
    }
    else
    {
        self.pageControl.currentPage = self.welcomeImageList.count - 1;
    }
}


#pragma mark - BGInfiniteScrollViewDataSource


- (NSInteger)numberOfPagesInInfiniteScrollView:(GBInfiniteScrollView *)infiniteScrollView
{
    return self.welcomeImageList.count;
}


- (UIButton *)infiniteScrollView:(GBInfiniteScrollView *)infiniteScrollView pageAtIndex:(NSUInteger)index;
{
    UIButton *page = (UIButton*)[infiniteScrollView dequeueReusablePage];
    if (page == nil)
    {
        page = [[UIButton alloc] initWithFrame:self.scrollView.bounds];
//        [page addTarget:self action:@selector(openFocus:) forControlEvents:UIControlEventTouchUpInside];
        page.backgroundColor = [UIColor grayColor];
        //        [page setBackgroundImage:[UIImage imageNamed:@"LaunchImage"] forState:UIControlStateNormal];
    }
    
    if (index < self.welcomeImageList.count)
    {
        NSString *name = [self.welcomeImageList objectAtIndex:index];
        if (name == nil) return page;
        
//        [page sd_setBackgroundImageWithURL:[NSURL URLWithString:focus.image] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loadingfalse"]];
        [page setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        
        page.tag = index;
        page.adjustsImageWhenHighlighted = NO;
    }
    
    return page;
}


- (NSArray *)welcomeImageList{
    if(_welcomeImageList == nil){
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"welcomePage" ofType:@".plist"];
        _welcomeImageList = [NSArray arrayWithContentsOfFile:path];
    }
    return _welcomeImageList;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
