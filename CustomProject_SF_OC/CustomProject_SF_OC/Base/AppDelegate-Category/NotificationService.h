//
//  NotificationService.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/7.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceProtocol.h"

@protocol NotificationServiceProtocol <ServiceProtocol>

@end

@interface NotificationService : NSObject <NotificationServiceProtocol>

@end
