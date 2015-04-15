//
//  Constant.h
//  SportsLottery
//
//  Created by Ma Jianglin on 8/15/14.
//  Copyright (c) 2014 totem. All rights reserved.
//

#ifndef PalmPrintery_constant_h
#define PalmPrintery_constant_h

#define SUCCESS_STATUS        @"000000"


//测试服务器
#define SERVER_URL          @"http://printerp.founder.com.cn:8080/"

//正式服务器
//#define SERVER_URL          @"http://www.axp.com.cn:8080/"

#define PATH_LOGIN    @"dataengine/login/login.jsonx"  //登录
#define PATH_CHANGE_PASSWORD    @"dataengine/hvky.jsonx"  //修改密码

#define PATH_ORDER_TYPE_NUMBER    @"dataengine/hviw.jsonx"  //我的订单数字标号
#define PATH_ORDER_WEI    @"dataengine/hvis.jsonx"  //未生产订单
#define PATH_ORDER_ZAI    @"dataengine/hvix.jsonx"  //在生产订单
#define PATH_ORDER_DAI    @"dataengine/hviq.jsonx"  //待发货订单
#define PATH_ORDER_YI    @"dataengine/order/finished_clientid.jsonx"  //已完成订单

#define PATH_BILL_NOTPAY    @"dataengine/hvk6.jsonx"  //未支付订单
#define PATH_BILL_NOBILL    @"dataengine/hviz.jsonx"  //未开票订单
#define PATH_PAPER_MYPAPER  @"dataengine/hvi4.jsonx"  //我的纸
#define PATH_PAPER_PRICE  @"dataengine/paper/getPaperPrice.jsonx"  //纸张价格查询

#define PATH_ORDERPROGRESS     @"dataengine/order/getOrderProgress.jsonx" //订单相关
#define PATH_ORDERSEND     @"dataengine/hvit.jsonx"   //订单发货明细
#define PATH_ORDER_STOCKINANDSENDOUT   @"dataengine/hvia.jsonx"  //订单入库及发货

#define PATH_20150410_105749 @"/dataengine/t/20150410_105749.jsonx" //返回进度显示的工序
#define PATH_20150410_105317 @"/dataengine/t/20150410_105317.jsonx" //查询某个订单的生产进度


/*增加了两个接口：
 [APP]生产工序列表：用于返回进度显示的工序（以下称接口A）
 URL:    /dataengine/t/20150410_105749.jsonx
 格式：{   "status":"000000",
         "message": "查询成功", 
        "rowcount": "4" ,
            "data": [{"cname":"成品","ccode":"gx03","iindex":3},
                     {"cname":"发货","ccode":"gx04","iindex":4},
                     {"cname":"印后","ccode":"gx02","iindex":2},
                     {"cname":"印刷","ccode":"gx01","iindex":1}
                    ]
      }
 说明：cname-工序名称，ccode-工序编号，iindex-序号。iindex可能不连续，从小到大排序。
 
 [APP]订单生成进度：用于查询某个订单的生产进度（以下称接口B）
 URL:  /dataengine/t/20150410_105317.jsonx
 格式：{ "status":"000000", 
       "message": "查询成功", 
      "rowcount": "4" ,
          "data": [{"cname":"成品","ccode":"gx03","cdate":"2015-05-14","iprogress":20},
                   {"cname":"发货","ccode":"gx04","cdate":"2015-05-15","iprogress":0},
                   {"cname":"印后","ccode":"gx02","cdate":"2015-05-13","iprogress":100},
                   {"cname":"印刷","ccode":"gx01","cdate":"2015-05-12","iprogress":100}]
                   }
 
 说明：cname-工序名称，ccode-工序编号，cdate-工序开始日期。iprogress-生产情况(0未生产，100生产完，其它生产中)。
 可能的冲突：
 1) 如果B.cname与A.cname不一致，以接口A.cname为准，按A.ccode=b.ccode关联。
 2) 如果B.ccode在A的列表中找不到，不显示该条B的信息。
 3) 如果B的工序信息不完整，缺少的工序视为没有。
 尚不确定怎么获取真实数据，现有数据只是模拟的，非真实数据。
 
 原来的订单生成进度接口（URL：/dataengine/order/getOrderProgress.jsonx）不用了，但不删除继续留在。
*/
#define ws(self) __weak typeof(self)
#endif
