//
//  NonPaymentTableViewCell.m
//  PalmPrintery
//
//  Created by PrinterpValue  on 15/4/1.
//  Copyright (c) 2015年 totem. All rights reserved.
//

#import "NonPaymentTableViewCell.h"

@implementation NonPaymentTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    return self;
}

- (void) makeUI
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width ;
    self.billNum = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, screenWidth/3, 21)];
    self.billNum.font = [ UIFont systemFontOfSize:12];
    self.billNum.textColor = [UIColor grayColor];
    self.billNum.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.billNum];
    
    
    self.billAmount = [[UILabel alloc] initWithFrame:CGRectMake(self.billNum.frame.size.width + self.billNum.frame.origin.x, 0, screenWidth/3 - 13, 21)];
    self.billAmount.font = [UIFont systemFontOfSize:12];
    self.billAmount.textColor = [UIColor greenColor];
    self.billAmount.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.billAmount];
    
    
    self.notPayAmount = [[UILabel alloc] initWithFrame:CGRectMake(self.billAmount.frame.origin.x +self.billAmount.frame.size.width, 0, screenWidth/3 -26, 21)];
    self.notPayAmount.font = [UIFont systemFontOfSize:12];
    self.notPayAmount.textAlignment = NSTextAlignmentRight;
    self.notPayAmount.textColor = [UIColor redColor];
    [self.contentView addSubview:self.notPayAmount];
}

- (void) setCellValue:(PPNoPayBill*)data
{
    self.billNum.text = data.code;
    self.billAmount.text = [NSString stringWithFormat:@"%.2f",data.billAmount];
    self.notPayAmount.text = [NSString stringWithFormat:@"%.2f",data.unpaidAmount];

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
