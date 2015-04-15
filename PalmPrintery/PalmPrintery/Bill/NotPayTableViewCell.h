//
//  NotPayTableViewCell.h
//  PalmPrintery
//
//  Created by qihang on 14/12/20.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotPayTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *billNum;
@property (weak, nonatomic) IBOutlet UILabel *billAmount;
@property (weak, nonatomic) IBOutlet UILabel *notPayAmount;

@end
