//
//  ProgressTimelineViewController.h
//  PalmPrintery
//
//  Created by PrinterpValue  on 15/4/1.
//  Copyright (c) 2015年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTBaseViewController.h"
#import "DataModel.h"
#import "APIClient.h"
#import "macro.h"
@interface ProgressTimelineViewController : TTBaseViewController
@property (strong, nonatomic) PPOrderProgress *orderProgress;

@end
