//
//  OrderTypeTableViewCell.m
//  PalmPrintery
//
//  Created by PrinterpValue  on 15/4/7.
//  Copyright (c) 2015年 totem. All rights reserved.
//

#import "OrderTypeTableViewCell.h"

@implementation OrderTypeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    return self;
}

- (void) makeUI
{
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 11, screenFrame.size.width -28, 15)];
    self.titleLabel.textColor = [UIColor grayColor];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleLabel];
    
    
    self.orderNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 42, (screenFrame.size.width -28)/2, 12)];
    self.orderNumberLabel.textColor = [UIColor lightGrayColor];
    self.orderNumberLabel.font = [UIFont systemFontOfSize:10];
    self.orderNumberLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.orderNumberLabel];

    
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenFrame.size.width/2 -14, 42, (screenFrame.size.width -28)/2, 12)];
    self.dateLabel.textColor = [UIColor colorWithRed:81/255.0 green:166/255.0 blue:214/255.0 alpha:1];//81 166 214
    self.dateLabel.font = [UIFont systemFontOfSize:10];
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.dateLabel];
    
    
    self.printerNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 70, screenFrame.size.width -28, 12)];
    self.printerNumberLabel.textColor = [UIColor colorWithRed:91/255.0 green:188/255.0 blue:25/255.0 alpha:1];//91 188 25
    self.printerNumberLabel.font = [UIFont systemFontOfSize:10];
    self.printerNumberLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.printerNumberLabel];

}

- (void) setOrderProgress:(PPOrderProgress *)orderProgress
{
    self.titleLabel.text = orderProgress.cName;
    NSString *printCode = orderProgress.cPrintCode;
    if (printCode.length <= 0)
    {
        self.orderNumberLabel.text = [NSString stringWithFormat:@"委印单号："];
    }
    else
    {
        self.orderNumberLabel.text = [NSString stringWithFormat:@"委印单号：%@",orderProgress.cPrintCode];
    }
    
    if (orderProgress.dataOver.length == 0)
    {
        self.dateLabel.text = [NSString stringWithFormat:@"付印日期：%@",orderProgress.dataPrint];
    }
    else
    {
        self.dateLabel.text = [NSString stringWithFormat:@"完成日期：%@",orderProgress.dataOver];
    }
    
    self.printerNumberLabel.text = [NSString stringWithFormat:@"印数：%li",(long)orderProgress.iBookCount];

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
