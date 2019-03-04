//
//  ServiceModule.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/7.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "ServiceModule.h"
#import "ServiceMediator.h"
#import "ShareService.h"
#import "NotificationService.h"
#import "NetworkRequestService.h"

@implementation ServiceModule

+ (void)load {
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure {
    [self bindClass:[ServiceMediator class] toProtocol:@protocol(ServiceMediatorProtocol)];
    
    [self bindClass:[NotificationService class] toProtocol:@protocol(NotificationServiceProtocol)];
    [self bindClass:[ShareService class] toProtocol:@protocol(ShareServiceProtocol)];
    [self bindClass:[NetworkRequestService class] toProtocol:@protocol(NetworkRequestServiceProtocol)];
}

@end
