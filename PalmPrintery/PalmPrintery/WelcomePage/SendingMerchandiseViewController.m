//
//  SendingMerchandiseViewController.m
//  PalmPrintery
//
//  Created by zhiyong on 14/12/25.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "SendingMerchandiseViewController.h"

#import "constant.h"
#import "APIClient.h"
#import "SendingMerchandiseCell.h"

@interface SendingMerchandiseViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *cNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cPrintCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *printNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataFinishLabel;
@property (strong, nonatomic) NSArray *data;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SendingMerchandiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.rowHeight = 28;
    self.tableView.sectionHeaderHeight = 30;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData{
    [self showLoadingView];
    NSDictionary *params = @{@"orderid":@(self.sendProgress.orderId)};
    [self showLoadingView];
    APIClient *client = [APIClient sharedClient];
    [client requestPath:PATH_ORDERSEND parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@",JSON);
        [self hideLoadingView];
        NSString *status = [JSON objectForKey:@"status"];
        if([status isEqualToString:@"000000"]){
           NSArray *array = [JSON objectForKey:@"data"];
            NSMutableArray *mArray = [NSMutableArray array];
            for (NSDictionary *dict in array) {
                PPSendMerchandise *sendMerchandise = [PPSendMerchandise sendMerchandiseWithDict:dict];
                [mArray addObject:sendMerchandise];
            }
            self.data = mArray;
        }
        else{
            NSString *message = [JSON objectForKey:@"message"];
            [self showToast:message];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideLoadingView];
        [self showToast:@"网络连接错误"];
    }];
}

//- (void)setSendMerchandise:(PPSendMerchandise *)sendMerchandise{
//    self.cPrintCodeLabel.text = _sendProgress.cCode;
//    self.printNumLabel.text = [NSString stringWithFormat:@"%lu",(long)_sendProgress.iBookCount];
//    self.dataFinishLabel.text = _sendProgress.dataOver;
//    self.cNameLabel.text = _sendProgress.cName;
//    _sendMerchandise = sendMerchandise;
//    if(_sendMerchandise){
//        
//    }
//}
- (void)setData:(NSArray *)data{
    self.cPrintCodeLabel.text = _sendProgress.cPrintCode;
    self.printNumLabel.text = [NSString stringWithFormat:@"%lu",(long)_sendProgress.iBookCount];
    self.dataFinishLabel.text = _sendProgress.dataOver;
    self.cNameLabel.text = _sendProgress.cName;
    _data = data;
    [self.tableView reloadData];
    
}

#pragma mark  UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
//    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSInteger row = indexPath.row;
    SendingMerchandiseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SendingMerchandiseCell"];
//    cell.sendMerchandise = [self.data objectAtIndex:row];
    cell.userInteractionEnabled = NO;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSInteger width = [UIScreen mainScreen].bounds.size.width;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width , 30)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *cNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 60, 20)];
    cNumberLabel.text = @"发货单号";
    cNumberLabel.textAlignment = NSTextAlignmentLeft;
    cNumberLabel.font = [UIFont systemFontOfSize:12];
    
    UILabel *iQuantityLabel = [[UILabel alloc] initWithFrame:CGRectMake(width /2 -20, 5, 40, 20)];
    iQuantityLabel.text = @"数量";
    iQuantityLabel.textAlignment = NSTextAlignmentCenter;
    iQuantityLabel.font = [UIFont systemFontOfSize:12];
    
    UILabel *dDeliveryDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(width - 65, 5, 60, 20)];
    dDeliveryDateLabel.text = @"发货日期";
    dDeliveryDateLabel.textAlignment = NSTextAlignmentRight;
    dDeliveryDateLabel.font = [UIFont systemFontOfSize:12];
    
    [view addSubview:cNumberLabel];
    [view addSubview:iQuantityLabel];
    [view addSubview:dDeliveryDateLabel];
    return view;
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
