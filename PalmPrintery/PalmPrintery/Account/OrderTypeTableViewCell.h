//
//  OrderTypeTableViewCell.h
//  PalmPrintery
//
//  Created by PrinterpValue  on 15/4/7.
//  Copyright (c) 2015年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
@interface OrderTypeTableViewCell : UITableViewCell
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *orderNumberLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UILabel *printerNumberLabel;

@property (nonatomic, retain) PPOrderProgress *orderProgress;
@end
