//
//  OrderTypeNewViewController.m
//  PalmPrintery
//
//  Created by PrinterpValue  on 15/4/7.
//  Copyright (c) 2015年 totem. All rights reserved.
//

#import "OrderTypeNewViewController.h"
#import "OrderTypeView.h"
#import "macro.h"
#import "AccountOrderTypeCell.h"
#import "APIClient.h"
#import "constant.h"
#import "DataModel.h"
#import "AppDelegate.h"
#import "OrderProductDetailTableViewController.h"
#import "SendMerchandiseTableViewController.h"
#import "SendingMerchandiseViewController.h"
#import "OLTableView.h"
#import "MJRefresh.h"
#import "OrderTypeTableViewCell.h"
#import "ProgressTimelineViewController.h"
#import "MyAccountViewController.h"

@interface OrderTypeNewViewController ()<UISearchBarDelegate>
@property (nonatomic, assign) long lastTag;
@property (nonatomic, retain) OrderTypeView *orderView;
@property (nonatomic, retain) NSDictionary *urlMap;
@end

@implementation OrderTypeNewViewController
- (id)init
{
    self = [super init];
    if (self) {
        self.lastTag = -1;
        self.title = @"我的订单";
        //tag对应的URL
        self.urlMap = @{@0:PATH_ORDER_WEI,@1:PATH_ORDER_ZAI,@2:PATH_ORDER_YI};
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configUI];
    [self registorRefresh:RefreshPullDownUp];
    [self showContentAtIndex:self.tag];
}


/**
 *  @author Ocean, 15-04-07
 *
 *  界面布局
 */
- (void) configUI
{
    self.orderView = [[OrderTypeView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 43) andTarget:self andAction:@selector(buttonAction:)];
    [self.view addSubview:self.orderView];
    
    
    self.searchBar.frame = CGRectMake(0, self.orderView.frame.size.height + self.orderView.frame.origin.y, self.view.frame.size.width, 44);
    self.searchBar.delegate = self;
    self.searchBar.barTintColor = SearchBarBackgroundColor;
    self.searchBar.placeholder = @"名称、单号";
    [self.view addSubview:self.searchBar];
    
    
    CGRect frame = self.searchBar.frame;
    frame.size.height = self.view.frame.size.height - self.searchBar.frame.size.height - self.orderView.frame.size.height - 20 -self.navigationController.navigationBar.frame.size.height;
    frame.origin.y = self.searchBar.frame.origin.y + self.searchBar.frame.size.height;
    self.tableView.frame = frame;
}

/**
 *  @author Ocean, 15-04-07
 *
 *  button点击事件
 *
 *  @param sender
 */
- (void) buttonAction:(UIButton*) sender
{
    [self EXbackButtonClick];
    long index = sender.tag;
    [self changeBageAtIndex:index];
    [self showContentAtIndex:index];
    if (self.dataSource.count != 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
}


/**
 *  @author Ocean, 15-04-07
 *
 *  找到nav中的上级页面消除bage的数字
 *
 *  @param index 第几个button
 */
- (void) changeBageAtIndex:(long) index
{
    NSArray *navArr =  [self.navigationController viewControllers];
    MyAccountViewController *vc = [navArr objectAtIndex:navArr.count-2];
    switch (index)
    {
        case 0:
            vc.orderType1.hidden = YES;
            break;
        case 1:
            vc.orderType2.hidden = YES;
            break;
        case 2:
            vc.orderType3.hidden = YES;
            break;
        default:
            break;
    }
}


/**
 *  @author Ocean, 15-04-07
 *
 *  显示当前的请求内容
 *
 *  @param index 第几个button
 */
- (void)showContentAtIndex:(long)index
{
    if (self.lastTag == index)
    {
        return;
    }
    
    self.lastTag = index;
    
    for (int i = 0; i < self.orderView.buttons.count; i++)
    {
        UIButton *button = [self.orderView.buttons objectAtIndex:i];
        if (i == index)
        {
            __weak typeof(self) weakSelf = self;
            UIColor *highlightColor = UIColorRGB(66, 148, 204);
            [button setTitleColor:highlightColor forState:UIControlStateNormal];
            [UIView animateWithDuration:0.1 animations:^
             {
                 CGRect frame = weakSelf.orderView.underLine.frame;
                 frame.origin.x = button.frame.origin.x;
                 weakSelf.orderView.underLine.frame = frame;
             }];
        }
        else
        {
            UIColor *normalColor = UIColorRGB(144, 144, 144);
            [button setTitleColor:normalColor forState:UIControlStateNormal];
        }
    }
    
    [self loadDataWithParameters:nil];
}


/**
 *  @author Ocean, 15-04-07
 *
 *  见父类
 *
 *  @param dict
 */
- (void) loadDataWithParameters:(NSDictionary*)dict
{
    [self showLoadingView];
    NSString* urlStr = (NSString*)[self.urlMap objectForKey:[NSNumber numberWithLong:self.lastTag]];
    __weak typeof(self) weakself = self;
    [[APIClient sharedClient] requestPath:urlStr
                               parameters:dict
                                  success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         [weakself hideLoadingView];
         Response *response = [Response responseWithDict:JSON];
         
         if(![weakself.tableView.footer isRefreshing]){
             [weakself.dataSource removeAllObjects];
         }
         
         if ([response isSuccess])
         {
             NSArray *array = [JSON objectForKey:@"data"];
             weakself.PageTotalRows = [[JSON objectForKey:@"rowcount"] integerValue];

              for (NSDictionary *dic in array)
             {
                 PPOrderProgress *model = [PPOrderProgress orderProgressWithDict:dic];
                 NSArray *data = [NSArray arrayWithObject:model];
                 [weakself.dataSource addObject:data];
             }
         }
         else
         {
             [weakself showToast:response.message];
         }
         
         [weakself stopRefreshing];
         [weakself.tableView reloadData];
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [weakself stopRefreshing];
         [weakself.dataSource removeAllObjects];
         [weakself.tableView reloadData];
         [weakself hideLoadingView];
         [weakself showToast:@"网络错误"];
     }];
}

#pragma mark TableDelegate

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuse = @"orderTypeTableViewCell";
    OrderTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if(nil == cell)
    {
        cell = [[OrderTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    
    cell.orderProgress = [self.dataSource[indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 100;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PPOrderProgress *orderInfo = [self.dataSource[indexPath.section] objectAtIndex:indexPath.row];
    if(self.lastTag == 1)
    {
        ProgressTimelineViewController *progress = [[ProgressTimelineViewController alloc] init];
        progress.orderProgress = orderInfo;
        [self.navigationController pushViewController:progress animated:YES];
    }
    else if(self.lastTag == 2)
    {
        SendingMerchandiseViewController *manager = [[UIStoryboard storyboardWithName:@"WelcomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"SendingMerchandiseViewController"];
        manager.sendProgress = orderInfo;
        manager.style = self.lastTag;
        [self.navigationController pushViewController:manager animated:YES];
    }
    else
    {
        return;
    }
}


#pragma mark searchBar delegate

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.button.hidden = NO;
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    self.button.hidden = YES;
    [self.searchBar resignFirstResponder];
    [self loadDataWithParameters:@{@"searchkey":self.searchBar.text}];
    
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
