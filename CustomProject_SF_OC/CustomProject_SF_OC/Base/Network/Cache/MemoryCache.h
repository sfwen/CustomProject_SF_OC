//
//  MemoryCache.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/8.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemoryCache : NSObject

/**
 *  将数据写入内存
 *
 *  @param data 数据
 *  @param key  键值
 */
+ (void)writeData:(id) data forKey:(NSString *)key;

/**
 *  从内存中读取数据
 *
 *  @param key 键值
 *
 *  @return 数据
 */
+ (id)readDataWithKey:(NSString *)key;

@end
