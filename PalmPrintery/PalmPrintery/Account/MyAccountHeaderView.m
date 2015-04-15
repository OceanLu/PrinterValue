//
//  MyAccountHeaderView.m
//  PalmPrintery
//
//  Created by 刘海洋 on 15/4/8.
//  Copyright (c) 2015年 totem. All rights reserved.
//

#import "MyAccountHeaderView.h"
#import "AppDelegate.h"
#import "macro.h"
#import "DataModel.h"
@implementation MyAccountHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView* backgroudImageV = [[UIImageView alloc] initWithFrame:frame];
        backgroudImageV.image = [UIImage imageNamed:@"account_bg"];
        [self addSubview:backgroudImageV];
        
        
        UIImageView* titleImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 71, 71)];
        titleImageV.image = [UIImage imageNamed:@"account_logo"];
        titleImageV.center = backgroudImageV.center;
        [backgroudImageV addSubview:titleImageV];
        
        
        self.descreptionLabel = [[UILabel alloc] init];
        self.descreptionLabel.font = [UIFont systemFontOfSize:14];
        self.descreptionLabel.textColor = [UIColor whiteColor];
        self.descreptionLabel.textAlignment = NSTextAlignmentLeft;
        self.descreptionLabel.text = [NSString stringWithFormat:@"你好，%@", SharedAppDelegate.user.clientName];
        [self.descreptionLabel sizeToFit];
        self.descreptionLabel.center = CGPointMake(titleImageV.center.x, titleImageV.center.y + 40);
        [backgroudImageV addSubview:self.descreptionLabel];

    }
    return self;
}
@end
