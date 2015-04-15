//
//  HYBaseViewController.m
//  PalmPrintery
//
//  Created by PrinterpValue  on 15/3/25.
//  Copyright (c) 2015年 totem. All rights reserved.
//

#import "HYBaseViewController.h"
#import "MJRefresh.h"

@interface HYBaseViewController ()

@end

@implementation HYBaseViewController
/**
 *  @author Ocean, 15-04-07
 *
 *  数据加载函数---子类实现
 *
 *  @param parameters Http请求参数
 */
- (void)loadDataWithParameters:(NSDictionary *) parameters
{
    //sub Class
}


/**
 *  @author Ocean, 15-04-07
 *
 *  tableview get函数
 *
 *  @return 初始化的Table
 */
- (UITableView*) tableView
{
    if(nil == _tableView)
    {
        CGRect tableViewFrame = self.view.bounds;
        
        tableViewFrame.size.height -= self.navigationController.viewControllers.count > 1 ? 0 :(self.tabBarController.tabBar.bounds.size.height + [[[UIDevice currentDevice] systemVersion] integerValue] > 7.0 ? 44 : 0);
        
        _tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:self.tableviewStyle];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [[UIView alloc] init];
        if(![_tableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            if(self.tableviewStyle == UITableViewStyleGrouped)
            {
                UIView *backgroud = [[UIView alloc] initWithFrame:_tableView.bounds];
                backgroud.backgroundColor = _tableView.backgroundColor;
                _tableView.backgroundView = backgroud;
            }
        }
        
        if(self.tabBarController)
        {
            UIEdgeInsets scrollIndicatorInsets = _tableView.scrollIndicatorInsets;
            scrollIndicatorInsets.bottom -= CGRectGetHeight(self.tabBarController.tabBar.bounds);
            _tableView.scrollIndicatorInsets = scrollIndicatorInsets;
        }
        
        
    }
    return _tableView;
}
/**
 *  @author Ocean, 15-04-07
 *
 *  数据源Get
 *
 *  @return dataSource初始化
 */
- (NSMutableArray*) dataSource
{
    if(nil == _dataSource)
    {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}
/**
 *  @author Ocean, 15-04-07
 *
 *  searchBar Get
 *
 *  @return searchBar初始化
 */
- (UISearchBar*) searchBar
{
    if (nil == _searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
        _searchBar.barTintColor = SearchBarBackgroundColor;
        _searchBar.layer.borderWidth = 1;
        _searchBar.layer.borderColor = [SearchBarBackgroundColor  CGColor];
        [self.view addSubview:_searchBar];
    }
    return _searchBar;
}


#pragma mark LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.Pagecount = 1;
    self.PageTotalRows = 0;
    [self.view addSubview:self.tableView];
    
    
    self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.button setFrame:self.view.frame];
    self.button.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:self.button aboveSubview:self.tableView];
    self.button.hidden = YES;
    
    [self.button addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

- (void) backButtonClick:(UIButton*) sender
{
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    self.button.hidden = YES;
}

- (void) EXbackButtonClick
{
    [self backButtonClick:nil];
}

- (void) dealloc
{
    self.dataSource = nil;
    self.tableView = nil;
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

#pragma mark tableview delegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //子类实现
    return nil;
}


/**
 *  @author Ocean, 15-03-31
 *
 *  注册上下拉
 *
 *  @param state 刷新的类别
 */
- (void) registorRefresh:(RefreshStateForUser)state
{
    __weak typeof(self) weakSelf = self;
    //下拉
    if(state != RefreshPullUp)
    {
        self.tableView.header.updatedTimeHidden = YES;
        
        [self.tableView addLegendFooterWithRefreshingBlock:^{
            
            weakSelf.Pagecount ++;
            NSInteger excessNumber = weakSelf.PageTotalRows%PAGESIZE;
            NSInteger divisionNumber  = weakSelf.PageTotalRows/PAGESIZE;
            
            if(excessNumber != 0)
            {
                divisionNumber ++;
            }
            
            if(weakSelf.Pagecount <= divisionNumber)
            {
                [weakSelf loadDataWithParameters:PAGE_REQUEST_PARAMETER(weakSelf.Pagecount)];
            }
            else
            {
                weakSelf.tableView.footer.hidden = YES;
            }
            
        }];
    }
    
    //上拉
    if(state != RefreshPullDown)
    {
        self.tableView.footer.automaticallyRefresh = NO;
        
        [self.tableView  addLegendHeaderWithRefreshingBlock:^{
            
            weakSelf.Pagecount = 1;
            weakSelf.tableView.footer.hidden = NO;
            [weakSelf loadDataWithParameters:PAGE_REQUEST_PARAMETER(weakSelf.Pagecount)];
            
        }];
        
    }
}


- (void) stopRefreshing
{
    if(self.tableView.header.isRefreshing)
    {
        [self.tableView.header endRefreshing];
    }
    else if(self.tableView.footer.isRefreshing)
    {
        [self.tableView.footer endRefreshing];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
