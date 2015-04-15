//
//  ProgressTimelineViewController.m
//  PalmPrintery
//
//  Created by PrinterpValue  on 15/4/1.
//  Copyright (c) 2015年 totem. All rights reserved.
//

#import "ProgressTimelineViewController.h"
#import "ProgressTimeLineView.h"
#import "ProgressTableViewCell.h"
#import "constant.h"
@interface ProgressTimelineViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
}
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *processSource;
@property (nonatomic, strong) NSMutableArray *progressSource;
@property (nonatomic, strong) ProgressTimeLineView *headerView;


@end

@implementation ProgressTimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    self.processSource = [NSMutableArray arrayWithCapacity:0];
    self.progressSource = [NSMutableArray arrayWithCapacity:0];
    [self uiconfig];
    self.title = @"订单进度明细";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void) loadData
{
    NSDictionary *params = @{@"orderid":@(self.orderProgress.orderId)};
    [self showLoadingView];
    APIClient *client = [APIClient sharedClient];
    __weak typeof(self) weakSelf = self;
         [client requestPath:PATH_20150410_105317 parameters:params success:^(AFHTTPRequestOperation *operation, id JSON)
          {
              [weakSelf hideLoadingView];
              NSString *status = [JSON objectForKey:@"status"];
              if([status isEqualToString:@"000000"])
              {
                  NSArray *arr = [JSON objectForKey:@"data"];
                  [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                      NSDictionary *dic = obj;
                      Pprogress *progress = [Pprogress PprogressWithDict:dic];
                      [weakSelf.progressSource addObject:progress];
                  }];
                  
                  NSArray *sortArr =  [weakSelf.progressSource sortedArrayUsingComparator:^NSComparisonResult(Pprogress *obj1, Pprogress *obj2) {
                      return [obj1.ccode compare:obj2.ccode];
                  }];
                  
                  [weakSelf.progressSource removeAllObjects];
                  [weakSelf.dataSource addObjectsFromArray:sortArr];
                  [table reloadData];
              }
              else
              {
                  NSString *message = [JSON objectForKey:@"message"];
                  [weakSelf showToast:message];
              }
          }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
          {
              [weakSelf hideLoadingView];
              [weakSelf showToast:@"网络连接错误"];
              ;
          }];
}

- (void) setHeaderviewText:(NSString *)orderNum  withCount:(NSInteger) count andDate:(NSString *)date
{
    self.headerView.orderNumberContentL.text = orderNum;
    self.headerView.customNmaeContentL.text = [NSString stringWithFormat:@"%ld",count];
    self.headerView.customMaterialNumberContentL.text = date;
}

- (ProgressTimeLineView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[ProgressTimeLineView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 100)];
        _headerView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_headerView];

    }
    
    return _headerView;
}

- (void) uiconfig
{
    [self setHeaderviewText:self.orderProgress.cPrintCode withCount:self.orderProgress.iBookCount andDate:self.orderProgress.dataOver];
    table                 = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.frame.origin.y+self.headerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.headerView.frame.size.height - 64) style:UITableViewStylePlain];
    table.delegate        = self;
    table.dataSource      = self;
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    table.allowsSelection = NO;
    [self.view addSubview:table];
}

#pragma mark Table delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuse = @"ProgressTimeLine";
    ProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    
    if(nil == cell)
    {
        cell = [[ProgressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    NSLog(@"%@",self.dataSource);
    Pprogress *model = [self.dataSource objectAtIndex:indexPath.row];
    [cell setPropertyWithModel:model];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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

//    [client requestPath:PATH_20150410_105317 parameters:params success:^(AFHTTPRequestOperation *operation, id JSON)
//     {
//         NSString *status = [JSON objectForKey:@"status"];
//         if([status isEqualToString:@"000000"])
//         {
//             NSArray *arr = [JSON objectForKey:@"data"];
////             self.orderProgress = [PPOrderProgress orderProgressWithDict:arr];
//             [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                 NSDictionary *dic = obj;
//                 Pprocess *process = [Pprocess PprocessWithDict:dic];
//                 [weakSelf.processSource addObject:process];
//             }];
//            NSArray *sortArr =  [weakSelf.processSource sortedArrayUsingComparator:^NSComparisonResult(Pprocess *obj1, Pprocess *obj2) {
//                 return [obj1.ccode compare:obj2.ccode];
//             }];
//
//             [weakSelf.processSource removeAllObjects];
//             [weakSelf.processSource addObjectsFromArray:sortArr];
//         }
//         else
//         {
//             NSString *message = [JSON objectForKey:@"message"];
//             [weakSelf showToast:message];
//         }
//

//     }
//                failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         [weakSelf hideLoadingView];
//         [weakSelf showToast:@"网络连接错误"];
//     }];

@end
