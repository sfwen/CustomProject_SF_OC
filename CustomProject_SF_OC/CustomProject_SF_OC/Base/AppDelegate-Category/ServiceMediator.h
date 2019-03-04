//
//  ServiceMediator.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/7.
//  Copyright © 2018年 sfwen. All rights reserved.
//


@protocol ServiceMediatorProtocol <NSObject>

- (void)route;

@end

@interface ServiceMediator : NSObject <ServiceMediatorProtocol>

@end
