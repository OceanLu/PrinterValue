//
//  NoBillTableViewCell.h
//  PalmPrintery
//
//  Created by qihang on 14/12/20.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoBillTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *billNum;
@property (weak, nonatomic) IBOutlet UILabel *billName;
@property (weak, nonatomic) IBOutlet UILabel *noBillAmount;

@end
