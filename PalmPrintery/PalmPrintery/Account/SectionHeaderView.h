//
//  SectionHeaderView.h
//  PalmPrintery
//
//  Created by PrinterpValue  on 15/3/23.
//  Copyright (c) 2015年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HearderUpLineOnly = 0,
    HearderDonwLineOnly,
    HearderLineAll,
    HearderMax
}HearderType;

typedef enum {
    BasicSettingSection = 0,
    SoftwareSettingSection,
    LogoutSection,
    SectionHeaderMax
}SectionHeader;

@interface SectionHeaderView : UIView

@property (nonatomic, assign) HearderType type;

@end
