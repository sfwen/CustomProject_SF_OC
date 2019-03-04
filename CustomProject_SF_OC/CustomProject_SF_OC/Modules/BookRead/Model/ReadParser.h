//
//  ReadParser.h
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/5.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadModel.h"

@interface ReadParser : NSObject

/**
 主线程解析本地URL

 @param url URL
 @return ReadModel
 */
+ (ReadModel *)mainThreadParserLocalURL:(NSURL *)url;

+ (NSArray *)parserPageRange:(NSMutableAttributedString *)attrString rect:(CGRect)rect;

/// 获得 CTFrame
+ (CTFrameRef)getReadFrameRefWithAttrString:(NSMutableAttributedString *)attrString rect:(CGRect)rect;

@end
