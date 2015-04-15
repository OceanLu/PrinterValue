//
//  OLTableView.m
//  PalmPrintery
//
//  Created by PrinterpValue  on 15/4/1.
//  Copyright (c) 2015年 totem. All rights reserved.
//

#import "OLTableView.h"
#import "MJRefresh.h"

@implementation OLTableView
/**
 *  @author Ocean, 15-03-31
 *
 *  注册上下拉
 *
 *  @param state 刷新的类别
 */
- (void) registorRefresh:(RefreshStateForUser)state
{
    __weak typeof(self) weakSelf = self;
    //下拉
    if(state != RefreshPullUp)
    {
        self.header.updatedTimeHidden = YES;

        [self addLegendFooterWithRefreshingBlock:^{
            [weakSelf.refreshInterFace dealPullDownRefresh];
        }];
    }
    //上拉
    if(state != RefreshPullDown)
    {
        self.footer.automaticallyRefresh = NO;

        [self addLegendHeaderWithRefreshingBlock:^{
            [weakSelf.refreshInterFace dealPullUpRefresh ];
        }];

    }
}

- (void) endRefresh
{
    if(self.header.isRefreshing)
    {
        [self.header endRefreshing];
    }
    else if(self.footer.isRefreshing)
    {
        [self.footer endRefreshing];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
