//
//  OLTableView.h
//  PalmPrintery
//
//  Created by PrinterpValue  on 15/4/1.
//  Copyright (c) 2015年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol refreshInterFace <NSObject>

- (void) dealPullDownRefresh;
- (void) dealPullUpRefresh;

@end

typedef enum
{
    RefreshPullDown = 1,
    RefreshPullUp,
    RefreshPullDownUp,
    RefreshMax,
}RefreshStateForUser;

@interface OLTableView : UITableView
@property (nonatomic, assign) id<refreshInterFace> refreshInterFace;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger tatolRows;

- (void) registorRefresh:(RefreshStateForUser)state;
- (void) endRefresh;
@end
