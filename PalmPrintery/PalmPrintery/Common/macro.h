//
//  micro.h
//  SportsLottery
//
//  Created by Ma Jianglin on 8/15/14.
//  Copyright (c) 2014 totem. All rights reserved.
//

#ifndef PalmPrintery_macro_h
#define PalmPrintery_macro_h


#define ALog(format, ...) NSLog((@"%s [L%d] " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#ifdef DEBUG
#define TTLog(format, ...) ALog(format, ##__VA_ARGS__)
#else
#define TTLog(...)
#endif

#define SharedAppDelegate ((AppDelegate*)[[UIApplication sharedApplication] delegate])


#define UIColorRGB(r, g, b)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define UIColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)/255.0]
#define UIColorHSL(h, s, l)     [UIColor colorWithHue:(h)/255.0f saturation:(s)/255.0f brightness:(l)/255.0f alpha:1.0f]
#define UIColorHSLA(h, s, l, a) [UIColor colorWithHue:(h)/255.0f saturation:(s)/255.0f brightness:(l)/255.0f alpha:(a)/255.0f]

#define SearchBarBackgroundColor [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1]

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define GHS_TEXT_COLOR   [UIColor colorWithRed:0.4902 green:0.4902 blue:0.4902 alpha:1]
#define GHS_LOGO_COLOR   [UIColor colorWithRed:0.498 green:0.063 blue:0.5216 alpha:1]
#define GHS_GRAY_COLOR   [UIColor colorWithRed:0.851 green:0.851 blue:0.851 alpha:1]

#define GHS_COLOR   [UIColor colorWithRed:167/255.0 green:79/255.0 blue:176/255.0 alpha:1]

//insert by Liuhy
#define TABLE_BACKGROUD_COLOR [UIColor colorWithRed:244/255 green:244/255 blue:244/255 alpha:1]
#define STANDARD_HIGHT 44
#define STANDARD_STATUTBAR_HIGHT 20
#define MYACCOUNT_UNDERLINE_OFFSET 12
#define keyForColor_yellow [UIColor colorWithRed:235/255.0 green:188/255.0 blue:42/255.0 alpha:1]
#define keyForColor_green [UIColor colorWithRed:90/255.0 green:193/255.0 blue:91/255.0 alpha:1]
#define keyForColor_red [UIColor colorWithRed:232/255.0 green:68/255.0 blue:59/255.0 alpha:1]


#define PAGE_REQUEST_PARAMETER(count) @{@"pageindex":@(count),@"pagesize":@20}//第一次请求参数
#define PAGESIZE 20
#endif
