//
//  TTBaseTableViewController.h
//  ReadTV
//
//  Created by Ma Jianglin on 2/9/14.
//  Copyright (c) 2014 readtv.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "macro.h"

@class TTRefreshTableFooterView;

@interface TTBaseTableViewController : UITableViewController
{
    BOOL _loading;  //是否正在加载中
    BOOL _hasMore;  //是否有更多数据
    long long _lastId;  //翻页的最后一条
    
    TTRefreshTableFooterView    *_footerView;        //更多按钮，需要变更加载状态
}

- (void)refreshData:(id)sender;   //强制刷新数据
- (void)doneLoadingData;          //数据加载完成调用
- (void)showLoadMore;             //检测并现实加载更多按钮

- (void)showLoadingView;        //显示加载视图
- (void)showLoadingViewWithMessage:(NSString *)message; //显示加载视图，带提示消息
- (void)hideLoadingView;        //隐藏加载视图

-(void)showToash:(NSString *)message;

- (IBAction)backAction:(id)sender;  //使用导航返回上一个视图

@end
