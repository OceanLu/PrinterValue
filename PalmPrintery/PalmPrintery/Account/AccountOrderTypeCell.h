//
//  AccountOrderTypeCell.h
//  PalmPrintery
//
//  Created by Jia Xiaochao on 14/12/23.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPOrderProgress;

@interface AccountOrderTypeCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *printCodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;

@property (strong, nonatomic) PPOrderProgress *orderInfo;

@end
