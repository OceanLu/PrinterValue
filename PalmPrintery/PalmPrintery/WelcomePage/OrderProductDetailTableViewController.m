//
//  OrderProductDetailTableViewController.m
//  PalmPrintery
//
//  Created by zhiyong on 14/12/20.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "OrderProductDetailTableViewController.h"

#import "APIClient.h"
#import "constant.h"
#import "AppDelegate.h"
#import "ProgressTimelineViewController.h"

@interface OrderProductDetailTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *cNameLabel;
@property (strong, nonatomic) PPOrderProgress *orderProgressMy;
@property (strong, nonatomic) PPStorageAndSend *storageAndSend;
@property (weak, nonatomic) IBOutlet UILabel *cPrintCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *printNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataPrintLabel;
@property (weak, nonatomic) IBOutlet UILabel *printProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *packProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *outStoreProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressBackLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfStockInLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataOfStockLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfSendOutLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataOfSendOut;
@property (weak, nonatomic) IBOutlet UIView *removeView0;
@property (weak, nonatomic) IBOutlet UIView *removeView1;
@property (weak, nonatomic) IBOutlet UIView *removeView2;
@property (weak, nonatomic) IBOutlet UIView *removeView3;

@end

@implementation OrderProductDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(self.style == 0){
        self.removeView2.frame = self.removeView0.frame;
//        self.removeView3.frame = cgrect
    }
    [self makeUI];
    [self loadData];
}

- (void) makeUI
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 190, self.view.frame.size.width, 97)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, view.frame.size.height/3, view.frame.size.width/2, view.frame.size.height/3)];
    label.text = [NSString stringWithFormat:@"当前状态: 单色印刷"];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    [view addSubview:label];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(view.frame.size.width-50, view.frame.size.height/3, 40, view.frame.size.height/3);

    [button setTitle:@"查看详情" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setTintColor:[UIColor lightGrayColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:9];
    [view addSubview:button];

}

- (void) clickButton:(UIButton *) sender
{
    ProgressTimelineViewController *timeLine = [[ProgressTimelineViewController alloc] init];
    [self.navigationController pushViewController:timeLine animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData{
//    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//    PPUser *user = appDelegate.user;
//    long long clientid = user.clientId;
    NSDictionary *params = @{@"orderid":@(self.orderProgress.orderId)};
    
    [self showLoadingView];
    APIClient *client = [APIClient sharedClient];
    
    [client requestPath:PATH_ORDERPROGRESS parameters:params success:^(AFHTTPRequestOperation *operation, id JSON)
    {
        NSString *status = [JSON objectForKey:@"status"];
        if([status isEqualToString:@"000000"])
        {
            NSDictionary *dict = [JSON objectForKey:@"data"];
            self.orderProgressMy = [PPOrderProgress orderProgressWithDict:dict];
        }
        else
        {
            NSString *message = [JSON objectForKey:@"message"];
            [self showToash:message];
        }
        [client requestPath:PATH_ORDER_STOCKINANDSENDOUT parameters:params success:^(AFHTTPRequestOperation *operation, id JSON)
        {
            [self hideLoadingView];
            NSString *status = [JSON objectForKey:@"status"];
            if([status isEqualToString:@"000000"])
            {
                NSDictionary *dict = [JSON objectForKey:@"data"];
                self.storageAndSend = [PPStorageAndSend storageAndSendWithDict:dict];
            }
            else
            {
                NSString *message = [JSON objectForKey:@"message"];
                [self showToash:message];
            }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            [self hideLoadingView];
            [self showToash:@"网络连接错误"];
            ;
        }];
    }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
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

- (void)setOrderProgress:(PPOrderProgress *)orderProgress{
    _orderProgress = orderProgress;
    if(_orderProgress){
        self.cPrintCodeLabel.text = _orderProgress.cCode;
        self.printNumLabel.text = [NSString stringWithFormat:@"%lu",_orderProgress.iBookCount];
        self.dataPrintLabel.text = _orderProgress.dataPrint;
        self.cNameLabel.text = _orderProgress.cName;
        
    }
}
- (void)setOrderProgressMy:(PPOrderProgress *)orderProgressMy{
    _orderProgressMy = orderProgressMy;
    self.cPrintCodeLabel.text = _orderProgress.cPrintCode;
    self.printNumLabel.text = [NSString stringWithFormat:@"%lu",_orderProgress.iBookCount];
    self.dataPrintLabel.text = _orderProgress.dataPrint;
    self.cNameLabel.text = _orderProgress.cName;
    if(_orderProgressMy){
        NSInteger width = self.progressBackLabel.frame.size.width;
        self.printProgressLabel.frame= CGRectMake(self.printProgressLabel.frame.origin.x, self.printProgressLabel.frame.origin.y, width * _orderProgressMy.printProgress, self.progressBackLabel.frame.size.height);
        self.packProgressLabel.frame = CGRectMake(self.packProgressLabel.frame.origin.x, self.packProgressLabel.frame.origin.y, width * _orderProgressMy.packProgress, self.progressBackLabel.frame.size.height);
        self.outStoreProgressLabel.frame = CGRectMake(self.outStoreProgressLabel.frame.origin.x, self.outStoreProgressLabel.frame.origin.y,width * _orderProgressMy.outStoreProgress , self.progressBackLabel.frame.size.height);
        self.printProgressLabel.text = [NSString stringWithFormat:@"%d%%",(int)(_orderProgressMy.printProgress * 100)];
        self.packProgressLabel.text = [NSString stringWithFormat:@"%d%%",(int)(_orderProgressMy.packProgress * 100)];
        self.outStoreProgressLabel.text = [NSString stringWithFormat:@"%d%%",(int)(_orderProgressMy.outStoreProgress * 100)];
    }
}
- (void)setStorageAndSend:(PPStorageAndSend *)storageAndSend{
    _storageAndSend = storageAndSend;
    if(_storageAndSend){
        self.numOfSendOutLabel.text = [NSString stringWithFormat:@"%lu",_storageAndSend.sendoutAmount];
        self.numOfStockInLabel.text = [NSString stringWithFormat:@"%lu",_storageAndSend.stockinAmount];
        self.dataOfSendOut.text = _storageAndSend.sendoutDate;
        self.dataOfStockLabel.text = _storageAndSend.stockinDate;
    }
}
@end
