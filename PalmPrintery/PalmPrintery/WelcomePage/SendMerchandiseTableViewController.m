//
//  SendMerchandiseTableViewController.m
//  PalmPrintery
//
//  Created by zhiyong on 14/12/20.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "SendMerchandiseTableViewController.h"

#import "constant.h"
#import "APIClient.h"

@interface SendMerchandiseTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cNameLabel;
@property (strong, nonatomic) PPStorageAndSend *storageAndSend;
@property (weak, nonatomic) IBOutlet UILabel *cPrintCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *printNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataFinishLabel;
@property (weak, nonatomic) IBOutlet UILabel *printProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *outStoreProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressBackLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfStockInLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataOfStockLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfSendOutLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataOfSendOut;

@end

@implementation SendMerchandiseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData{
    NSDictionary *params = @{@"orderid":@(self.sendProgress.orderId)};
    [self showLoadingView];
    APIClient *client = [APIClient sharedClient];
    [client requestPath:PATH_ORDER_STOCKINANDSENDOUT parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        [self hideLoadingView];
        NSString *status = [JSON objectForKey:@"status"];
        if([status isEqualToString:@"000000"]){
            NSDictionary *dict = [JSON objectForKey:@"data"];
            self.storageAndSend = [PPStorageAndSend storageAndSendWithDict:dict];
        }
        else{
            NSString *message = [JSON objectForKey:@"message"];
            [self showToash:message];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideLoadingView];
        [self showToash:@"网络连接错误"];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)setStorageAndSend:(PPStorageAndSend *)storageAndSend{
    self.cPrintCodeLabel.text = _sendProgress.cPrintCode;
    self.printNumLabel.text = [NSString stringWithFormat:@"%lu",_sendProgress.iBookCount];
    self.dataFinishLabel.text = _sendProgress.dataOver;
    self.cNameLabel.text = _sendProgress.cName;
    NSInteger width = self.progressBackLabel.frame.size.width;
    _storageAndSend = storageAndSend;
    if(_storageAndSend){
        self.numOfSendOutLabel.text = [NSString stringWithFormat:@"%lu",_storageAndSend.sendoutAmount];
        self.numOfStockInLabel.text = [NSString stringWithFormat:@"%lu",_storageAndSend.stockinAmount];
        self.dataOfSendOut.text = _storageAndSend.sendoutDate;
        self.dataOfStockLabel.text = _storageAndSend.stockinDate;
        if(_sendProgress.iBookCount != 0){
            self.printProgressLabel.frame= CGRectMake(self.printProgressLabel.frame.origin.x, self.printProgressLabel.frame.origin.y, width *  _storageAndSend.stockinAmount / _sendProgress.iBookCount, self.progressBackLabel.frame.size.height);
            self.outStoreProgressLabel.frame = CGRectMake(self.outStoreProgressLabel.frame.origin.x, self.outStoreProgressLabel.frame.origin.y,width *  _storageAndSend.sendoutAmount / _sendProgress.iBookCount , self.progressBackLabel.frame.size.height);
        }
        self.printProgressLabel.text = [NSString stringWithFormat:@"%d%%",(int)(_sendProgress.printProgress * 100 / _sendProgress.iBookCount)];
        self.outStoreProgressLabel.text = [NSString stringWithFormat:@"%d%%",(int)(_sendProgress.outStoreProgress * 100 / _sendProgress.iBookCount)];
    }
}
@end
