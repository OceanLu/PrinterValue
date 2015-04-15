//
//  SettingTableViewCell.m
//  PalmPrintery
//
//  Created by PrinterpValue  on 15/3/23.
//  Copyright (c) 2015年 totem. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    CGContextSetLineWidth(context, 0.2);
    //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(STANDARD_STATUTBAR_HIGHT, rect.size.height, rect.size.width - STANDARD_STATUTBAR_HIGHT, 1));
    NSArray *arr = @[@"MyAccountOrder",@"MyAccountBill"];
    if([arr containsObject:[self restorationIdentifier]])
    {
        CGContextStrokeRect(context, CGRectMake(MYACCOUNT_UNDERLINE_OFFSET, rect.size.height, rect.size.width - MYACCOUNT_UNDERLINE_OFFSET, 1));
    }
}
@end
