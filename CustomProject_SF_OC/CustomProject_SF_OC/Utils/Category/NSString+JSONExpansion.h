//
//  NSString+JSONExpansion.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/8.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSONExpansion)

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString*)dictionaryToJSONString:(NSDictionary *)dic;
+ (NSString *)arrayToJSONString:(NSArray *)array;

@end
