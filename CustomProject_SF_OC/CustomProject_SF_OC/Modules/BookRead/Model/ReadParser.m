//
//  ReadParser.m
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/5.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "ReadParser.h"
#import "ReadChapterListModel.h"

@implementation ReadParser

/**
 主线程解析本地URL
 
 @param url URL
 @return ReadModel
 */
+ (ReadModel *)mainThreadParserLocalURL:(NSURL *)url {
    NSString * bookID = [[Tools sharedManager] getFileName:url];
    
    ReadModel * readModel;
    if (![ReadModel IsExistReadModel:bookID]) {
        //不存在
        // 阅读模型
        readModel = [ReadModel readModel:bookID];
        
        // 解析数据
        NSString * content = [self encodeURL:url];
        // 获得章节列表
        readModel.readChapterListModels = [self parserContentWithBookID:bookID content:content];
        // 设置阅读记录 第一个章节 为 首个章节ID
        ReadChapterListModel * readChapterListModel = readModel.readChapterListModels.firstObject;
        [readModel modifyReadRecordModelWithChapterID:readChapterListModel.id toPage:0 isUpdateFont:NO isSave:NO];
        
        // 保存
        [readModel save];
    } else {
        readModel = [ReadModel readModel:bookID];
    }
    
    return readModel;
}

+ (NSArray *)parserContentWithBookID:(NSString *)bookID content:(NSString *)content {
    // 章节列表数组
//    ReadChapterListModel * model = [[ReadChapterListModel alloc] init];
    NSMutableArray * readChapterListModels = [[NSMutableArray alloc] init];
    
    // 正则
    NSString * parten = @"第[0-9一二三四五六七八九十百千]*[章回].*";
    
    //排版
    NSString * contentStr = [self contentTypesetting:content];
    
    NSRegularExpression * regularExpression = [[NSRegularExpression alloc] initWithPattern:parten options:(NSRegularExpressionCaseInsensitive) error:nil];
    // 搜索
    NSArray * resultsArray = [regularExpression matchesInString:contentStr options:(NSMatchingReportProgress) range:NSMakeRange(0, contentStr.length)];
    
    // 解析搜索结果
    if (resultsArray.count > 0) {
        // 记录最后一个Range
        NSRange lastRange = NSMakeRange(0, 0);
        
        //数量
        NSInteger count = resultsArray.count;
        
        // 记录 上一章 模型
        ReadChapterModel * lastReadChapterModel;
        
        // 有前言
        BOOL isPreface = YES;
        
        for (int i = 0; i < count; i++) {
            // 章节数量分析:
            // count + 1  = 搜索到的章节数量 + 最后一个章节,
            // 1 + count + 1  = 第一章前面的前言内容 + 搜索到的章节数量 + 最后一个章节
            NSLog(@"总章节数:%@  当前解析到:%@", @(count + 1), @(i + 1));
            
            NSRange range = NSMakeRange(0, 0);
            NSInteger location = 0;
            
            if (i < count) {
                range = [resultsArray[i] range];
                location = range.location;
            }
            
            // 创建章节内容模型
            ReadChapterModel * readChapterModel = [[ReadChapterModel alloc] init];
            readChapterModel.bookID = bookID;
            readChapterModel.id = [NSString stringWithFormat:@"%@", @(i + [NSNumber numberWithBool:isPreface].integerValue)];
            readChapterModel.priority = i - [NSNumber numberWithBool:!isPreface].integerValue;
            
            if (i == 0) {
                // 开始
                // 章节名
                readChapterModel.name = @"开始";
                // 内容
                readChapterModel.content = [contentStr substringWithRange:NSMakeRange(0, location)];
                
                // 记录
                lastRange = range;
                
                // 说不定没有内容 则不需要添加到列表
                if (readChapterModel.content.length == 0) {
                    isPreface = NO;
                    continue;
                }
            } else if (i == count) {
                // 结尾
                // 章节名
                readChapterModel.name = [contentStr substringWithRange:lastRange];
                
                // 内容
                readChapterModel.content = [contentStr substringWithRange:NSMakeRange(lastRange.location, lastRange.length - lastRange.location)];
            } else {
                // 中间章节
                // 章节名
                readChapterModel.name = [contentStr substringWithRange:lastRange];
                
                // 内容
                readChapterModel.content = [contentStr substringWithRange:NSMakeRange(lastRange.location, location - lastRange.location)];
            }
            
            // 清空章节名，保留纯内容
            readChapterModel.content = [NSString stringWithFormat:@"%@%@", KParagraphHeaderSpace, [readChapterModel.content stringByReplacingOccurrencesOfString:readChapterModel.name withString:@""]];
            
            // 分页
            [readChapterModel updateFont:NO];
            
            // 添加章节列表模型
            [readChapterListModels appendObject:[self getReadChapterListModel:readChapterModel]];
            
            // 设置上下章ID
            readChapterModel.lastChapterID = lastReadChapterModel.id;
            lastReadChapterModel.nextChapterID = readChapterModel.id;
            
            // 保存
            [readChapterModel save];
            [lastReadChapterModel save];
            
            // 记录
            lastRange = range;
            lastReadChapterModel = readChapterModel;
        }
    } else {
        // 创建章节内容模型
        ReadChapterModel * readChapterModel = [[ReadChapterModel alloc] init];
        // 书ID
        readChapterModel.bookID = bookID;
        // 章节ID
        readChapterModel.id = @"1";
        // 章节名
        readChapterModel.name = @"开始";
        // 优先级
        readChapterModel.priority = 0;
        // 内容
        readChapterModel.content = [NSString stringWithFormat:@"%@%@", KParagraphHeaderSpace, contentStr];
        // 分页
        [readChapterModel updateFont:NO];
        // 添加章节列表模型
        [readChapterListModels appendObject:[self getReadChapterListModel:readChapterModel]];
        // 保存
        [readChapterModel save];
    }
    
    return readChapterListModels;
}

