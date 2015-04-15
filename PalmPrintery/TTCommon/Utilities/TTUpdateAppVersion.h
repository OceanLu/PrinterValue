//
//  TTUpdateAppVersion.h
//  SportsLottery
//
//  Created by Jia Xiaochao on 14-8-29.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTUpdateAppVersion : NSObject<UIAlertViewDelegate>

+(TTUpdateAppVersion *)sharedInstance;


-(void)updateApp:(NSString *)urlString parameters:(NSDictionary *)parameters isShowTosh:(BOOL)flag;

@end
