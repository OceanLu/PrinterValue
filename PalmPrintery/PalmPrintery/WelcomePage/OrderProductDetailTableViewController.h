//
//  OrderProductDetailTableViewController.h
//  PalmPrintery
//
//  Created by zhiyong on 14/12/20.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TTBaseTableViewController.h"
#import "DataModel.h"

@interface OrderProductDetailTableViewController : TTBaseTableViewController

@property (strong, nonatomic) PPOrderProgress *orderProgress;

@property (nonatomic) NSInteger style;

@end
