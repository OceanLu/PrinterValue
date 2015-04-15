//
//  OrderTypeView.h
//  PalmPrintery
//
//  Created by PrinterpValue  on 15/4/7.
//  Copyright (c) 2015年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTypeView : UIView

@property (nonatomic, retain) NSMutableArray *buttons;
@property (nonatomic, retain) UIImageView *underLine;

- (id)initWithFrame:(CGRect)frame andTarget:(id) target andAction:(SEL) action;

@end
