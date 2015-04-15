//
//  TTRoundedCornerView.h
//  Test
//
//  Created by Ma Jianglin on 9/18/14.
//  Copyright (c) 2014 totem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTRoundedCornerView : UIView

@property(nonatomic, weak) id target;
@property(nonatomic) SEL action;

-(void)addRoundedCorners:(UIRectCorner)corners withRadius:(CGFloat)radius;

@end
