//
//  MyPaperViewController.m
//  PalmPrintery
//
//  Created by qihang on 14/12/22.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "MyPaperViewController.h"
#import "MyPaperTableViewCell.h"
#import "APIClient.h"
#import "constant.h"
#import "DataModel.h"

@interface MyPaperViewController ()<refreshInterFace>

@property (nonatomic, strong) NSMutableArray *paperData;
@property (nonatomic, strong) UIButton *hideSearBar;

@end

@implementation MyPaperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.paperData = [NSMutableArray array];
    self.hideSearBar = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.headerView.frame.origin.y + self.searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (self.headerView.frame.origin.y + self.searchBar.frame.size.height) )];
    [self.hideSearBar addTarget:self action:@selector(hideSearchBar) forControlEvents:UIControlEventTouchUpInside];
    [self refreshControll];
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
    [self showLoadingView];
    __weak typeof(self) weakSelf = self;
    [[APIClient sharedClient] requestPath:PATH_PAPER_MYPAPER
                               parameters:parameters
                                  success:^(AFHTTPRequestOperation *operation, id JSON) {
                                      [weakSelf hideLoadingView];
                                      weakSelf.tableView.tatolRows = [[JSON objectForKey:@"rowcount"] integerValue];
                                      if ([[JSON objectForKey:@"status"] isEqual:@"000000"]) {
                                          NSArray *array = [JSON objectForKey:@"data"];
                                          for (NSDictionary *dict in array) {
                                              PPMyPaper *paper = [PPMyPaper myPaperWithDict:dict];
                                              [weakSelf.paperData addObject:paper];
                                          }
                                          [weakSelf.tableView endRefresh];
                                          [weakSelf.tableView reloadData];
                                      }
                                      else{
                                          [weakSelf showToast:[JSON objectForKey:@"message"]];
                                      }
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [weakSelf hideLoadingView];
                                      [weakSelf showToast:@"网络不给力，请检查网络后重试"];
                                      [weakSelf.tableView endRefresh];
                                  }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.paperData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyPaperTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyPaperTableViewCell"];
    PPMyPaper *paper = self.paperData[indexPath.row];
    cell.name.text = paper.name;
    cell.unit.text = paper.unit;
    cell.weight.text = [NSString stringWithFormat:@"克重:%@",paper.weight];
    cell.size.text = [NSString stringWithFormat:@"规格:%@",paper.size];
    cell.num.text = [NSString stringWithFormat:@"数量:%.3f",paper.num];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - searchBar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText == nil || searchText.length <= 0) {
        [self.paperData removeAllObjects];
        [self loadDataWithParameters:nil];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
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

@end