+ (NSString *)contentTypesetting:(NSString *)content {
    // 替换单换行
    NSString * str = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    // 替换换行 以及 多个换行 为 换行加空格
    str = [str replacingCharacters:@"\\s*\\n+\\s*" template:[NSString stringWithFormat:@"\n%@", KParagraphHeaderSpace]];
    
    return str;
}

+ (ReadChapterListModel *)getReadChapterListModel:(ReadChapterModel *)readChapterModel {
    ReadChapterListModel * readChapterListModel = [[ReadChapterListModel alloc] init];
    readChapterListModel.bookID = readChapterModel.bookID;
    readChapterListModel.id = readChapterModel.id;
    readChapterListModel.name = readChapterModel.name;
    readChapterListModel.priority = readChapterModel.priority;
    
    return readChapterListModel;
}


/// 解码URL
+ (NSString *)encodeURL:(NSURL *)url {
    NSString * content = @"";
    
    // 检查URL是否有值
    if (url.absoluteString.length == 0) {
        return content;
    }
    
    // NSUTF8StringEncoding 解析
    content = [NSString stringWithContentsOfURL:url encoding:(NSUTF8StringEncoding) error:nil];
    
    // 进制编码解析
    if (content.length == 0) {
        content = [NSString stringWithContentsOfURL:url encoding:0x80000632 error:nil];
    }
    
    if (content.length == 0) {
        content = [NSString stringWithContentsOfURL:url encoding:0x80000631 error:nil];
    }
    
    return content;
}

+ (NSArray *)parserPageRange:(NSMutableAttributedString *)attrString rect:(CGRect)rect {
    NSMutableArray * rangeArray = [[NSMutableArray alloc] init];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
    
    CGPathRef path = CGPathCreateWithRect(rect, nil);
    
    CFRange range = CFRangeMake(0, 0);
    
    NSInteger rangeOffset = 0;
    
    do {
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(rangeOffset, 0), path, nil);
        range = CTFrameGetVisibleStringRange(frame);
        [rangeArray appendObject:[NSValue valueWithRange:NSMakeRange(rangeOffset, range.length)]];
        rangeOffset += range.length;
    } while (range.location + range.length < attrString.length);
    
    return rangeArray;
}

/// 获得 CTFrame
+ (CTFrameRef)getReadFrameRefWithAttrString:(NSMutableAttributedString *)attrString rect:(CGRect)rect {
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
    
    CGPathRef path = CGPathCreateWithRect(rect, nil);
    
    CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil);
    
    return frameRef;
}

@end
