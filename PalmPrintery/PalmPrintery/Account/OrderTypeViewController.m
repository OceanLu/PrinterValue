//
//  OrderTypeViewController.m
//  PalmPrintery
//
//  Created by Jia Xiaochao on 14/12/22.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "OrderTypeViewController.h"
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
@interface OrderTypeViewController ()<refreshInterFace>
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *tagButtons;
@property (strong, nonatomic) IBOutlet UIImageView *lineImageView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIButton *hideButton;
@property (weak, nonatomic) IBOutlet OLTableView *tableViewWei;

@property (nonatomic) long lastTag;
@property (strong, nonatomic)NSMutableArray *orderArray;
@end

@implementation OrderTypeViewController

- (IBAction)hideKBoard:(id)sender
{
    self.hideButton.hidden = YES;
    [self.searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.hideButton.hidden = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.hideButton.hidden = YES;
    [self.searchBar resignFirstResponder];
    
    [self loadDataWithParameters:@{@"searchkey":self.searchBar.text}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshControll];

    self.hideButton.hidden = YES;
    self.lastTag = -1;
    self.orderArray = [NSMutableArray array];
    [self showContentAtIndex:self.tag];
}

- (void) refreshControll
{
    self.tableViewWei.count = 1;
    self.tableViewWei.refreshInterFace = self;
    self.tableViewWei.tatolRows = 0;
    [self.tableViewWei registorRefresh:RefreshPullDownUp];
}
/**
 *  @author Ocean, 15-04-01
 *
 *  下拉刷新方法，来自tableview
 */
- (void) dealPullUpRefresh
{
    self.tableViewWei.count = 1;
    self.tableViewWei.footer.hidden = NO;
    [self loadDataWithParameters:PAGE_REQUEST_PARAMETER(self.tableViewWei.count)];
    
}

/**
 *  @author Ocean, 15-04-01
 *
 *  上拉加载方法，来自tableview
 */
- (void) dealPullDownRefresh
{
    
    self.tableViewWei.count++;
    NSInteger excessNumber = self.tableViewWei.tatolRows%PAGESIZE;
    NSInteger divisionNumber  =self.tableViewWei.tatolRows/PAGESIZE;
    
    if(excessNumber != 0)
    {
        divisionNumber ++;
    }
    
    if(self.tableViewWei.count <= divisionNumber)
    {
        [self loadDataWithParameters:PAGE_REQUEST_PARAMETER(self.tableViewWei.count)];
    }
    else
    {
        self.tableViewWei.footer.hidden = YES;
    }
    
}


- (IBAction)changeTagAction:(UIButton *)sender
{
    long index = [sender tag];
    
    [self showContentAtIndex:index];
}

- (void)showContentAtIndex:(long)index
{
    if (self.lastTag == index)
    {
        return;
    }

    self.hideButton.hidden = YES;
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    
    self.lastTag = index;
    
    for (int i = 0; i < self.tagButtons.count; i++)
    {
        UIButton *button = [self.tagButtons objectAtIndex:i];
        if (i == index)
        {
            UIColor *highlightColor = UIColorRGB(66, 148, 204);
            [button setTitleColor:highlightColor forState:UIControlStateNormal];
            [UIView animateWithDuration:0.1 animations:^
             {
                 CGRect frame = self.lineImageView.frame;
                 frame.origin.x = button.frame.origin.x;
                 self.lineImageView.frame = frame;
             }];
        }
        else
        {
            UIColor *normalColor = UIColorRGB(144, 144, 144);
            [button setTitleColor:normalColor forState:UIControlStateNormal];
        }
    }
    [self loadDataWithParameters:PAGE_REQUEST_PARAMETER(self.tableViewWei.count)];
}


- (NSString*) getUrl
{
    NSString *urlStr;
    switch (self.lastTag)
    {
        case 0:
            urlStr = PATH_ORDER_WEI;
            break;
        case 1:
            urlStr = PATH_ORDER_ZAI;
            break;
        case 2:
            urlStr = PATH_ORDER_DAI;
            break;
        case 3:
            urlStr = PATH_ORDER_YI;
            break;
        default:
            break;
    }
    return urlStr;
}

- (void) loadDataWithParameters:(NSDictionary*)dict
{
    [self showLoadingView];
    NSString* urlStr = [self getUrl];
    __weak typeof(self) weakself = self;
    [[APIClient sharedClient] requestPath:urlStr
                               parameters:dict
                                  success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         [weakself hideLoadingView];
         Response *response = [Response responseWithDict:JSON];
         [weakself.orderArray removeAllObjects];
         if ([response isSuccess])
         {
             NSArray *array = [JSON objectForKey:@"data"];
             weakself.tableViewWei.tatolRows = (NSInteger)[JSON objectForKey:@"rowcount"];
             if (weakself.tableViewWei.header.isRefreshing) {
                 [weakself.orderArray removeAllObjects];
             }
             for (NSDictionary *dic in array)
             {
                 [weakself.orderArray addObject:[PPOrderProgress orderProgressWithDict:dic]];
             }
         }
         else
         {
             [weakself showToast:response.message];
         }
         [weakself.tableViewWei endRefresh];
         [weakself.tableViewWei reloadData];
     }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [weakself.orderArray removeAllObjects];
         [weakself.tableViewWei reloadData];
         [weakself hideLoadingView];
         [weakself showToast:@"网络错误"];
         [weakself.tableViewWei endRefresh];
     }];

}


#pragma mark -UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AccountOrderTypeCell";
    AccountOrderTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.orderInfo = [self.orderArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.lastTag == 0)
    {
        return;
    }
    PPOrderProgress *orderInfo = [self.orderArray objectAtIndex:indexPath.row];
//    if (orderInfo.dataOver.length == 0)
//    {
//        OrderProductDetailTableViewController *manager = [[UIStoryboard storyboardWithName:@"WelcomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderProductDetailTableViewController"];
//        manager.orderProgress = orderInfo;
//        manager.style = self.lastTag;
//        [self.navigationController pushViewController:manager animated:YES];
//    }
//    else
//    {
//        SendMerchandiseTableViewController *manager = [[UIStoryboard storyboardWithName:@"WelcomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"SendMerchandiseTableViewController"];
//        manager.sendProgress = orderInfo;
//        manager.style = self.lastTag;
//        [self.navigationController pushViewController:manager animated:YES];
//    }
    if(self.lastTag == 1){
        OrderProductDetailTableViewController *manager = [[UIStoryboard storyboardWithName:@"WelcomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderProductDetailTableViewController"];
        manager.orderProgress = orderInfo;
        manager.style = self.lastTag;
        [self.navigationController pushViewController:manager animated:YES];
    }
    if(self.lastTag == 2){
        SendMerchandiseTableViewController *manager = [[UIStoryboard storyboardWithName:@"WelcomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"SendMerchandiseTableViewController"];
        manager.sendProgress = orderInfo;
        manager.style = self.lastTag;
        [self.navigationController pushViewController:manager animated:YES];
    }
    if(self.lastTag == 3){
        SendingMerchandiseViewController *manager = [[UIStoryboard storyboardWithName:@"WelcomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"SendingMerchandiseViewController"];
        manager.sendProgress = orderInfo;
        manager.style = self.lastTag;
        [self.navigationController pushViewController:manager animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}


@end
