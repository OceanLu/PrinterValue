//
//  DataModel.h
//  EWalking
//
//  Created by Ma Jianglin on 7/11/13.
//  Copyright (c) 2013 totemtec.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Response : NSObject

@property (nonatomic, strong) NSString* status;
@property (nonatomic, strong) NSString* message;
@property (nonatomic) BOOL hasMore;

+ (Response*)responseWithDict:(NSDictionary*)dict;

- (BOOL) isSuccess;

@end

//用户信息
@interface PPUser : NSObject<NSCoding>
{
}
@property (nonatomic) long long userId;         //账户Id
@property (nonatomic) long long clientId;       //用户Id

@property (nonatomic, strong) NSString *nickName;       //显示名称
@property (nonatomic, strong) NSString *userName;       //登录名称
@property (nonatomic, strong) NSString *clientName;     //客户名称
@property (nonatomic, strong) NSString *userPassword;   //登录密码
@property (nonatomic, strong) NSString *addTime;        //添加时间

+ (PPUser *)userWithDict:(NSDictionary *)dict;

@end


@interface PPNoPayBill : NSObject<NSObject>           //未支付订单

@property (nonatomic, strong) NSString *code;         //发票号
@property (nonatomic) CGFloat billAmount;             //发票金额
@property (nonatomic) CGFloat unpaidAmount;           //未付金额


+ (PPNoPayBill *)noPayBillWithDict:(NSDictionary *)dict;

@end


@interface PPNoBill : NSObject<NSObject>               //未开票订单

@property (nonatomic) long long billId;                //订单Id
@property (nonatomic, strong) NSString *billName;      //印件名称
@property (nonatomic, strong) NSString *code;          //承印单号
@property (nonatomic, strong) NSString *printCode;     //委印单号
@property (nonatomic) CGFloat billAmount;              //订单金额
@property (nonatomic) CGFloat noBillAmount;            //未开票金额
@property (nonatomic) NSInteger bookCount;             //未开票金额

+ (PPNoBill *)nobillWithDict:(NSDictionary *)dict;

@end


@interface PPMyPaper : NSObject<NSObject>               //我的纸

@property (nonatomic, strong) NSString *name;           //纸张名
@property (nonatomic, strong) NSString *unit;           //单位
@property (nonatomic, strong) NSString *weight;         //克重
@property (nonatomic, strong) NSString *size;           //规格
@property (nonatomic) CGFloat num;                      //数量

+ (PPMyPaper *)myPaperWithDict:(NSDictionary *)dict;

@end


@interface PPPaperPrice : NSObject<NSObject>            //纸张价格

@property (nonatomic) long long paperId;                //纸张Id
@property (nonatomic, strong) NSString *unit;           //单位
@property (nonatomic, strong) NSString *name;           //纸张名
@property (nonatomic, strong) NSString *size;           //规格
@property (nonatomic, strong) NSString *weight;         //克重
@property (nonatomic) CGFloat price;                    //承印价

+ (PPPaperPrice *)paperPriceWithDict:(NSDictionary *)dict;

@end


@interface PPOrderProgress : NSObject

@property (nonatomic) long long orderId; //订单ID

@property (copy, nonatomic) NSString *cCode; //承印单号

@property (copy, nonatomic) NSString *cName; //印件名称

@property (nonatomic) NSInteger iBookCount; //印数

@property (copy, nonatomic) NSString *cISBN;

@property (copy, nonatomic) NSString *dataPrint;  //制单日期

@property (copy, nonatomic) NSString *dataOver;  //完成日期

@property (copy, nonatomic) NSString *cPrintCode;  //委印单号

@property (nonatomic) CGFloat printProgress;   // 印刷进度

@property (nonatomic) CGFloat  packProgress;   //装订进度

@property (nonatomic) CGFloat outStoreProgress;   //发货进度

+ (instancetype)orderProgressWithDict:(NSDictionary *)dict;

@end

@interface PPStorageAndSend : NSObject

@property (nonatomic) NSInteger stockinAmount; //入库数量

@property (copy, nonatomic) NSString *stockinDate; //入库时间

@property (nonatomic) NSInteger sendoutAmount; // 出库数量

@property (copy, nonatomic) NSString *sendoutDate; // 出库时间

+ (instancetype)storageAndSendWithDict:(NSDictionary *)dict;


@end

@interface PPSendMerchandise : NSObject

@property (copy, nonatomic) NSString *cNumber; //发货单号

@property (copy, nonatomic) NSString *cAddress; //发货地址

@property (nonatomic) NSInteger iQuantity;   //发货数量

@property (nonatomic) NSInteger iSignIn;  //签收标识

@property (copy, nonatomic) NSString *dDeliveryDate; //发货日期

+ (instancetype)sendMerchandiseWithDict:(NSDictionary *)dict;

@end


@interface Pprocess : NSObject
@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *ccode;
@property (nonatomic, assign) NSInteger iindex;
+ (instancetype)PprocessWithDict:(NSDictionary *)dict;

@end

@interface Pprogress : NSObject
@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *ccode;
@property (nonatomic, copy) NSString *cdate;
@property (nonatomic, assign) NSInteger iprogress;

+ (instancetype) PprogressWithDict:(NSDictionary *) dict;
@end
