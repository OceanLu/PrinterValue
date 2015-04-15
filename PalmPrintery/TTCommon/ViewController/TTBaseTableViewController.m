//
//  TTBaseTableViewController.m
//  ReadTV
//
//  Created by Ma Jianglin on 2/9/14.
//  Copyright (c) 2014 readtv.cn. All rights reserved.
//

#import "TTBaseTableViewController.h"
#import "MBProgressHUD.h"
#import "macro.h"
#import "AppDelegate.h"
#import "UIView+Toast.h"
#import "TTRefreshTableFooterView.h"
#import "SDImageCache.h"


@interface TTBaseTableViewController()
{
    MBProgressHUD *HUD;
}


@end

@implementation TTBaseTableViewController


-(void)showToash:(NSString *)message
{
    [SharedAppDelegate.window makeToast:message duration:1.0 position:@"center"];
}

- (void)backAction:(id)sender
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setBackButton
{
    //    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
    //    {
    //        return;
    //    }
    
    if (self.navigationController.viewControllers.count == 0 || self.navigationController.viewControllers[0] == self)
    {
        return;
    }
    
    UIImage *backImage = [UIImage imageNamed:@"navi_back"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 44);
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    [backButton setTitleColor:UIColorRGB(125,125,125) forState:UIControlStateNormal];
//    [backButton setTitleColor:UIColorRGB(94, 94, 94) forState:UIControlStateHighlighted];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
    
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [backButton addTarget:self
                   action:@selector(backAction:)
         forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIBarButtonItem *leftSpace = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                  target:nil action:nil];
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
    {
        leftSpace.width = -12;
    }
    else
    {
        leftSpace.width = -1;
    }
    self.navigationItem.leftBarButtonItems = @[leftSpace, backItem];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navi_bg"]];
    [self setBackButton];
//    [self.tabBarController.tabBar setSelectedImageTintColor:UIColorRGB(167, 79, 176)];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [self.refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
}

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (self.dataCount - 1 == indexPath.row && !_loading)
//    {
//        self.dataCount = 0;
//        [self loadMore];
//    }
//}

- (void)loadData
{
    NSAssert(NO, @"loadData method must be override!");
}

- (void)showLoadMore
{
    if (_hasMore)
    {
        if (_footerView == nil)
        {
            _footerView = [TTRefreshTableFooterView new];
            [_footerView setMoreDataLoader:self];
        }
        
        self.tableView.tableFooterView = _footerView;
    }
    else
    {
        self.tableView.tableFooterView = nil;
    }
}

#pragma mark - MBProgressHUD

- (void)showLoadingView
{
    [self showLoadingViewWithMessage:nil];
}

- (void)showLoadingViewWithMessage:(NSString *)message
{
    [self hideLoadingView];
    
    HUD = [[MBProgressHUD alloc] initWithView:SharedAppDelegate.window];
	[SharedAppDelegate.window addSubview:HUD];
	
//    HUD.dimBackground = YES;
    HUD.labelText = message;
    [HUD show:YES];
    HUD.removeFromSuperViewOnHide = YES;
}

- (void)hideLoadingView
{
    if (HUD)
    {
        [HUD hide:YES];
        HUD = nil;
    }
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [HUD removeFromSuperview];
    HUD = nil;
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

//下拽刷新，开始加载第1页数据
- (void)refreshData:(id)sender
{
    //加载第1页
	_loading = YES;
    _lastId = 0;
	[self loadData];
}

//点击更多按钮，或者底部上拽加载更多
- (void)loadMore
{
    if (_hasMore)
    {
        _loading = YES;
        [_footerView displayIndicator];
        
        [self loadData];
    }
}

//完成加载数据
- (void)doneLoadingData
{
    _loading = NO;
    [self.tableView reloadData];
    
    [_footerView hideIndicator];
    [self.refreshControl endRefreshing];
    [self showLoadMore];
}

//这个是处理数据条数不够一屏的情况
- (float)tableViewHeight
{
    if (self.tableView.contentSize.height < self.tableView.frame.size.height)
    {
        return self.tableView.frame.size.height;
    }
    else
    {
        return self.tableView.contentSize.height;
    }
}

//这个是处理数据条数不够一屏的情况
- (float)endOfTableView:(UIScrollView *)scrollView
{
    
    return [self tableViewHeight] - scrollView.bounds.size.height - scrollView.bounds.origin.y;
}
#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate)
    {
        [self performSelector:@selector(loadMore:) withObject:scrollView afterDelay:0.5f];
    }
    else
    {
        [self loadMore:scrollView];
    }
    
}

-(void)loadMore:(UIScrollView *)scrollView
{
    if ([self endOfTableView:scrollView] <= 30 && !_loading)
    {
        [self loadMore];
    }
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if ([self endOfTableView:scrollView] <= 30 && !_loading)
//    {
//        [self loadMore];
//    }
//}

#pragma mark -
#pragma mark Memory Management

- (void)viewDidUnload
{
    [super viewDidUnload];
	_footerView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)dealloc
{
	_footerView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
}

@end
