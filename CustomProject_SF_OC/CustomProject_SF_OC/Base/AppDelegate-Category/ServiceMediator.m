//
//  ServiceMediator.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/7.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "ServiceMediator.h"
#import <Objection/Objection.h>
#import "ShareService.h"
#import "NotificationService.h"
#import "NetworkRequestService.h"


@implementation ServiceMediator

- (void)route {
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    
    //通知服务
    NSObject<NotificationServiceProtocol> *notificationService = [injector getObject:@protocol(NotificationServiceProtocol)];
    [notificationService start];
    
    // 分享服务
    NSObject<ShareServiceProtocol> *shareService = [injector getObject:@protocol(ShareServiceProtocol)];
    [shareService start];
    
    //网络服务
    NSObject<NetworkRequestServiceProtocol> * networkService = [injector getObject:@protocol(NetworkRequestServiceProtocol)];
    [networkService start];
}

@end
