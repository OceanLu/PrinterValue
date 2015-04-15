//
//  NonPaymentTableViewCell.h
//  PalmPrintery
//
//  Created by PrinterpValue  on 15/4/1.
//  Copyright (c) 2015年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface NonPaymentTableViewCell : UITableViewCell
@property (strong, nonatomic)  UILabel *billNum;
@property (strong, nonatomic)  UILabel *billAmount;
@property (strong, nonatomic)  UILabel *notPayAmount;

- (void) setCellValue:(PPNoPayBill*)data;

@end
