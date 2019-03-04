//
//  NSDictionary+Category.h
//  CustomProject_SF_OC
//
//  Created by Land on 2019/3/1.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Category)

/**
 *  截取URL中的参数
 *
 *  @return NSMutableDictionary parameters
 */
+ (NSMutableDictionary *)getURLParametersWithURL:(NSString *)urlStr;

@end
