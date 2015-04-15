//
//  RTVDataModel.m
//  EWalking
//
//  Created by Ma Jianglin on 7/11/13.
//  Copyright (c) 2013 totemtec.com. All rights reserved.
//

#import "DataModel.h"
#import "constant.h"

@implementation NSDictionary (NullReplace)

- (id)objectForKeyNotNull:(NSString *)key
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSNumber class]] ||
        [object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSArray class]] ||
        [object isKindOfClass:[NSDictionary class]])
    {
        return object;
    }
    return nil;
}

@end

@implementation Response

+ (Response*)responseWithDict:(NSDictionary*)dict
{
    Response* response = [[Response alloc] init];
    response.status = [dict objectForKeyNotNull:@"status"];
    response.message = [dict objectForKeyNotNull:@"message"];
    response.hasMore = [[dict objectForKeyNotNull:@"has_more"] boolValue];

    return response;
}

- (BOOL) isSuccess
{
    if ([self.status isEqualToString:SUCCESS_STATUS])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end



@implementation PPUser

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]])
    {
        self.userId       = [[dict objectForKeyNotNull:@"id"] longLongValue];
        self.clientId     = [[dict objectForKeyNotNull:@"idclient"] longLongValue];
        self.userName     = [dict objectForKeyNotNull:@"cusername"];
        self.userPassword = [dict objectForKeyNotNull:@"cpassword"];
        self.nickName     = [dict objectForKeyNotNull:@"cviewname"];
        self.addTime      = [dict objectForKeyNotNull:@"daddtime"];
        self.clientName   = [dict objectForKeyNotNull:@"cClientName"];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.userId = [aDecoder decodeInt64ForKey:@"userId"];
        self.clientId = [aDecoder decodeInt64ForKey:@"clientId"];
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.userPassword = [aDecoder decodeObjectForKey:@"userPassword"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.addTime = [aDecoder decodeObjectForKey:@"addTime"];
        self.clientName = [aDecoder decodeObjectForKey:@"clientName"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt64:self.userId forKey:@"userId"];
    [aCoder encodeInt64:self.clientId forKey:@"clientId"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.clientName forKey:@"clientName"];
    [aCoder encodeObject:self.userPassword forKey:@"userPassword"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.addTime forKey:@"addTime"];
}

+ (PPUser *)userWithDict:(NSDictionary *)dict
{
    return [[PPUser alloc] initWithDict:dict];
}

@end


@implementation PPNoPayBill

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]])
    {
        self.code = [dict objectForKeyNotNull:@"cCode"];
        self.billAmount = [[dict objectForKeyNotNull:@"nMoney"] floatValue];
        self.unpaidAmount = [[dict objectForKeyNotNull:@"nUnpaid"] floatValue];
    }
    return self;
}

+ (PPNoPayBill *)noPayBillWithDict:(NSDictionary *)dict
{
    return [[PPNoPayBill alloc] initWithDict:dict];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"ccode %@, nmoney %lf, nunpaid %lf",self.code,self.billAmount,self.unpaidAmount];
}
@end


@implementation PPNoBill

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]])
    {
        self.billId       = [[dict objectForKeyNotNull:@"id"] longLongValue];
        self.billName     = [dict objectForKeyNotNull:@"cName"];
        self.code         = [dict objectForKeyNotNull:@"cCode"];
        self.printCode    = [dict objectForKeyNotNull:@"cPrintCode"];
        self.billAmount   = [[dict objectForKeyNotNull:@"nJob"] floatValue];
        self.noBillAmount = [[dict objectForKeyNotNull:@"nUninvoiced"] floatValue];
        self.bookCount    = [[dict objectForKeyNotNull:@"ibookcount"] integerValue];
    }
    return self;
}

+ (PPNoBill *)nobillWithDict:(NSDictionary *)dict
{
    return [[PPNoBill alloc] initWithDict:dict];
}

@end


@implementation PPMyPaper

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]])
    {
        self.name = [dict objectForKeyNotNull:@"cPaperName"];
        self.unit = [dict objectForKeyNotNull:@"cUnit"];
        self.weight = [dict objectForKeyNotNull:@"nkz"];
        self.size = [dict objectForKeyNotNull:@"cgg"];
        self.num = [[dict objectForKeyNotNull:@"nOutAMount"] floatValue];
    }
    return self;
}

+ (PPMyPaper *)myPaperWithDict:(NSDictionary *)dict
{
    return [[PPMyPaper alloc] initWithDict:dict];
}

@end


@implementation PPPaperPrice

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]])
    {
        self.paperId = [[dict objectForKeyNotNull:@"izgid"] longLongValue];
        self.unit = [dict objectForKeyNotNull:@"cUnit"];
        self.name = [dict objectForKeyNotNull:@"chj"];
        self.size = [dict objectForKeyNotNull:@"cgg"];
        self.weight = [dict objectForKeyNotNull:@"nkz"];
        self.price = [[dict objectForKeyNotNull:@"ncyj_fb"] floatValue];
    }
    return self;
}

