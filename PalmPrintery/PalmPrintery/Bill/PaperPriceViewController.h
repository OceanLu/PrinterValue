//
//  PaperPriceViewController.h
//  PalmPrintery
//
//  Created by qihang on 14/12/22.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TTBaseViewController.h"
#import "OLTableView.h"
@interface PaperPriceViewController : TTBaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,refreshInterFace>

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet OLTableView *tableView;

@end
