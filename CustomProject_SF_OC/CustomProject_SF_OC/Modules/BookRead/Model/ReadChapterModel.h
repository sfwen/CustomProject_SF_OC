//
//  ReadChapterModel.h
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/6.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "BasicModel.h"

@interface ReadChapterModel : NSObject <NSCoding>

/** 小说ID */
@property (nonatomic, strong) NSString * bookID;
/** 章节ID */
@property (nonatomic, strong) NSString * id;

/** 上一章 章节ID */
@property (nonatomic, strong) NSString * lastChapterID;
/** 下一章 章节ID */
@property (nonatomic, strong) NSString * nextChapterID;

/** 章节名称 */
@property (nonatomic, strong) NSString * name;

/** 完整章节名称 */
@property (nonatomic, strong) NSString * fullName;

/** 内容 */
@property (nonatomic, strong) NSString * content;

/** 优先级（一般章节段落都带有排序的优先级  从0开始） */
@property (nonatomic, assign) NSInteger priority;
/** 本章有多少页 */
@property (nonatomic, assign) NSInteger pageCount;
/** 每一页的Range数组 */
@property (nonatomic, strong) NSArray  * rangeArray;

@property (nonatomic, strong) NSString * fullContent;

#pragma mark - 记录该章使用的字体属性
@property (nonatomic, strong) NSMutableDictionary * readAttribute;
@property (nonatomic, strong) NSMutableDictionary * nameAttribute;
//通过书ID 章节ID 获得阅读章节 没有则创建传出
+ (id)readChapterModelWithBookID:(NSString *)bookID chapterID:(NSString *)chapterID isUpdateFont:(BOOL)isUpdateFont;

/** 更新字体 */
- (void)updateFont:(BOOL)isSave;

/// 通过 Page 获得 Location
- (NSInteger)locationWithPage:(NSInteger)page;
/// 通过 Location 获得 Page
- (NSInteger)pageWithLocation:(NSInteger)location;
/** 保存 */
- (void)save;

/** 是否存在章节内容模型 */
+ (BOOL)isExistReadChapterModelWithBookID:(NSString *)bookID chapterID:(NSString *)chapterID;

- (NSMutableAttributedString *)stringAttrWithPage:(NSInteger)page;

@end
