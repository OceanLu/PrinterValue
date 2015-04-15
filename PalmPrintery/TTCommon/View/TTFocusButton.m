//
//  TTFocusButton.m
//  SportsLottery
//
//  Created by totem on 14-8-21.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TTFocusButton.h"

@implementation TTFocusButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, contentRect.size.height-40, contentRect.size.width, 40);
}


@end
