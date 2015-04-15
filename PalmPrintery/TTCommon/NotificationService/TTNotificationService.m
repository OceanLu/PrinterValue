//
//  TTNotificationService.m
//  TTCommon
//
//  Created by Ma Jianglin on 3/20/13.
//  Copyright (c) 2013 totemtec.com. All rights reserved.
//

#import "TTNotificationService.h"
#import "constant.h"
#import "AppDelegate.h"

static TTNotificationService *_sharedService = nil;

@implementation TTNotificationService

@synthesize deviceToken=_deviceToken;

+(id)alloc
{
    @synchronized([TTNotificationService class])
    {
        NSAssert(_sharedService == nil, @"Attempted to allocate a second instance of a singleton.");
        return [super alloc];
    }
}

- (id)init
{
    self = [super init];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    
    return self;
}

+ (TTNotificationService *)sharedService
{
    @synchronized([TTNotificationService class])
    {
        if (!_sharedService)
        {
            _sharedService = [[TTNotificationService alloc] init];
        }
    }
    return _sharedService;
}

#define KEY_DEVICE_TOKEN    @"totem.service.remote_notification.devicetoken"

- (void)setDeviceToken:(NSString *)deviceToken
{
    _deviceToken = deviceToken;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (_deviceToken)
    {
        [prefs setObject:_deviceToken forKey:KEY_DEVICE_TOKEN];
    }
    else
    {
        [prefs removeObjectForKey:KEY_DEVICE_TOKEN];
    }
    [prefs synchronize];
}

- (NSString*)deviceToken
{
    if (!_deviceToken)
    {
         NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        _deviceToken = [prefs objectForKey:KEY_DEVICE_TOKEN];
    }
    return _deviceToken;
}

#pragma mark - Register For Remote Notification

-(void)registerForRemoteNotification
{
#if !TARGET_IPHONE_SIMULATOR
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge
      | UIRemoteNotificationTypeSound
      | UIRemoteNotificationTypeAlert)];
    
#endif
}

- (void)successRegisterWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    self.deviceToken = token;
    
    NSLog(@"device token: %@", self.deviceToken);
    
    [self postDeviceToken];
}

- (void)failedRegisterWithError:(NSError*)error
{
    NSLog(@"failedRegisterWithError: error = %@", error);
    
    //不能清空deviceToken
//    self.deviceToken = nil;
}



- (void)postDeviceToken
{
    //拿到deviceToken后才进行发送给服务器
    
    if (self.deviceToken.length == 0 || self.userId == nil)
    {
        return;
    }
    
    //准备参数
    NSString *deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *systemType = @"iPhone"; //0:iPhone, 1:Android
    
    NSString *notificationStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"notification"];
    
    NSString *notification;
    if ([notificationStr isEqualToString:@"on"])
    {
        notification = @"1";
    }
    else
    {
        notification = @"0";
    }
    
    NSDictionary *params = @{@"user_id":self.userId,
                             @"device_token":self.deviceToken,
                             @"device_id":deviceId,
                             @"device_type":systemType,
                             @"notification":notification};

    
    NSString *content = [self encodeFormPostParameters:params];
    
    NSData *postData = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    //准备请求
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, SERVER_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:20.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    //异步发起请求
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         //连接错误
         if (connectionError)
         {
             NSLog(@"Connection Error : %@", connectionError);
             return;
         }
         
         //JSON错误
         NSError *jsonError;
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
         if (jsonError)
         {
             NSLog(@"JSON Error : %@", jsonError);
             return;
         }
         
         //注册成功
         if ([[dict objectForKey:@"code"] intValue] == 1)//SUCCESS_CODE)
         {
             NSLog(@"Device Token Register Success!");
         }
         //注册失败
         else
         {
             NSLog(@"Device Token Register Failed: %@", [dict objectForKey:@"message"]);
         }
     }];
}

- (void)applicationDidEnterBackground:(NSNotification*)notification
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillEnterForeground:(NSNotification*)notification
{
    [self postDeviceToken];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Encode Form Post Parameters

- (NSString *)encodeFormPostParameters:(NSDictionary *)params
{
    NSMutableString *results = [[NSMutableString alloc] init];
    NSEnumerator *keys = [params keyEnumerator];
    
    NSString *name = [keys nextObject];
    while (nil != name)
    {
        CFStringRef value = CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                   (CFStringRef)[params objectForKey:name],
                                                                   NULL,
                                                                   CFSTR("=/:"),
                                                                   kCFStringEncodingUTF8);
        
        NSString *encodedValue = (__bridge NSString *)value;
        
        [results appendString:name];
        [results appendString:@"="];
        [results appendString:encodedValue];
        
        CFRelease(value);
        
        name = [keys nextObject];
        
        if (nil != name)
        {
            [results appendString: @"&"];
        }
    }
    
    return results;
}

@end
