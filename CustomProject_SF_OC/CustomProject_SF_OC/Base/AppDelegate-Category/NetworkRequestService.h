//
//  NetworkRequestService.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/8.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceProtocol.h"

@protocol NetworkRequestServiceProtocol <ServiceProtocol>

@end
//PrefixHeader
@interface NetworkRequestService : NSObject <NetworkRequestServiceProtocol>

@end
