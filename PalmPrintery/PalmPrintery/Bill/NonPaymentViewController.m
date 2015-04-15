//
//  NonPaymentViewController.m
//  PalmPrintery
//
//  Created by PrinterpValue  on 15/4/1.
//  Copyright (c) 2015年 totem. All rights reserved.
//

#import "NonPaymentViewController.h"
#import "NonPaymentView.h"
#import "APIClient.h"
#import "constant.h"
#import "DataModel.h"
#import "NotPayTableViewCell.h"
#import "NonPaymentTableViewCell.h"

@interface NonPaymentViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@end

@implementation NonPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self uiconfig];
//    for (int i = 0; i < 20; i++) {
//        NSDictionary* dic = @{@"cCode":[NSString stringWithFormat:@"123iji123ssss%d",i],@"nBillAmout":@(arc4random()),@"nUnpaidAmount":@(arc4random())};
//        PPNoPayBill*bill = [PPNoPayBill noPayBillWithDict:dic];
//        [self.dataSource addObject:bill];
//    }
    
    [self loadDataWithParameters:nil];
    // Do any additional setup after loading the view.
}

- (void) uiconfig
{
    NonPaymentView *upView = [[NonPaymentView alloc] initWithFrame:CGRectMake(0,self.navigationController.navigationBar.frame.size.height + 20 + 44, self.view.frame.size.width, 68)];
    [self.view addSubview:upView];
    
    self.searchBar.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height + 20, self.view.frame.size.width, 44);
    self.searchBar.delegate = self;
    self.searchBar.barTintColor = SearchBarBackgroundColor;
    self.searchBar.placeholder = @"金额、发票";
    [self.view addSubview:self.searchBar];
    
    
    self.tableView.frame = CGRectMake(0, upView.frame.size.height + upView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - (upView.frame.size.height + upView.frame.origin.y                                                                                                                                                  ));
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)loadDataWithParameters:(NSDictionary *) parameters{
    [self showLoadingView];
    __weak typeof(self) weakSelf = self;
    [[APIClient sharedClient] requestPath:PATH_BILL_NOTPAY
                               parameters:parameters
                                  success:^(AFHTTPRequestOperation *operation, id JSON) {
                                      [weakSelf hideLoadingView];
                                      if ([[JSON objectForKey:@"status"] isEqual:@"000000"]) {
                                          NSArray *array = [JSON objectForKey:@"data"];
                                          CGFloat totalAmount = 0.0;
                                          for (NSDictionary *dict in array) {
                                              PPNoPayBill *bill = [PPNoPayBill noPayBillWithDict:dict];
                                              totalAmount = totalAmount + bill.unpaidAmount;
                                              [weakSelf.dataSource addObject:bill];
                                          }
                                          NSLog(@"%@",weakSelf.dataSource);
                                          ((UILabel*)[weakSelf.view viewWithTag:1000]).text = [NSString stringWithFormat:@"%.2f",totalAmount];
                                          [weakSelf.tableView reloadData];
                                      }
                                      else{
                                          [weakSelf showToast:[JSON objectForKey:@"message"]];
                                      }
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [weakSelf hideLoadingView];
                                      [weakSelf showToast:@"网络不给力，请检查网络后重试"];
                                  }];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"NotPayTableViewCell";
    NonPaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (nil == cell) {
        cell = [[NonPaymentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    PPNoPayBill *bill = self.dataSource[indexPath.row];
    [cell setCellValue:bill];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UISearchBar *searchBar =(UISearchBar*) [self.view viewWithTag:100];
    [searchBar resignFirstResponder];
}
#pragma mark - searchBar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText == nil || searchText.length <= 0) {
        [self.dataSource removeAllObjects];
        [self loadDataWithParameters:nil];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSDictionary *parameters = [NSDictionary dictionaryWithObject:searchBar.text forKey:@"searchkey"];
    self.button.hidden = YES;
    [self.searchBar resignFirstResponder];
//    [self.dataSource removeAllObjects];
    [self loadDataWithParameters:parameters];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    self.button.hidden = NO;
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
