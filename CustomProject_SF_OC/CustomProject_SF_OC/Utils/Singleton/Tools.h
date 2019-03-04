//
//  Tools.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/10.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import <Foundation/Foundation.h>

//主文件夹名称
static NSString * kReadFolderName = @"BookRead";

@interface Tools : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, assign) BOOL isNeatBang;

/** 沙河路径 */
- (NSString *)documentDirectory;

/** 创建文件夹 如果存在则不创建 */
- (BOOL)creatFilePathWithFilePath:(NSString *)filePath;

/** 获取文件名称 */
- (NSString *)getFileName:(NSURL *)url;

/** 是否存在了改归档文件 */
- (BOOL)readKeyedIsExistArchiver:(NSString *)folderName fileName:(NSString *)fileName;

/** 解档阅读文件文件 */
- (id)readKeyedUnarchiver:(NSString *)folderName fileName:(NSString *)fileName;

/** 归档阅读文件文件 */
- (void)readKeyedArchiver:(NSString *)folderName fileName:(NSString *)fileName object:(id)object;

/** 获得文字属性字典 (isPaging: 为YES的时候只需要返回跟分页相关的属性即可 注意: 包含 UIColor , 小数点相关的...不可返回,因为无法进行比较) */
- (NSMutableDictionary *)readAttribute:(BOOL)isPaging isTitle:(BOOL)isTitle;

@end
