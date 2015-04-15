//
//  ProgressTableViewCell.m
//  PalmPrintery
//
//  Created by PrinterpValue  on 15/4/2.
//  Copyright (c) 2015年 totem. All rights reserved.
//

#import "ProgressTableViewCell.h"
#import "macro.h"
@implementation ProgressTableViewCell
{
    NSDictionary *colorMap;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        colorMap = @{[NSNumber numberWithInt:KeyForColor_Red]:keyForColor_red,[NSNumber numberWithInt:KeyForColor_Green]:keyForColor_green,[NSNumber numberWithInt:KeyForColor_Yellow]:keyForColor_yellow};
        [self makeUI];
    }
    
    return self;
}

- (void) makeUI
{
    CGFloat screenWidth = [[UIScreen mainScreen] applicationFrame].size.width;
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(50, 10, screenWidth - 80, 80)];
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 5;
    self.backView.backgroundColor = [colorMap objectForKey:[NSNumber numberWithInt:self.status]];
    self.backView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.contentView addSubview:self.backView];
    
    
    self.mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, screenWidth - 100, 30)];
    self.mainLabel.textColor = [UIColor whiteColor];
    self.mainLabel.font = [UIFont boldSystemFontOfSize:13];
    self.mainLabel.textAlignment = NSTextAlignmentLeft;
    [self.backView addSubview:self.mainLabel];
    
    
    self.stockinDate = [[UILabel alloc] initWithFrame:CGRectMake(5, 45, screenWidth -100, 30)];
    self.stockinDate.textColor = [UIColor whiteColor];
    self.stockinDate.font = [UIFont systemFontOfSize:13];
    self.stockinDate.textAlignment = NSTextAlignmentLeft;
    [self.backView addSubview:self.stockinDate];
}

/*
    设置控件的文字，色彩，进度
 */
- (void) setPropertyWithModel:(Pprogress*) progress
{
    self.stockinDate.text = [NSString stringWithFormat:@"完成日期:%@",progress.cdate];
    
    if(progress.iprogress == 0 )
    {
        self.status = KeyForColor_Red;
        self.mainLabel.text = [NSString stringWithFormat:@"%@ (未开始)",progress.cname];

    }
    else if(progress.iprogress == 100)
    {
        self.status = KeyForColor_Green;
        self.mainLabel.text = [NSString stringWithFormat:@"%@ (已完成)",progress.cname];

    }
    else
    {
        self.status = KeyForColor_Yellow;
        self.mainLabel.text = [NSString stringWithFormat:@"%@ (进行中)",progress.cname];

    }
    
    self.backView.backgroundColor = [colorMap objectForKey:[NSNumber numberWithInt:self.status]];
}

- (void)awakeFromNib {
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //draw line
    
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navi_bg"]];
    CGContextSetLineWidth(context,3);
    CGContextSetStrokeColorWithColor(context,color.CGColor);
    CGContextMoveToPoint(context, 30, 0);
    CGContextAddLineToPoint(context, 30,(rect.size.height - 16)/2);
    CGContextStrokePath(context);
    
    CGContextAddArc(context, 30, (rect.size.height - 10)/2, 5, 0, 2*3.14, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
    
    CGContextMoveToPoint(context, 30, (rect.size.height - 16)/2 + 6);
    CGContextAddLineToPoint(context, 30,rect.size.height);
    CGContextStrokePath(context);
    
    
    UIColor* color2 = [colorMap objectForKey:[NSNumber numberWithInt:self.status]];
    CGContextSetFillColorWithColor(context, color2.CGColor);
    
    CGContextMoveToPoint(context, 50, (rect.size.height - 16)/2 - 10);
    CGContextAddLineToPoint(context, 40,rect.size.height/2);
    CGContextAddLineToPoint(context, 50,(rect.size.height - 16)/2 +15);
    CGContextFillPath(context);
    
}



@end
