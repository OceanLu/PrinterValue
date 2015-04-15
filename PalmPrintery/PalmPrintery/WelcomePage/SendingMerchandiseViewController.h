//
//  SendingMerchandiseViewController.h
//  PalmPrintery
//
//  Created by zhiyong on 14/12/25.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TTBaseViewController.h"
#import "DataModel.h"

@interface SendingMerchandiseViewController : TTBaseViewController

@property (strong, nonatomic) PPOrderProgress *sendProgress;

@property (nonatomic) NSInteger style;

@end
