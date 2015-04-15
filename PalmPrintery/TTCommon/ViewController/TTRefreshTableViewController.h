//
//  TTRefreshTableViewController.h
//  TravelGuide
//
//  Created by Ma Jianglin on 12/27/12.
//  Copyright (c) 2012 Ma Jianglin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTBaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "TTRefreshTableFooterView.h"

@interface TTRefreshTableViewController : TTBaseViewController<UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate>
{
	BOOL _loading;  //是否正在加载中
    
    int _pageIndex; //当前加载的页数，页面索引
    int _pageSize;  //每页数据条数
    
    BOOL _hasMore;  //是否有更多数据
    
    EGORefreshTableHeaderView   *_headerView;        //下拽刷新的视图
    TTRefreshTableFooterView    *_footerView;        //更多按钮，需要变更加载状态
}


@property(nonatomic, strong) IBOutlet UITableView *tableView;   //表视图
@property(nonatomic, strong) NSMutableArray *dataArray;         //数据数组

@property (nonatomic) BOOL isUpRefresh;

- (void)doneLoadingData;       //加载数据完成了调用此方法

- (void)setHeaderViewInset:(UIEdgeInsets)insert;

@end;