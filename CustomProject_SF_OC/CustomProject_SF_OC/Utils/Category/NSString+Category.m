//
//  NSString+Category.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/10.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

/** 去除字符串中的空格 */
+ (NSString *)wipeSpaceAndEnterFromStr:(NSString *)str {
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    NSArray *parts = [str componentsSeparatedByCharactersInSet:whitespaces];//在空格处将字符串分割成一个 NSArray
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];//去除空串
    NSString *jointStr  = @"";
    str = [filteredArray componentsJoinedByString:jointStr];
    
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return str;
}

/** 时间戳--->年月日-时间 */
+ (NSString *)convertToDateTime:(NSString *)timestamp {
    
    NSTimeInterval time = [timestamp doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}

/** 时间戳--->年月日 小时-分-秒 */
+ (NSString *)convertToDateTimer:(NSString *)timestamp {
    
    NSTimeInterval time = [timestamp doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}

/** 时间戳--->日期 */
+ (NSString *)convertToDate:(NSString *)timestamp {
    
    NSTimeInterval time = [timestamp doubleValue];//如果不使用本地时区,因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}

//** 时间戳--->时间 */
+ (NSString *)convertToTime:(NSString *)timestamp {
    
    NSTimeInterval time = [timestamp doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}

/** 时间---->时间戳 */
+ (NSString *)convertTotimeSp:(NSString *)timeStr {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setDateFormat:@"MMM dd,yyyy KK:mm:ss aa"];
    NSDate *date = [dateFormatter dateFromString:timeStr];
    NSString *timestamp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];//时间戳
    
    return timestamp;
}

/**
 *  获得与当前时间的差距
 */
+ (NSString *)timeDifferenceWithNowTimer:(NSString *)timerSp {
    
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 后台时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime =[timerSp floatValue];
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    
    //刚刚
    NSInteger small = time / 60;
    if (small <= 0) {
        return [NSString stringWithFormat:@"刚刚"];
    }
    
    //秒转分钟
    if (small < 60) {
        return [NSString stringWithFormat:@"%ld分钟前",(long)small];
    }
    
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%ld小时前",(long)hours];
    }
    //秒转天数
    NSInteger days = time/3600/24;
    if (days < 30) {
        return [NSString stringWithFormat:@"%ld天前",(long)days];
    }
    //秒转月
    NSInteger months = time/3600/24/30;
    if (months < 12) {
        return [NSString stringWithFormat:@"%ld月前",(long)months];
    }
    //秒转年
    NSInteger years = time/3600/24/30/12;
    return [NSString stringWithFormat:@"%ld年前",(long)years];
    
    return [self convertToDate:timerSp];
}

- (NSString *)replacingCharacters:(NSString *)pattern template:(NSString *)template {
    NSRegularExpression * regularExpression = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    return [regularExpression stringByReplacingMatchesInString:self options:(NSMatchingReportProgress) range:NSMakeRange(0, self.length) withTemplate:template];
}

- (BOOL)isValidUrl {
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}

- (BOOL)isGifImage {
    NSString *ext = self.pathExtension.lowercaseString;
    
    if ([ext isEqualToString:@"gif"]) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isGifWithImageData: (NSData *)data {
    if ([[self contentTypeWithImageData:data] isEqualToString:@"gif"]) {
        return YES;
    }
    return NO;
}

+ (NSString *)contentTypeWithImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"jpeg";
            
        case 0x89:
            return @"png";
            
        case 0x47:
            return @"gif";
            
        case 0x49:
        case 0x4D:
            return @"tiff";
            
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            
            return nil;
    }
    
    return nil;
}


/**
 *  返回UILabel自适应后的size
 *
 *  @param aString 字符串
 *  @param width   指定宽度
 *  @param height  指定高度
 *
 *  @return CGSize
 */
+ (CGSize)sizeLabelToFit:(NSAttributedString *)aString width:(CGFloat)width height:(CGFloat)height {
    UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    tempLabel.attributedText = aString;
    tempLabel.numberOfLines = 0;
    [tempLabel sizeToFit];
    CGSize size = tempLabel.frame.size;
    size = CGSizeMake(ceil(size.width), ceil(size.height));
    return size;
}

@end
