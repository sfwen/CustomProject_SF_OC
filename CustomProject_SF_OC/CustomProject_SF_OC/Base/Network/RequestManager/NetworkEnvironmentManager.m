//
//  NetworkEnvironmentManager.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/8.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "NetworkEnvironmentManager.h"

static NetworkEnvironmentManager *manager = nil;

static NSString * kResultCodeKey = @"code";
static NSString * kReultMessagekey = @"message";
static NSString * kRestltDataKey = @"data";

@implementation NetworkEnvironmentManager

+ (NetworkEnvironmentManager *)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NetworkEnvironmentManager alloc] init];
    });
    return manager;
}

- (NSString *)judgeNetwork:(NetworkEnvironment)networkEnvironment {
    NSString * baseURL = @"";
    switch (networkEnvironment) {
        case NetworkEnvironmentDevelopment:
            baseURL = @"http://www.yanwei365.com:7011";
            break;
            
        default:
            break;
    }
    
    return baseURL;
}

- (id)processData:(id)theData {
    NSString *jsonString = nil;
    if ([NSStringFromClass([theData class]) isEqualToString:@"NSConcreteData"]) {
        jsonString = [[NSString alloc] initWithData:(NSData *)theData
                                           encoding:NSUTF8StringEncoding];
        return [NSString dictionaryWithJsonString:jsonString];
    } else {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData options:NSJSONWritingPrettyPrinted error:&error];
        
        jsonString = [[NSString alloc] initWithData:jsonData
                                           encoding:NSUTF8StringEncoding];
        NSLog(@"%@", [NSString wipeSpaceAndEnterFromStr:jsonString]);
        
        NSDictionary * jsonDict = [NSString dictionaryWithJsonString:jsonString];
        HttpResultCode code = [[jsonDict objectForKey:kResultCodeKey] integerValue];
        if (code == HttpResultCodeSuccess) {
            NSString * data = [jsonDict objectForKey:kRestltDataKey];
            NSMutableDictionary * dictData = [[NSMutableDictionary alloc] init];
            [dictData setObject:data forKey:@"data"];
            return dictData;
//            return jsonDict;
        } else if (jsonDict.count) {
            NSString * errorMessage = [jsonDict objectForKey:kReultMessagekey];
            if (errorMessage.length == 0) {
                return jsonDict;
            } else {
                NSLog(@"%@", errorMessage);
                return nil;
            }
        } else {
            return nil;
        }
    }
}

@end
