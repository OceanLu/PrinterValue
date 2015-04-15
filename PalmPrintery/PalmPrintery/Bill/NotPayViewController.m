//
//  NotPayViewController.m
//  PalmPrintery
//
//  Created by qihang on 14/12/20.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "NotPayViewController.h"
#import "NotPayTableViewCell.h"
#import "APIClient.h"
#import "constant.h"
#import "DataModel.h"

@interface NotPayViewController ()

@property (nonatomic, strong) NSMutableArray *billData;
@property (nonatomic, strong) UIButton *hideSearBar;

@end

@implementation NotPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.billData = [NSMutableArray array];
    self.hideSearBar = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.headerView.frame.origin.y + self.searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (self.headerView.frame.origin.y + self.searchBar.frame.size.height) )];
    [self.hideSearBar addTarget:self action:@selector(hideSearchBar) forControlEvents:UIControlEventTouchUpInside];
    
    [self loadDataWithParameters:nil];
}

- (void)loadDataWithParameters:(NSDictionary *) parameters{
    [self showLoadingView];
    [[APIClient sharedClient] requestPath:PATH_BILL_NOTPAY
                               parameters:parameters
                                  success:^(AFHTTPRequestOperation *operation, id JSON) {
                                      [self hideLoadingView];
                                      if ([[JSON objectForKey:@"status"] isEqual:@"000000"]) {
                                          NSArray *array = [JSON objectForKey:@"data"];
                                          CGFloat totalAmount = 0.0;
                                          for (NSDictionary *dict in array) {
                                              PPNoPayBill *bill = [PPNoPayBill noPayBillWithDict:dict];
                                              totalAmount = totalAmount + bill.unpaidAmount;
                                              [self.billData addObject:bill];
                                          }
                                          self.totalAmount.text = [NSString stringWithFormat:@"%.2f",totalAmount];
                                          [self.tableView reloadData];
                                      }
                                      else{
                                          [self showToast:[JSON objectForKey:@"message"]];
                                      }
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [self hideLoadingView];
                                      [self showToast:@"网络不给力，请检查网络后重试"];
                                  }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.billData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotPayTableViewCell"];
    PPNoPayBill *bill = self.billData[indexPath.row];
    cell.billNum.text = bill.code;
    cell.billAmount.text = [NSString stringWithFormat:@"%.2f",bill.billAmount];
    cell.notPayAmount.text = [NSString stringWithFormat:@"%.2f",bill.unpaidAmount];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - searchBar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText == nil || searchText.length <= 0) {
        [self.billData removeAllObjects];
        [self loadDataWithParameters:nil];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self hideSearchBar];
    NSDictionary *parameters = [NSDictionary dictionaryWithObject:searchBar.text forKey:@"searchkey"];
    [self.billData removeAllObjects];
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
