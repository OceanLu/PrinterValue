//
//  NonPaymentView.m
//  PalmPrintery
//
//  Created by PrinterpValue  on 15/4/1.
//  Copyright (c) 2015年 totem. All rights reserved.
//

#import "NonPaymentView.h"
#import "macro.h"
@implementation NonPaymentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
        }
    return self;
}

- (void) makeUI
{
    
    UIImageView *declare = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, 42)];
    declare.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    [self addSubview:declare];
    
    
    NSArray* arr = @[@"发票号",@"金额",@"未付款金额"];
    for (int i = 0; i<arr.count; i++) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(13 + i*declare.frame.size.width/3, 0, declare.frame.size.width/3, declare.frame.size.height)];
        textLabel.font = [UIFont systemFontOfSize:15];
        textLabel.textColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1];
        textLabel.text = arr[i];
        textLabel.textAlignment = NSTextAlignmentLeft;
        [declare addSubview:textLabel];
    }
    
    
    UIView *tatolView = [[UIView alloc] initWithFrame:CGRectMake(0,declare.frame.origin.y +declare.frame.size.height, self.frame.size.width, 35)];
    tatolView.backgroundColor = [UIColor colorWithRed:228/255.0 green:253/255.0 blue:235/255.0 alpha:1];
    [self addSubview:tatolView];
    
    
    UILabel *tatolLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 40, 35)];
    tatolLabel.textColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1];
    tatolLabel.font = [UIFont systemFontOfSize:15];
    tatolLabel.text = @"合计";
    tatolLabel.textAlignment = NSTextAlignmentLeft;
    [tatolView addSubview:tatolLabel];
    
    
    UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, 35)];
    amountLabel.textAlignment = NSTextAlignmentRight;
    amountLabel.font = [UIFont systemFontOfSize:12];
    amountLabel.textColor = [UIColor redColor];
    amountLabel.tag = 1000;
    [tatolView addSubview:amountLabel];
    
    
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    //draw line
    
    UIColor *color = [UIColor blackColor];
    CGContextSetLineWidth(context,1);
    CGContextSetStrokeColorWithColor(context,color.CGColor);
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width,rect.size.height);
    CGContextStrokePath(context);
}


@end
