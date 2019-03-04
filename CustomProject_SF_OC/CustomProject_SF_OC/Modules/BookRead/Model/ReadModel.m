//
//  ReadModel.m
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/5.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "ReadModel.h"

@implementation ReadModel

+ (id)readModel:(NSString *)bookID {
    ReadModel * model;
    if ([self IsExistReadModel:bookID]) {
        model = [[Tools sharedManager] readKeyedUnarchiver:bookID fileName:bookID];
    } else {
        model = [[ReadModel alloc] init];
        model.bookID = bookID;
    }
    
    //阅读记录  刷新字体 以防在别的小说中修改了字体
    model.readRecordModel = [ReadRecordModel readRecordModelWithBookID:bookID isUpdateFont:YES isSave:YES];
    
    return model;
}

//- (instancetype)initWith:(NSString *)bookID {
//    self = [super init];
//    if (self) {
//        if ([self IsExistReadModel:bookID]) {
//            self = [[Tools sharedManager] readKeyedUnarchiver:bookID fileName:bookID];
//        } else {
//            self.bookID = bookID;
//        }
//        
//        //阅读记录  刷新字体 以防在别的小说中修改了字体
//        self.readRecordModel = [ReadRecordModel readRecordModelWithBookID:bookID isUpdateFont:YES isSave:YES];
//    }
//    
//    return self;
//}

+ (BOOL)IsExistReadModel:(NSString *)boolID {
    return [[Tools sharedManager] readKeyedIsExistArchiver:boolID fileName:boolID];
}

/// 修改阅读记录为 指定章节ID 指定页码
- (void)modifyReadRecordModelWithChapterID:(NSString *)chapterID toPage:(NSInteger)page isUpdateFont:(BOOL)isUpdateFont isSave:(BOOL)isSave {
    [self.readRecordModel modifyWithChapterID:chapterID toPage:page isUpdateFont:isUpdateFont isSave:isSave];
}

/// 修改阅读记录到书签模型
- (void)modifyReadRecordModel:(ReadMarkModel *)readMarkModel isUpdateFont:(BOOL)isUpdateFont isSave:(BOOL)isSave {
    [self.readRecordModel modify:readMarkModel isUpdateFont:isUpdateFont isSave:isSave];
}

- (void)save {
    // 阅读模型
    [[Tools sharedManager] readKeyedArchiver:self.bookID fileName:self.bookID object:self];
    
    [self.readRecordModel save];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.bookID = [aDecoder decodeObjectForKey:@"bookID"];
        self.isLocalBook = [aDecoder decodeObjectForKey:@"isLocalBook"];
        self.readChapterListModels = [aDecoder decodeObjectForKey:@"readChapterListModels"];
//        self.readm
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.bookID forKey:@"bookID"];
    [aCoder encodeObject:self.isLocalBook forKey:@"isLocalBook"];
    [aCoder encodeObject:self.readChapterListModels forKey:@"readChapterListModels"];
}

@end
