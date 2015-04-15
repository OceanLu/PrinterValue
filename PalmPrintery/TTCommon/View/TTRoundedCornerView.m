//
//  TTRoundedCornerView.m
//  Test
//
//  Created by Ma Jianglin on 9/18/14.
//  Copyright (c) 2014 totem. All rights reserved.
//

#import "TTRoundedCornerView.h"
#import <QuartzCore/QuartzCore.h>

@interface TTRoundedCornerView()

@property(nonatomic, strong) UIBezierPath *roundedPath;

@end

@implementation TTRoundedCornerView

-(void)addRoundedCorners:(UIRectCorner)corners withRadius:(CGFloat)radius
{
    //圆角
    [self.layer setCornerRadius:radius];
    
    //裁掉圆角，遮罩住
    CALayer *maskLayer = [self maskForRoundedCorners:corners withRadius:radius];
    self.layer.mask = maskLayer;
}

-(CALayer*)maskForRoundedCorners:(UIRectCorner)corners withRadius:(CGFloat)radius
{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    
    CGRect clipBounds = self.bounds;
    
    if (corners != UIRectCornerAllCorners)
    {
        //上方无圆角
        if ( (corners & UIRectCornerTopLeft) == 0 && (corners & UIRectCornerTopRight) == 0)
        {
            clipBounds.origin.y = radius;
            clipBounds.size.height -= radius;
        }
        
        //下方无圆角
        if ( (corners & UIRectCornerBottomLeft) == 0 && (corners & UIRectCornerBottomRight) == 0)
        {
            clipBounds.size.height -= radius;
        }
    }
    
    
    self.roundedPath = [UIBezierPath bezierPathWithRoundedRect:clipBounds
                                             byRoundingCorners:corners
                                                   cornerRadii:CGSizeMake(radius, radius)];
    maskLayer.fillColor = [UIColor whiteColor].CGColor;
    maskLayer.backgroundColor = [UIColor clearColor].CGColor;
    maskLayer.path = self.roundedPath.CGPath;
    
    return maskLayer;
}

- (void)initBorder
{
    //边框，方形，设置圆角请用 addRoundedCorners:withRadii:
    [self.layer setBorderColor:[UIColor colorWithRed:0.792157 green:0.792157 blue:0.792157 alpha:1].CGColor];
    [self.layer setBorderWidth:0.5];
    
    self.roundedPath = [UIBezierPath bezierPathWithRect:self.bounds];
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initBorder];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initBorder];
    }
    
    return self;
}


- (void)setHighlightForLocation:(CGPoint)point
{
    self.backgroundColor = [UIColor colorWithRed:0.851 green:0.851 blue:0.851 alpha:1];
    
    for (id view in self.subviews)
    {
        if ([view isKindOfClass:[UILabel class]])
        {
            [view setHighlighted:YES];
        }
        else if([view isKindOfClass:[UIImageView class]])
        {
            UIImageView *imageView = (UIImageView*)view;
            
            //使用照片提供的按下效果
            imageView.highlighted = YES;
            
            //给照片加默认按下效果
            //[imageView.layer setOpacity:0.8];
        }
    }
}

- (void)setHighlightDisable
{
    self.backgroundColor = [UIColor whiteColor];
    
    for (id view in self.subviews)
    {
        if ([view isKindOfClass:[UILabel class]])
        {
            [view setHighlighted:NO];
        }
        else if([view isKindOfClass:[UIImageView class]])
        {
            
            UIImageView *imageView = (UIImageView*)view;
            
            //取消照片的按下效果
            imageView.highlighted = NO;
            
            //取消照片的按下效果
            //[imageView.layer setOpacity:1.0];
        }
    }
}

- (void)setNormalState:(BOOL)cancelled
{
    if (!cancelled)
    {
        if ([self.target respondsToSelector:self.action])
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.target performSelector:self.action withObject:self];
#pragma clang diagnostic pop
        }
    }
    [self performSelector:@selector(setHighlightDisable) withObject:nil afterDelay:0.1];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    UITouch *touch = [touches anyObject];
	if ([touch view] == self)
    {
        CGPoint point = [touch locationInView:self];
        if ([self.roundedPath containsPoint:point])
        {
            [self setHighlightForLocation:point];
        }
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	if ([touch view] == self)
	{
		CGPoint point = [touch locationInView:self];
        if (![self.roundedPath containsPoint:point])
        {
            [self setNormalState:YES];
        }
	}
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    UITouch *touch = [touches anyObject];
	
	if ([touch view] == self)
	{
        CGPoint point = [touch locationInView:self];
        BOOL cancelled = ![self.roundedPath containsPoint:point];
        [self setNormalState:cancelled];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self setNormalState:YES];
}

@end
