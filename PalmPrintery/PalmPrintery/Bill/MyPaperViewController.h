//
//  MyPaperViewController.h
//  PalmPrintery
//
//  Created by qihang on 14/12/22.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TTBaseViewController.h"
#import "OLTableView.h"
#import "MJRefresh.h"
@interface MyPaperViewController : TTBaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet OLTableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
