//
//  ReadRecordModel.m
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/6.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "ReadRecordModel.h"

@implementation ReadRecordModel

+ (ReadRecordModel *)readRecordModelWithBookID:(NSString *)bookID isUpdateFont:(BOOL)isUpdateFont isSave:(BOOL)isSave {
    ReadRecordModel * model;
    
    if ([self IsExistReadRecordModelWithBookID:bookID]) {//存在
        model = [[Tools sharedManager] readKeyedUnarchiver:bookID fileName:[NSString stringWithFormat:@"%@ReadRecord", bookID]];
        if (isUpdateFont) {
            [model updateFont:isSave];
        }
    } else {
        model = [[ReadRecordModel alloc] init];
        model.bookID = bookID;
    }
    return model;
}

/// 是否存在阅读记录模型
+ (BOOL)IsExistReadRecordModelWithBookID:(NSString *)bookID {
    return [[Tools sharedManager] readKeyedIsExistArchiver:bookID fileName:[NSString stringWithFormat:@"%@ReadRecord", bookID]];
}


- (void)updateFont:(BOOL)isSave {
    if (self.readChapterModel) {
        NSInteger location = [self.readChapterModel locationWithPage:self.page];
        [self.readChapterModel updateFont:isSave];
        self.page = [self.readChapterModel pageWithLocation:location];
        [self.readChapterModel save];
        if (isSave) {
            [self save];
        }
    }
}

- (void)save {
    [[Tools sharedManager] readKeyedArchiver:self.bookID fileName:[NSString stringWithFormat:@"%@ReadRecord", self.bookID] object:self];
}

/// 修改阅读记录为指定章节ID 指定页码 (toPage: -1 为最后一页 也可以使用 ReadLastPageValue)
- (void)modifyWithChapterID:(NSString *)chapterID toPage:(NSInteger)toPage isUpdateFont:(BOOL)isUpdateFont isSave:(BOOL)isSave {
    if ([ReadChapterModel isExistReadChapterModelWithBookID:self.bookID chapterID:chapterID]) {
        self.readChapterModel = [ReadChapterModel readChapterModelWithBookID:self.bookID chapterID:chapterID isUpdateFont:isUpdateFont];
        NSInteger p = toPage == kReadLastPageValue ? self.readChapterModel.pageCount - 1 : toPage;
        self.page = p;
        if (isSave) {
            [self save];
        }
    }
}

/// 修改阅读记录为指定书签记录
- (void)modify:(ReadMarkModel *)readMarkModel isUpdateFont:(BOOL)isUpdateFont isSave:(BOOL)isSave {
    if ([ReadChapterModel isExistReadChapterModelWithBookID:self.bookID chapterID:readMarkModel.id]) {
        self.readChapterModel = [ReadChapterModel readChapterModelWithBookID:self.bookID chapterID:readMarkModel.id isUpdateFont:isUpdateFont];
        self.page = [self.readChapterModel pageWithLocation:readMarkModel.location.integerValue];
        if (isSave) {
            [self save];
        }
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.bookID = [aDecoder decodeObjectForKey:@"bookID"];
        self.readChapterModel = [aDecoder decodeObjectForKey:@"readChapterModel"];
        self.page = [aDecoder decodeIntegerForKey:@"page"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.bookID forKey:@"bookID"];
    [aCoder encodeObject:self.readChapterModel forKey:@"readChapterModel"];
    [aCoder encodeInteger:self.page forKey:@"page"];
}

@end
