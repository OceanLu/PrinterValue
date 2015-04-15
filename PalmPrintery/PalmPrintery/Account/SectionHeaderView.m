//
//  SectionHeaderView.m
//  PalmPrintery
//
//  Created by PrinterpValue  on 15/3/23.
//  Copyright (c) 2015年 totem. All rights reserved.
//

#import "SectionHeaderView.h"

@implementation SectionHeaderView


- (id)initWithFrame:(CGRect)frame andType:(HearderType) type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    CGContextSetLineWidth(context, 0.2);
    if (self.type != HearderDonwLineOnly)
    {
        //上分割线
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
        CGContextStrokeRect(context, CGRectMake(0, -1, rect.size.width, 1));
    }
    
    if(self.type != HearderUpLineOnly)
    {
        //下分割线
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
        CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width, 1));
    }
   
}


@end
