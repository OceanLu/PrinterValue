//
//  TTGlobalTimer.m
//  ReadTV
//
//  Created by readtv on 14-1-10.
//  Copyright (c) 2014年 readtv.cn. All rights reserved.
//

#import "TTGlobalTimer.h"

@implementation TTGlobalTimer


static TTGlobalTimer *_sharedInstance = nil;


- (void)ticker:(NSTimer *)timer
{
    //发送到计时通知，每秒1次
    
    
//    NSDictionary *dict = [NSDictionary dictionaryWithObject:@(_countDown) forKey:@"countDown"];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kVerifiCodeTimerCountDown object:nil userInfo:nil];

}

-(void)startCountDown
{
   _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(ticker:) userInfo:nil repeats:YES];
}

+(id)alloc
{
    @synchronized([TTGlobalTimer class])
    {
        NSAssert(_sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
        return [super alloc];
    }
}

+ (TTGlobalTimer *)sharedInstance
{
    @synchronized([TTGlobalTimer class])
    {
        if (!_sharedInstance)
        {
            _sharedInstance = [[TTGlobalTimer alloc] init];
        }
    }
    return _sharedInstance;
}

@end
