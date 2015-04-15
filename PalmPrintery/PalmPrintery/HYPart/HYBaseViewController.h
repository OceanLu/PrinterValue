//
//  HYBaseViewController.h
//  PalmPrintery
//
//  Created by PrinterpValue  on 15/3/25.
//  Copyright (c) 2015年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTBaseViewController.h"
#import "OLTableView.h"

@interface HYBaseViewController : TTBaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) UIButton *button;
/**
 *  @author Ocean, 15-04-07
 *
 *  分页计数
 */
@property (nonatomic, assign) NSInteger Pagecount;

/**
 *  @author Ocean, 15-04-07
 *
 *  一共多少行
 */
@property (nonatomic, assign) NSInteger PageTotalRows;

/**
 *  @author Ocean, 15-04-07
 *
 *   tableview 基本控件
 */
@property (nonatomic, strong) UITableView *tableView;
/**
 *  @author Ocean, 15-04-07
 *
 *  searchBar
 */
@property (nonatomic, strong) UISearchBar *searchBar;

/**
 *  @author Ocean, 15-04-07
 *
 *   tableview的式样，需要init的时候设置，后续设置无效
 */
@property (nonatomic, assign) UITableViewStyle tableviewStyle;

/**
 *  @author Ocean, 15-04-07
 *
 *   tableview的数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 *  @author Ocean, 15-04-07
 *
 *  注册上下拉刷新
 *
 *  @param state 注册种类  上拉/下拉/上下拉
 */
- (void) registorRefresh:(RefreshStateForUser)state;
- (void) stopRefreshing;
- (void) EXbackButtonClick;
@end
