//
//  AccountOrderTypeCell.m
//  PalmPrintery
//
//  Created by Jia Xiaochao on 14/12/23.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "AccountOrderTypeCell.h"
#import "DataModel.h"

@implementation AccountOrderTypeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setOrderInfo:(PPOrderProgress *)orderInfo
{
    self.nameLabel.text = orderInfo.cName;
    NSString *printCode = orderInfo.cPrintCode;
    if (printCode.length <= 0)
    {
        self.printCodeLabel.text = [NSString stringWithFormat:@"委印单号："];
    }
    else
    {
        self.printCodeLabel.text = [NSString stringWithFormat:@"委印单号：%@",orderInfo.cPrintCode];
    }
    
    if (orderInfo.dataOver.length == 0)
    {
        self.timeLabel.text = [NSString stringWithFormat:@"付印日期：%@",orderInfo.dataPrint];
    }
    else
    {
        self.timeLabel.text = [NSString stringWithFormat:@"完成日期：%@",orderInfo.dataOver];
    }
    
    
    self.countLabel.text = [NSString stringWithFormat:@"印数：%li",(long)orderInfo.iBookCount];
}

@end
