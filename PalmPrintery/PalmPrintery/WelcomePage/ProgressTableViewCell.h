//
//  ProgressTableViewCell.h
//  PalmPrintery
//
//  Created by PrinterpValue  on 15/4/2.
//  Copyright (c) 2015年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
typedef enum{
    KeyForColor_Green  = 0,
    KeyForColor_Yellow ,
    KeyForColor_Red
} KeyForColor;

@interface ProgressTableViewCell : UITableViewCell
@property (nonatomic, assign) KeyForColor status;
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *mainLabel;

@property (nonatomic, strong) UILabel *stockinAmount;
@property (nonatomic, strong) UILabel *stockinDate;
@property (nonatomic, strong) UILabel *sendoutAmount;
@property (nonatomic, strong) UILabel *sendoutDate;

- (void) setPropertyWithModel:(Pprogress*) progress;
@end
