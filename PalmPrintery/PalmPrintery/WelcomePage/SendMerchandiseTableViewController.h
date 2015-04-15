//
//  SendMerchandiseTableViewController.h
//  PalmPrintery
//
//  Created by zhiyong on 14/12/20.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TTBaseTableViewController.h"
#import "DataModel.h"

@interface SendMerchandiseTableViewController : TTBaseTableViewController

@property (strong, nonatomic) PPOrderProgress *sendProgress;

@property (nonatomic) NSInteger style;

@end
