//
//  ReadModel.h
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/5.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "BasicModel.h"
#import "ReadRecordModel.h"
#import "ReadMarkModel.h"

//@class ReadModel;

@interface ReadModel : NSObject <NSCoding>

@property (nonatomic, strong) NSString * bookID;

/// 阅读记录
@property (nonatomic, strong) ReadRecordModel * readRecordModel;

/// 章节列表数组（章节列表不包含章节内容, 它唯一的用处就是在阅读页面给用户查看章节列表）
@property (nonatomic, strong) NSArray * readChapterListModels;

@property (nonatomic, strong) NSNumber * isLocalBook;

+ (id)readModel:(NSString *)bookID;

//- (instancetype)initWith:(NSString *)bookID;

/** 是否存在阅读模型 */
+ (BOOL)IsExistReadModel:(NSString *)boolID;

/// 修改阅读记录为 指定章节ID 指定页码
- (void)modifyReadRecordModelWithChapterID:(NSString *)chapterID toPage:(NSInteger)page isUpdateFont:(BOOL)isUpdateFont isSave:(BOOL)isSave;

/// 修改阅读记录到书签模型
- (void)modifyReadRecordModel:(ReadMarkModel *)readMarkModel isUpdateFont:(BOOL)isUpdateFont isSave:(BOOL)isSave;

- (void)save;

@end
