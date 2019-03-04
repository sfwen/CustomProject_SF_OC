//
//  Tools.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/10.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "Tools.h"
#import "DeviceDataLibrery.h"
#import "BasicModel.h"

@implementation Tools

+ (instancetype)sharedManager {
    static Tools *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[Tools alloc] init];
    });
    return _manager;
}

- (BOOL)isNeatBang {
    
    return [DeviceDataLibrery sharedLibrery].iDevice == Global_iPhone_X || [DeviceDataLibrery sharedLibrery].iDevice == Chinese_iPhone_X || [DeviceDataLibrery sharedLibrery].iDevice == iPhone_XS || [DeviceDataLibrery sharedLibrery].iDevice == iPhone_XS_Max || [DeviceDataLibrery sharedLibrery].iDevice == iPhone_XR ? YES : NO;
}

- (NSString *)documentDirectory {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
}

/** 创建文件夹 如果存在则不创建 */
- (BOOL)creatFilePathWithFilePath:(NSString *)filePath {
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    // 文件夹是否存在
    if ([fileManager fileExistsAtPath:filePath]) {
        return YES;
    }
    
    NSError * error;
    [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        return NO;
    } else {
        return YES;
    }
}

/** 获取文件名称 */
- (NSString *)getFileName:(NSURL *)url {
    //不带后缀
    return [url.path.lastPathComponent stringByDeletingPathExtension];
}

/** 是否存在了改归档文件 */
- (BOOL)readKeyedIsExistArchiver:(NSString *)folderName fileName:(NSString *)fileName {
//    return NO;
    NSString * path = [NSString stringWithFormat:@"%@/%@/%@", [self documentDirectory], kReadFolderName, folderName];
    
    if (fileName != nil) {
        path = [path stringByAppendingString:[NSString stringWithFormat:@"/%@", fileName]];
    }
    
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

/** 解档阅读文件文件 */
- (id)readKeyedUnarchiver:(NSString *)folderName fileName:(NSString *)fileName {
    NSString * path = [NSString stringWithFormat:@"%@/%@/%@/%@", [self documentDirectory], kReadFolderName, folderName, fileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

/** 归档阅读文件文件 */
- (void)readKeyedArchiver:(NSString *)folderName fileName:(NSString *)fileName object:(id)object {
    NSString * path = [NSString stringWithFormat:@"%@/%@/%@", [self documentDirectory], kReadFolderName, folderName];
    if ([self creatFilePathWithFilePath:path]) {
        path = [path stringByAppendingString:[NSString stringWithFormat:@"/%@", fileName]];
        if ([object isKindOfClass:[BasicModel class]]) {
            [NSKeyedArchiver archiveRootObject:[object toJSONData] toFile:path];
        } else {
            [NSKeyedArchiver archiveRootObject:object toFile:path];
        }
    }
}

/** 获得文字属性字典 (isPaging: 为YES的时候只需要返回跟分页相关的属性即可 注意: 包含 UIColor , 小数点相关的...不可返回,因为无法进行比较) */
- (NSMutableDictionary *)readAttribute:(BOOL)isPaging isTitle:(BOOL)isTitle {
    // 段落配置
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    // 当前行间距(lineSpacing)的倍数(可根据字体大小变化修改倍数)
    paragraphStyle.lineHeightMultiple = 1.0;
    
    if (isTitle) {
        // 行间距
        paragraphStyle.lineSpacing = 0;
        
        // 段间距
        paragraphStyle.paragraphSpacing = 0;
        
        // 对齐
        paragraphStyle.alignment = NSTextAlignmentCenter;
    } else {
        // 行间距
        paragraphStyle.lineSpacing = kReadBookSpace_10;
        
        // 段间距
        paragraphStyle.paragraphSpacing = kReadBookSpace_5;
        
        // 对齐
        paragraphStyle.alignment = NSTextAlignmentJustified;
    }
    
    // 返回
    if (isPaging) {
        // 只需要传回跟分页有关的属性即可
        return @{NSFontAttributeName : APPFONT(18),
                 NSParagraphStyleAttributeName : paragraphStyle
                 }.mutableCopy;
    } else {
        return @{NSForegroundColorAttributeName : Color_51_51_51,
                 NSFontAttributeName : APPFONT(18),
                 NSParagraphStyleAttributeName : paragraphStyle
                 }.mutableCopy;
    }
}

@end
