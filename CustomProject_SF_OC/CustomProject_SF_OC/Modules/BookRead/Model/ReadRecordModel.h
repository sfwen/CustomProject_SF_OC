//
//  ReadRecordModel.h
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/6.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "BasicModel.h"
#import "ReadChapterModel.h"
#import "ReadMarkModel.h"

static NSInteger kReadLastPageValue = -1;

@interface ReadRecordModel : NSObject <NSCoding>

/** 是否存在记录 */
@property (nonatomic, assign) BOOL isRecord;
/** 小说ID */
@property (nonatomic, strong) NSString * bookID;

/** 当前阅读到的章节模型 */
@property (nonatomic, strong) ReadChapterModel * readChapterModel;



/** 当前章节阅读到的页码(如果有云端记录或者多端使用阅读记录需求 可以记录location 通过location转成页码进行使用) */
@property (nonatomic, assign) NSInteger page;

/// 通过书ID 获得阅读记录模型 没有则进行创建传出
+ (ReadRecordModel *)readRecordModelWithBookID:(NSString *)bookID isUpdateFont:(BOOL)isUpdateFont isSave:(BOOL)isSave;
/// 修改阅读记录为指定章节ID 指定页码 (toPage: -1 为最后一页 也可以使用 ReadLastPageValue)
- (void)modifyWithChapterID:(NSString *)chapterID toPage:(NSInteger)toPage isUpdateFont:(BOOL)isUpdateFont isSave:(BOOL)isSave;
/// 修改阅读记录为指定书签记录
- (void)modify:(ReadMarkModel *)readMarkModel isUpdateFont:(BOOL)isUpdateFont isSave:(BOOL)isSave;

- (void)save;

- (void)updateFont:(BOOL)isSave;

@end
