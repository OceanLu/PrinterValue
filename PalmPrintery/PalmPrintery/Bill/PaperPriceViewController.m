//
//  PaperPriceViewController.m
//  PalmPrintery
//
//  Created by qihang on 14/12/22.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "PaperPriceViewController.h"
#import "PaperPriceTableViewCell.h"
#import "MJRefresh.h"
#import "APIClient.h"
#import "constant.h"
#import "DataModel.h"

@interface PaperPriceViewController ()
@property (nonatomic, strong) NSMutableArray *paperData;
@property (nonatomic, strong) UIButton *hideSearBar;

@end

@implementation PaperPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.paperData = [NSMutableArray array];
    [self refreshControll];
    self.hideSearBar = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.headerView.frame.origin.y + self.searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (self.headerView.frame.origin.y + self.searchBar.frame.size.height) )];
    
    [self.hideSearBar addTarget:self action:@selector(hideSearchBar) forControlEvents:UIControlEventTouchUpInside];
    [self loadDataWithParameters:PAGE_REQUEST_PARAMETER(self.tableView.count)];
}

- (void) refreshControll
{
    self.tableView.count = 1;
    self.tableView.refreshInterFace = self;
    self.tableView.tatolRows = 0;
    [self.tableView registorRefresh:RefreshPullDownUp];
}
/**
 *  @author Ocean, 15-04-01
 *
 *  下拉刷新方法，来自tableview
 */
- (void) dealPullUpRefresh
{
    self.tableView.count = 1;
    self.tableView.footer.hidden = NO;
    [self loadDataWithParameters:PAGE_REQUEST_PARAMETER(self.tableView.count)];
    
}

/**
 *  @author Ocean, 15-04-01
 *
 *  上拉加载方法，来自tableview
 */
- (void) dealPullDownRefresh
{
    
    self.tableView.count++;
    NSInteger excessNumber = self.tableView.tatolRows%PAGESIZE;
    NSInteger divisionNumber  = self.tableView.tatolRows/PAGESIZE;
    
    if(excessNumber != 0)
    {
        divisionNumber ++;
    }
    NSLog(@"count %ld,excessNumber %ld,divisionNumber %ld",(long)self.tableView.count,excessNumber,divisionNumber);
    
    if(self.tableView.count <= divisionNumber)
    {
        [self loadDataWithParameters:PAGE_REQUEST_PARAMETER(self.tableView.count)];
    }
    else
    {
        self.tableView.footer.hidden = YES;
    }

}


- (void)loadDataWithParameters:(NSDictionary *) parameters{
    if(!self.tableView.header.isRefreshing && !self.tableView.footer.isRefreshing)
    {
        [self showLoadingView];
    }
    __weak typeof(self) weakSelf = self;
    [[APIClient sharedClient] requestPath:PATH_PAPER_PRICE
                               parameters:parameters
                                  success:^(AFHTTPRequestOperation *operation, id JSON)
                                  {
                                      
                                      [weakSelf hideLoadingView];
                                      self.tableView.tatolRows = [[JSON objectForKey:@"rowcount"] integerValue];
                                      if ([[JSON objectForKey:@"status"] isEqual:@"000000"])
                                      {
                                          
                                          NSArray *array = [JSON objectForKey:@"data"];
                                          if (weakSelf.tableView.header.isRefreshing) {
                                              [weakSelf.paperData removeAllObjects];
                                          }
                                          for (NSDictionary *dict in array)
                                          {
                                              PPPaperPrice *paper = [PPPaperPrice paperPriceWithDict:dict];
                                              [weakSelf.paperData addObject:paper];
                                          }
                                          
                                          [weakSelf.tableView endRefresh];
                                          [weakSelf.tableView reloadData];
                                      }
                                      else
                                      {
                                          [weakSelf showToast:[JSON objectForKey:@"message"]];

                                      }
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                  {
                                      [weakSelf hideLoadingView];
                                      [weakSelf showToast:@"网络不给力，请检查网络后重试"];
                                      [weakSelf.tableView endRefresh];
                                  }];
    
    
//    for(int i = 0 ; i < 10 ; i++)
//    {
//        PPPaperPrice *paper = [[PPPaperPrice alloc] init];
//        paper.paperId = 10;                //纸张Id
//        paper.unit = @"qwe";           //单位
//        paper.name = @"ewq";
//        paper.size = @"123";
//        paper.weight = @"098";
//        paper.price = 123.12;
//        [self.paperData addObject:paper];
//    }
    [self.tableView reloadData];
    
    
    NSLog(@"%@",self.paperData);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.paperData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PaperPriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaperPriceTableViewCell"];
    PPPaperPrice *paper = self.paperData[indexPath.row];
    cell.name.text = paper.name;
    cell.size.text = [NSString stringWithFormat:@"规格:%@",paper.size];
    cell.weight.text = [NSString stringWithFormat:@"克重:%@",paper.weight];
    cell.price.text = [NSString stringWithFormat:@"承印价:%.2f",paper.price];
    cell.unit.text = paper.unit;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - searchBar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText == nil || searchText.length <= 0)
    {
        [self.paperData removeAllObjects];
        [self loadDataWithParameters:nil];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self hideSearchBar];
    NSDictionary *parameters = [NSDictionary dictionaryWithObject:searchBar.text forKey:@"searchkey"];
    [self.paperData removeAllObjects];
    [self loadDataWithParameters:parameters];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.view addSubview:self.hideSearBar];
}

- (void)hideSearchBar{
    [self.searchBar resignFirstResponder];
    [self.hideSearBar removeFromSuperview];
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
