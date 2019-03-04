//
//  NetworkRequestService.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/8.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "NetworkRequestService.h"
#import "DeviceInfoManager.h"

@implementation NetworkRequestService

- (void)start {
    NSLog(@"执行了网络服务");

    //配置请求头
    NSMutableDictionary * header = [[NSMutableDictionary alloc] init];
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [header setObject:uuid forKey:@"psid"];
    [header setObject:@"1.0.0" forKey:@"api-ver"];
    [header setObject:kChannelValue forKey:@"channel"];
    [header setObject:@"Extended" forKey:@"lifecycle"];
    [header setObject:@"ooo_PJ" forKey:@"merchant"];
    [header setObject:[[DeviceInfoManager sharedManager] getAppVerion] forKey:@"app-ver"];
    
    [NetworkHelper configHttpHeader:header];
}

@end
