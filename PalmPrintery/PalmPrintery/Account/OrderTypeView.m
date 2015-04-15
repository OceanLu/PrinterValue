//
//  OrderTypeView.m
//  PalmPrintery
//
//  Created by PrinterpValue  on 15/4/7.
//  Copyright (c) 2015年 totem. All rights reserved.
//

#import "OrderTypeView.h"

@implementation OrderTypeView

- (id)initWithFrame:(CGRect)frame andTarget:(id) target andAction:(SEL) action
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.buttons = [NSMutableArray arrayWithCapacity:0];
        [self makeUIWithTarget:target andAction:action];
    }
    return self;
}

- (void) makeUIWithTarget:(id) target andAction:(SEL) action
{
    NSArray *buttonTitle = @[@"未生产",@"生产中",@"已完成"];
    for (int i = 0;i < buttonTitle.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:buttonTitle[i] forState:UIControlStateNormal];
        CGRect frame = CGRectMake(i*self.frame.size.width/3, 0, self.frame.size.width/3, 40);
        [button setFrame:frame];
        button.tag = i;
        [self addSubview:button];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [self.buttons addObject:button];
    }
    
    self.underLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width/3, 3)];
    self.underLine.image = [UIImage imageNamed:@"order_blue_line"];
    [self addSubview:self.underLine];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
