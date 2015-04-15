//
//  MyAccountViewController.m
//  PalmPrintery
//
//  Created by Jia Xiaochao on 14/12/22.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "MyAccountViewController.h"
#import "OrderTypeNewViewController.h"
#import "OrderTypeViewController.h"
#import "APIClient.h"
#import "constant.h"
#import "DataModel.h"
#import "AppDelegate.h"
#import "NotPayViewController.h"
#import "NoBillViewController.h"
#import "MyPaperViewController.h"
#import "SectionHeaderView.h"
#import "NonPaymentViewController.h"
#import "MyAccountHeaderView.h"
@interface MyAccountViewController ()
{
    MyAccountHeaderView *headerView;
}
@property (strong, nonatomic) IBOutlet UITableView *myAccountTableview;
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) IBOutlet UIImageView *titleImageView;
@property (strong, nonatomic) IBOutlet UILabel *nickLabel;


- (IBAction)orderAction:(UIButton *)sender;
- (IBAction)payTypeAction:(UIButton *)sender;

@end

@implementation MyAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setAllOrderType];
    [self setHeaderView];
    [self initOrder:nil];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    headerView.descreptionLabel.text = [NSString stringWithFormat:@"你好，%@", SharedAppDelegate.user.clientName];
}

- (IBAction)initOrder:(id)sender
{

    [self showLoadingView];
    [[APIClient sharedClient] requestPath:PATH_ORDER_TYPE_NUMBER
                               parameters:nil
                                  success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         [self hideLoadingView];
         Response *response = [Response responseWithDict:JSON];
         if ([response isSuccess])
         {
             NSArray *array = [JSON objectForKey:@"data"];
             for (NSDictionary *dic in array)
             {
                 switch ([[dic valueForKey:@"state"] intValue])
                 {
                     case 1:
                     {
                         int amount = [[dic valueForKey:@"amount"]intValue];
                         if (amount > 0)
                         {
                             self.orderType1.text = [NSString stringWithFormat:@"%i",amount];

                             self.orderType1.hidden = NO;
                         }
                         else
                         {
                             self.orderType1.hidden = YES;
                         }
                     }
                         break;
                     case 2:
                     {
                         int amount = [[dic valueForKey:@"amount"]intValue];
                         if (amount > 0)
                         {
                             self.orderType2.text = [NSString stringWithFormat:@"%i",amount];
                             self.orderType2.hidden = NO;
                         }
                         else
                         {
                             self.orderType2.hidden = YES;
                         }
                     }
                         break;
                     case 4:
                     {
                         int amount = [[dic valueForKey:@"amount"]intValue];
                         if (amount > 0)
                         {
                             self.orderType3.text = [NSString stringWithFormat:@"%i",amount];
                             self.orderType3.hidden = NO;
                         }
                         else
                         {
                             self.orderType3.hidden = YES;
                         }
                     }
                         break;
                     case 5:
                     {
                         int amount = [[dic valueForKey:@"amount"]intValue];
                         if (amount > 0)
                         {
                             self.orderType4.text = [NSString stringWithFormat:@"%i",amount];
                             self.orderType4.hidden = NO;
                         }
                         else
                         {
                             self.orderType4.hidden = YES;
                         }
                     }
                         break;
                     default:
                         break;
                 }
             }
         }
         else
         {
             [self showToash:response.message];
         }
     }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self hideLoadingView];
         [self showToash:@"网络错误"];
     }];
    
}


- (IBAction)orderAction:(UIButton *)sender
{
    
    
//    OrderTypeViewController *manager = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderTypeViewController"];
    
    OrderTypeNewViewController *manager = [[OrderTypeNewViewController alloc] init];

    switch (sender.tag)
    {
        case 0:
            self.orderType1.hidden = YES;
            break;
        case 1:
            self.orderType2.hidden = YES;
            break;
        case 2:
            self.orderType3.hidden = YES;
            break;
        case 3:
            self.orderType4.hidden = YES;
            break;
        default:
            break;
    }
    
    manager.tag = sender.tag;
    manager.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:manager animated:YES];
    
    
}

- (IBAction)payTypeAction:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 0:
        {
            NoBillViewController *manager = [[UIStoryboard storyboardWithName:@"Bill" bundle:nil] instantiateViewControllerWithIdentifier:@"NoBillViewController"];
            
            [self.navigationController pushViewController:manager animated:YES];
        }
            
            break;
            
        case 1:
        {
//            NotPayViewController *manager = [[UIStoryboard storyboardWithName:@"Bill" bundle:nil] instantiateViewControllerWithIdentifier:@"NotPayViewController"];
            NonPaymentViewController *manager = [[NonPaymentViewController alloc] init];
            manager.title = @"未付款";
            manager.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:manager animated:YES];
        }
            
            break;
        
        default:
            break;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([indexPath compare:[NSIndexPath indexPathForRow:0 inSection:2]] == kCFCompareEqualTo)
    {
        MyPaperViewController *manager = [[UIStoryboard storyboardWithName:@"Bill" bundle:nil] instantiateViewControllerWithIdentifier:@"MyPaperViewController"];
        
        [self.navigationController pushViewController:manager animated:YES];
    }
    
}
/* add by Liuhy 2015-3-23 添加自定义段头图片和段头高度*/
- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section != 3)
    {
        SectionHeaderView *view = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, tableView.sectionHeaderHeight)];
        view.backgroundColor = tableView.backgroundColor;
        view.type = HearderLineAll;
        return view;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, tableView.sectionHeaderHeight)];
    view.backgroundColor = tableView.backgroundColor;
    return view;
}


/**
 *  @author Ocean, 15-04-07
 *
 *  设置段头上面的View
 */
- (void) setHeaderView
{
    headerView = [[MyAccountHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,166.0f)];
    self.myAccountTableview.tableHeaderView = headerView;
}

- (void) setAllOrderType
{
    self.orderType1.layer.cornerRadius = 7;
    self.orderType1.clipsToBounds = YES;
    self.orderType2.layer.cornerRadius = 7;
    self.orderType2.clipsToBounds = YES;
    self.orderType3.layer.cornerRadius = 7;
    self.orderType3.clipsToBounds = YES;
    self.orderType4.layer.cornerRadius = 7;
    self.orderType4.clipsToBounds = YES;
}

/*end*/
@end
