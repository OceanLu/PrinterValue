//
//  TTGlobalTimer.h
//  ReadTV
//
//  Created by readtv on 14-1-10.
//  Copyright (c) 2014年 readtv.cn. All rights reserved.
//

#import <Foundation/Foundation.h>



#define kVerifiCodeTimerCountDown   @"kVerifiCodeTimerCountDown"
//static int countDown = 61;

@interface TTGlobalTimer : NSObject

+(TTGlobalTimer *)sharedInstance;

@property(nonatomic) int countDown;

-(void)startCountDown;


@property (strong,nonatomic) NSTimer *timer;
//@property (strong,nonatomic) CADisplayLink *timer;

@end
