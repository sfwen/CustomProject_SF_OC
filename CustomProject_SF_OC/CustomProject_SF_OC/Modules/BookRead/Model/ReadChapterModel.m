//
//  ReadChapterModel.m
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/6.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "ReadChapterModel.h"
#import "ReadConfigure.h"
#import "ReadParser.h"

@interface ReadChapterModel ()

@end

@implementation ReadChapterModel

//通过书ID 章节ID 获得阅读章节 没有则创建传出
+ (id)readChapterModelWithBookID:(NSString *)bookID chapterID:(NSString *)chapterID isUpdateFont:(BOOL)isUpdateFont {
    ReadChapterModel * model;
    if ([self isExistReadChapterModelWithBookID:bookID chapterID:chapterID]) {
        model = [[Tools sharedManager] readKeyedUnarchiver:bookID fileName:chapterID];
        if (isUpdateFont) {
            [model updateFont:YES];
        }
    } else {
        model = [[ReadChapterModel alloc] init];
        model.bookID = bookID;
        model.id = chapterID;
    }
    
    return model;
}

- (void)updateFont:(BOOL)isSave {
    NSMutableDictionary * nameAttribute = [[Tools sharedManager] readAttribute:YES isTitle:YES];
    NSMutableDictionary * readAttribute = [[Tools sharedManager] readAttribute:YES isTitle:NO];
    
    if (![self.nameAttribute isEqual:nameAttribute] || ![self.readAttribute isEqual:readAttribute]) {
        self.nameAttribute = nameAttribute;
        self.readAttribute = readAttribute;
        
        self.rangeArray = [ReadParser parserPageRange:[self fullContentAttrString] rect:CGRectMake(0, 0, ScreenWidth - 2 * kReadBookSpace_15, ScreenHeight - 2 * (kReadBookSpace_25 + kReadBookSpace_10))];
        self.pageCount = self.rangeArray.count;
        if (isSave) {
            [self save];
        }
    }
}

- (NSMutableAttributedString *)fullContentAttrString {
    NSMutableDictionary * nameAttribute = [[Tools sharedManager] readAttribute:YES isTitle:YES];
    NSMutableDictionary * readAttribute = [[Tools sharedManager] readAttribute:YES isTitle:NO];
    
    NSMutableAttributedString * nameString = [[NSMutableAttributedString alloc] initWithString:self.fullName attributes:nameAttribute];
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:self.content attributes:readAttribute];
    
    [nameString appendAttributedString:attrString];
    return nameString;
}

/// 通过 Page 获得 Location
- (NSInteger)locationWithPage:(NSInteger)page {
    if (self.rangeArray.count < page) {
        NSRange range = [self.rangeArray[page] range];
        return range.location;
    }
    return 0;
}

/// 通过 Location 获得 Page
- (NSInteger)pageWithLocation:(NSInteger)location {
    NSInteger count = self.rangeArray.count;
    for (int i = 0; i < count; i++) {
        NSValue * value = [self.rangeArray objectAtIndex:i];
        NSRange range = [value rangeValue];
        if (location < range.length + range.location) {
            return i;
        }
    }
    return 0;
}

/** 保存 */
- (void)save {
    [[Tools sharedManager] readKeyedArchiver:self.bookID fileName:self.id object:self];
}

/** 是否存在章节内容模型 */
+ (BOOL)isExistReadChapterModelWithBookID:(NSString *)bookID chapterID:(NSString *)chapterID {
    return [[Tools sharedManager] readKeyedIsExistArchiver:bookID fileName:chapterID];
}

/// 通过 Page 获得字符串
- (NSMutableAttributedString *)stringAttrWithPage:(NSInteger)page {
    NSValue * value = [self.rangeArray objectAtIndex:page];
    NSRange range = [value rangeValue];
    NSString * content = [self.fullContent substringWithRange:range];
    NSMutableAttributedString * contentAttr = [[NSMutableAttributedString alloc] init];
    if (page == 0) {
        content = [content stringByReplacingOccurrencesOfString:self.fullName withString:@""];
        NSMutableDictionary * nameAttribute = [[Tools sharedManager] readAttribute:YES isTitle:YES];
        NSMutableAttributedString * nameString = [[NSMutableAttributedString alloc] initWithString:self.fullName attributes:nameAttribute];
        contentAttr = nameString;
    }
    
    NSMutableDictionary * readAttribute = [[Tools sharedManager] readAttribute:YES isTitle:NO];
    [contentAttr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:content attributes:readAttribute]];
    
    return contentAttr;
}

- (NSString *)fullContent {
    return [NSString stringWithFormat:@"%@%@", self.fullName, self.content];
}

- (NSString *)fullName {
    return [NSString stringWithFormat:@"\n%@\n\n", self.name];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.bookID = [aDecoder decodeObjectForKey:@"bookID"];
        self.id = [aDecoder decodeObjectForKey:@"id"];
        self.lastChapterID = [aDecoder decodeObjectForKey:@"lastChapterID"];
        self.nextChapterID = [aDecoder decodeObjectForKey:@"nextChapterID"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.priority = [aDecoder decodeIntegerForKey:@"priority"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.pageCount = [aDecoder decodeIntegerForKey:@"pageCount"];
        self.rangeArray = [aDecoder decodeObjectForKey:@"rangeArray"];
        self.readAttribute = [aDecoder decodeObjectForKey:@"readAttribute"];
        self.nameAttribute = [aDecoder decodeObjectForKey:@"nameAttribute"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.bookID forKey:@"bookID"];
    [aCoder encodeObject:self.id forKey:@"id"];
    [aCoder encodeObject:self.lastChapterID forKey:@"lastChapterID"];
    [aCoder encodeObject:self.nextChapterID forKey:@"nextChapterID"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.readAttribute forKey:@"readAttribute"];
    [aCoder encodeObject:self.nameAttribute forKey:@"nameAttribute"];
    [aCoder encodeObject:self.rangeArray forKey:@"rangeArray"];
    [aCoder encodeInteger:self.pageCount forKey:@"pageCount"];
    [aCoder encodeInteger:self.priority forKey:@"priority"];
}

@end