+ (PPPaperPrice *)paperPriceWithDict:(NSDictionary *)dict
{
    return [[PPPaperPrice alloc] initWithDict:dict];
}

@end


@implementation PPOrderProgress

- (instancetype)initWithDict:(NSDictionary *)dict{
    self= [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]){
        self.orderId = [[dict objectForKey:@"id"] longLongValue];
        self.cCode = [dict objectForKey:@"cCode"];
        self.cName = [dict objectForKey:@"cName"];
        self.iBookCount = [[dict objectForKey:@"ibookcount"] integerValue];
        self.dataPrint = [dict objectForKey:@"ddate_Print"];
        self.dataOver = [dict objectForKey:@"ddate_Over"];
        self.cISBN = [dict objectForKey:@"cISBN"];
        if(self.dataPrint.length > 0){
            NSArray *array = [self.dataPrint componentsSeparatedByString:@"-"];
            self.dataPrint = @"";
            for(NSString * str in array){
                self.dataPrint = [self.dataPrint stringByAppendingString:str];
                self.dataPrint = [self.dataPrint stringByAppendingString:@"."];
            }
            self.dataPrint = [ self.dataPrint substringToIndex:self.dataPrint.length - 1];
        }

        self.cPrintCode = [dict objectForKeyNotNull:@"cPrintCode"];
        self.printProgress = [[dict objectForKey:@"nPrinted"] floatValue];
        self.packProgress = [[dict objectForKey:@"nPacked"] floatValue];
        self.outStoreProgress = [[dict objectForKey:@"nOutStore"] floatValue];
        
        if (self.dataOver.length > 0)
        {
            NSArray *mArray = [self.dataOver componentsSeparatedByString:@"-"];
            self.dataOver = @"";
            for(NSString * str in mArray){
                self.dataOver = [self.dataOver stringByAppendingString:str];
                self.dataOver = [self.dataOver stringByAppendingString:@"."];
            }
            self.dataOver = [ self.dataOver substringToIndex:self.dataOver.length - 1];
        }
        
    }
    return self;
}

+ (instancetype)orderProgressWithDict:(NSDictionary *)dict{
    return [[PPOrderProgress alloc] initWithDict:dict ];
}

@end

@implementation PPStorageAndSend

- (instancetype) initWithDict:(NSDictionary *)dict{
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]){
        self.stockinAmount = [[dict objectForKey:@"stockinAmount"] integerValue];
        self.stockinDate = [dict objectForKey:@"stockinDate"];
        self.sendoutAmount = [[dict objectForKey:@"sendoutAmount"] integerValue];
        self.sendoutDate = [dict objectForKey:@"sendoutDate"];
        NSArray *array = [self.stockinDate componentsSeparatedByString:@"-"];
        self.stockinDate = @"";
        for(NSString * str in array){
            self.stockinDate = [self.stockinDate stringByAppendingString:str];
            self.stockinDate = [self.stockinDate stringByAppendingString:@"."];
        }
        self.stockinDate = [ self.stockinDate substringToIndex:self.stockinDate.length - 1];
        array = [self.sendoutDate componentsSeparatedByString:@"-"];
        self.sendoutDate = @"";
        for(NSString * str in array){
            self.sendoutDate = [self.sendoutDate stringByAppendingString:str];
            self.sendoutDate = [self.sendoutDate stringByAppendingString:@"."];
        }
        self.sendoutDate = [ self.sendoutDate substringToIndex:self.sendoutDate.length - 1];
    }
    return self;
}
+ (instancetype)storageAndSendWithDict:(NSDictionary *)dict{
    return [[PPStorageAndSend alloc] initWithDict:dict];
}

@end

@implementation PPSendMerchandise

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if(self && [dict isMemberOfClass:[NSDictionary class]]){
        self.cNumber = [dict objectForKey:@"cNumber"];
        self.cAddress = [dict objectForKey:@"cAddress"];
        self.iQuantity = [[dict objectForKey:@"iQuantity"] integerValue];
        self.iSignIn = [[dict objectForKey:@"iSignIn"] integerValue];
        self.dDeliveryDate = [dict objectForKey:@"dDeliveryDate"];
    }
    return self;
}

+ (instancetype) sendMerchandiseWithDict:(NSDictionary *)dict{
    return [[PPSendMerchandise alloc] initWithDict:dict];
}

@end

@implementation Pprocess
- (instancetype)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void) setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"keyUndefine - %@",key);
}

+ (instancetype)PprocessWithDict:(NSDictionary *)dict
{
    return [[Pprocess alloc] initWithDict:dict];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"iindex %ld, cname %@,ccode %@",self.iindex,self.cname,self.ccode];
}
@end

@implementation Pprogress
- (instancetype)initWithDict:(NSDictionary *) dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void) setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"keyUndefine - %@",key);
}

+ (instancetype) PprogressWithDict:(NSDictionary *)dict
{
    return [[Pprogress alloc] initWithDict:dict];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"cdate %@,cname %@,ccode %@,iprogress %ld",self.cdate,self.cname,self.ccode,self.iprogress];
}

@end
