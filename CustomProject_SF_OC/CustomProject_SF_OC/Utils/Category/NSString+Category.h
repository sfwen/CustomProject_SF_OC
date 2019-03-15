//
//  NSString+Category.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/10.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)


/** 去除字符串中的空格和换行符 */
+ (NSString *)wipeSpaceAndEnterFromStr:(NSString *)str;

/** 时间戳--->年月日 小时-分 */
+ (NSString *)convertToDateTime:(NSString *)timestamp;

/** 时间戳--->年月日 小时-分-秒 */
+ (NSString *)convertToDateTimer:(NSString *)timestamp;

/** 时间戳--->日期 */
+ (NSString *)convertToDate:(NSString *)timestamp;

//** 时间戳--->时间 */
+ (NSString *)convertToTime:(NSString *)timestamp;

/** 时间---->时间戳 */
+ (NSString *)convertTotimeSp:(NSString *)timeStr;

/**
 *  获得与当前时间的差距
 */
+ (NSString *)timeDifferenceWithNowTimer:(NSString *)timerSp;

- (NSString *)replacingCharacters:(NSString *)pattern template:(NSString *)templateStr;

/**
 判断该字符串是不是一个有效的URL
 
 @return YES：是一个有效的URL or NO
 */
- (BOOL)isValidUrl;

/** 根据图片名 判断是否是gif图 */
- (BOOL)isGifImage;

/** 根据图片data 判断是否是gif图 */
+ (BOOL)isGifWithImageData: (NSData *)data;

/**
 根据image的data 判断图片类型
 
 @param data 图片data
 @return 图片类型(png、jpg...)
 */
+ (NSString *)contentTypeWithImageData: (NSData *)data;

/**
 *  返回UILabel自适应后的size
 *
 *  @param aString 字符串
 *  @param width   指定宽度
 *  @param height  指定高度
 *
 *  @return CGSize
 */
+ (CGSize)sizeLabelToFit:(NSAttributedString *)aString width:(CGFloat)width height:(CGFloat)height;

@end
