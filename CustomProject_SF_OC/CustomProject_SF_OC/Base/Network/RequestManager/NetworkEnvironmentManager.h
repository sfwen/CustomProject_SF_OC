//
//  NetworkEnvironmentManager.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/8.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HttpResultCode) {
    HttpResultCodeSuccess = 200,//成功
    HttpResultCodeTokenInvalid = 922999,//令牌无效
    HttpResultCodeAuthenticationFailed = 922998,//权限认证失败
    HttpResultCodeLoginFailed = 923999,//登录失败
    HttpResultCodeOrderNotAllowRefund = 152020,//订单当前状态不允许申请退款
    HttpResultCodeOrderNotAllowPay = 152017,//订单当前状态不允许发起支付
    HttpResultCodeOrderProcessing = 152018,//订单处理中，请稍后
    HttpResultCodePaySUCCESS = 153001,//支付成功
    HttpResultCodeNotFindUser = 921012,//用户不存在
    HttpResultCodeGoodsOutline = 152024,//商品下架
    HttpResultCodeOutStock = 131038, // 该规格暂时缺货
    
    HttpResultCodeUserPayFrozenWar = 921056,//账号已处于冻结状态
    HttpResultCodeUserPayVerifyFailed = 921054,//用户支付密码错误
    HttpResultCodeUserAccountNotExisted = 921057,//用户钱包账号不存在
    HttpResultCodePaymentOrderNotExist = 153004,//支付订单不存在
    HttpResultCodePaymentOrderInfoError = 153005,//支付订单信息有误
    HttpResultCodeWalletBalanceNotEnough = 143006,//钱包余额不够
    HttpResultCodePayFailed = 153002,//支付失败
    HttpResultCodeUserPayFrozenBySystem = 921059,//钱包处于管理员手动冻结的时候的错误返回码
    HttpResultCodeUserPayFrozenNotice = 921058,//支付密码超过5次错误,账户进入10分钟冻结状态
};

@interface NetworkEnvironmentManager : NSObject

+ (NetworkEnvironmentManager *)shareManager;

- (NSString *)judgeNetwork:(NetworkEnvironment)networkEnvironment;

- (id)processData:(id)theData;

@end
