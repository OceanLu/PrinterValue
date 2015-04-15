//
//  ProgressTimeLineView.m
//  PalmPrintery
//
//  Created by PrinterpValue  on 15/4/3.
//  Copyright (c) 2015年 totem. All rights reserved.
//

#import "ProgressTimeLineView.h"

@implementation ProgressTimeLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSelf];
    }
    return self;
}

- (void) makeSelf
{
    UILabel *orderNumberL = [[UILabel alloc] initWithFrame:CGRectMake(5 , 5, (self.frame.size.width-20)/3, 30)];
    orderNumberL.font = [UIFont boldSystemFontOfSize:14];
    orderNumberL.textColor = [UIColor grayColor];
    orderNumberL.textAlignment = NSTextAlignmentLeft;
    orderNumberL.text = @"委托单号";
    [self addSubview:orderNumberL];
    
    
    self.orderNumberContentL= [[UILabel alloc] initWithFrame:CGRectMake(5 , 40, (self.frame.size.width-20)/3, 30)];
    self.orderNumberContentL.font = [UIFont systemFontOfSize:12];
    self.orderNumberContentL.textColor = [UIColor grayColor];
    self.orderNumberContentL.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.orderNumberContentL];
    
    
    UILabel *customNmaeL = [[UILabel alloc] initWithFrame:CGRectMake(10 + (self.frame.size.width-20)/3, 5,  (self.frame.size.width-20)/3, 30)];
    customNmaeL.font = [UIFont boldSystemFontOfSize:14];
    customNmaeL.textColor = [UIColor grayColor];
    customNmaeL.textAlignment = NSTextAlignmentCenter;
    customNmaeL.text = @"数量";
    [self addSubview:customNmaeL];
    
    self.customNmaeContentL = [[UILabel alloc] initWithFrame:CGRectMake(10 + (self.frame.size.width-20)/3, 40, (self.frame.size.width-20)/3, 30)];
    self.customNmaeContentL.font = [UIFont systemFontOfSize:12];
    self.customNmaeContentL.textColor = [UIColor grayColor];
    self.customNmaeContentL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.customNmaeContentL];
    
    
    UILabel *customMaterialNumberL = [[UILabel alloc] initWithFrame:CGRectMake(15 + (self.frame.size.width-20)/3*2, 5,  (self.frame.size.width-20)/3, 30)];
    customMaterialNumberL.font = [UIFont boldSystemFontOfSize:14];
    customMaterialNumberL.textColor = [UIColor grayColor];
    customMaterialNumberL.textAlignment = NSTextAlignmentRight;
    customMaterialNumberL.text = @"完成日期";
    [self addSubview:customMaterialNumberL];
    
    
    self.customMaterialNumberContentL = [[UILabel alloc] initWithFrame:CGRectMake(15 + (self.frame.size.width-20)/3*2, 40, (self.frame.size.width-20)/3, 30)];
    self.customMaterialNumberContentL.font = [UIFont systemFontOfSize:12];
    self.customMaterialNumberContentL.textColor = [UIColor grayColor];
    self.customMaterialNumberContentL.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.customMaterialNumberContentL];
//
//    
//    UILabel *productNameL = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 130, 5, 55, 30)];
//    productNameL.font = [UIFont systemFontOfSize:12];
//    productNameL.textColor = [UIColor grayColor];
//    productNameL.textAlignment = NSTextAlignmentLeft;
//    productNameL.text = @"产品名称:";
//    [self addSubview:productNameL];
//    
//    
//    self.productNameContentL = [[UILabel alloc] initWithFrame:CGRectMake(productNameL.frame.origin.x + productNameL.frame.size.width, 5, 70, 30)];
//    self.productNameContentL.font = [UIFont systemFontOfSize:10];
//    self.productNameContentL.textColor = [UIColor grayColor];
//    self.productNameContentL.textAlignment = NSTextAlignmentLeft;
//    [self addSubview:self.productNameContentL];
//    
//    
//    UILabel *productNumberL = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 130, productNameL.frame.origin.y + productNameL.frame.size.height, 55, 30)];
//    productNumberL.font = [UIFont systemFontOfSize:12];
//    productNumberL.textColor = [UIColor grayColor];
//    productNumberL.textAlignment = NSTextAlignmentLeft;
//    productNumberL.text = @"生产数量:";
//    [self addSubview:productNumberL];
//    
//    
//    self.productNumberContentL = [[UILabel alloc] initWithFrame:CGRectMake(productNumberL.frame.origin.x + productNumberL.frame.size.width, productNameL.frame.origin.y + productNameL.frame.size.height, 70, 30)];
//    self.productNumberContentL.font = [UIFont systemFontOfSize:10];
//    self.productNumberContentL.textColor = [UIColor grayColor];
//    self.productNumberContentL.textAlignment = NSTextAlignmentLeft;
//    [self addSubview:self.productNumberContentL];
//    
//    
//    
//    UILabel *partNameL = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 130, productNumberL.frame.origin.y + productNumberL.frame.size.height, 55, 30)];
//    partNameL.font = [UIFont systemFontOfSize:12];
//    partNameL.textColor = [UIColor grayColor];
//    partNameL.textAlignment = NSTextAlignmentLeft;
//    partNameL.text = @"部件:";
//    [self addSubview:partNameL];
//    
//    
//    
//    self.partNameContentL = [[UILabel alloc] initWithFrame:CGRectMake(partNameL.frame.origin.x + partNameL.frame.size.width, productNumberL.frame.origin.y+productNumberL.frame.size.height, 70, 30)];
//    self.partNameContentL.font = [UIFont systemFontOfSize:10];
//    self.partNameContentL.textColor = [UIColor grayColor];
//    self.partNameContentL.textAlignment = NSTextAlignmentLeft;
//    [self addSubview:self.partNameContentL];
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //draw line
    
    UIColor *color = [UIColor lightGrayColor];
    CGContextSetLineWidth(context,0.5);
    CGContextSetStrokeColorWithColor(context,color.CGColor);
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width,rect.size.height);
    CGContextStrokePath(context);

}


@end
