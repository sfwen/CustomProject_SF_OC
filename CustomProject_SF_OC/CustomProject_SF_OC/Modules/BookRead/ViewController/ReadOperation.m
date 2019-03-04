//
//  ReadOperation.m
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/12.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "ReadOperation.h"

@interface ReadOperation ()

@property (nonatomic, strong) BookReadDetailViewController * vc;

@end

@implementation ReadOperation

- (instancetype)initWithVc:(BookReadDetailViewController *)vc {
    self = [super init];
    if (self) {
        self.vc = vc;
    }
    return self;
}

#pragma mark - 获取阅读控制器 BookReadViewController
/// 获取阅读View控制器
- (BookReadViewController *)getReadViewController:(ReadRecordModel *)readRecordModel {
    if (readRecordModel) {
        BookReadViewController * vc = [[BookReadViewController alloc] init];
        vc.readRecordModel = readRecordModel;
        vc.readController = self.vc;
        return vc;
    }
    return nil;
}

/// 获取当前阅读记录的阅读View控制器
- (BookReadViewController *)getCurrentReadViewController:(BOOL)isUpdateFont isSave:(BOOL)isSave {
    if (isUpdateFont) {
        [self.vc.readModel.readRecordModel updateFont:YES];
    }

    if (isSave) {
        [self readRecordUpdate:self.vc.readModel.readRecordModel isSave:YES];
    }
    
    return [self getReadViewController:self.vc.readModel.readRecordModel];
}

/// 获取上一页控制器
- (BookReadViewController *)getAboveReadViewController {
    // 没有阅读模型
    if (self.vc.readModel == nil || !self.vc.readModel.readRecordModel.isRecord) {
        return nil;
    }
    
    // 阅读记录
    ReadRecordModel * readRecordModel;
    
    // 判断
    if (self.vc.readModel.isLocalBook.boolValue) { // 本地小说
        // 获得阅读记录
        readRecordModel = self.vc.readModel.readRecordModel.copy;
        
        // 章节ID
        NSInteger articleID = self.vc.readModel.readRecordModel.readChapterModel.id.integerValue;
        
        // 页码
        NSInteger page = self.vc.readModel.readRecordModel.page;
        
        // 到头了
        if (articleID == 1 && page == 0) {
            return nil;
        }
        
        if (page == 0) { // 这一章到头了
            [readRecordModel modifyWithChapterID:[NSString stringWithFormat:@"%@", @(articleID - 1)] toPage:kReadLastPageValue isUpdateFont:YES isSave:NO];
        } else { // 没到头
            readRecordModel.page = page - 1;
        }
    } else { // 网络小说
        /*
         网络小说操作提示:
         
         1. 获得阅读记录
         
         2. 获得当前章节ID
         
         3. 获得当前阅读章节 读到的页码
         
         4. 判断是否为这一章最后一页
         
         5. 1). 判断不是第一页则 page - 1 继续翻页
         2). 如果是第一页则判断上一章的章节ID是否有值,没值就是当前没有跟多章节（连载中）或者 全书完, 有值则判断是否存在缓存文件.
         有缓存文件则拿出使用更新阅读记录, 没值则请求服务器获取，请求回来之后可动画展示出来
         
         提示：如果是请求回来之后并更新了阅读记录 可使用 GetCurrentReadViewController() 获得当前阅读记录的控制器 进行展示
         */
        readRecordModel = nil;
    }
    return [self getReadViewController:readRecordModel];
}

/// 获得下一页控制器
- (BookReadViewController *)getBelowReadViewController {
    // 没有阅读模型
    if (self.vc.readModel == nil || !self.vc.readModel.readRecordModel.isRecord) {
        return nil;
    }
    
    // 阅读记录
    ReadRecordModel * readRecordModel;
    
    // 判断
    if (self.vc.readModel.isLocalBook.boolValue) { // 本地小说
        // 获得阅读记录
        readRecordModel = self.vc.readModel.readRecordModel.copy;
        
        // 章节ID
        NSInteger articleID = self.vc.readModel.readRecordModel.readChapterModel.id.integerValue;
        
        // 页码
        NSInteger page = self.vc.readModel.readRecordModel.page;
        
        // 最后一页
        NSInteger lastPage = self.vc.readModel.readRecordModel.readChapterModel.pageCount - 1;
        
        // 到头了
        if (articleID == self.vc.readModel.readChapterListModels.count && page == lastPage) {
            return nil;
        }
        
        if (page == lastPage) { // 这一章到头了
            [readRecordModel modifyWithChapterID:[NSString stringWithFormat:@"%@", @(articleID + 1)] toPage:kReadLastPageValue isUpdateFont:YES isSave:NO];
        } else { // 没到头
            readRecordModel.page = page + 1;
        }
    } else { // 网络小说
        /*
         网络小说操作提示:
         
         1. 获得阅读记录
         
         2. 获得当前章节ID
         
         3. 获得当前阅读章节 读到的页码
         
         4. 判断是否为这一章最后一页
         
         5. 1). 判断不是第一页则 page - 1 继续翻页
         2). 如果是第一页则判断上一章的章节ID是否有值,没值就是当前没有跟多章节（连载中）或者 全书完, 有值则判断是否存在缓存文件.
         有缓存文件则拿出使用更新阅读记录, 没值则请求服务器获取，请求回来之后可动画展示出来
         
         提示：如果是请求回来之后并更新了阅读记录 可使用 GetCurrentReadViewController() 获得当前阅读记录的控制器 进行展示
         */
        readRecordModel = nil;
    }
    return [self getReadViewController:readRecordModel];
}

/// 更新记录
- (void)readRecordUpdateWithReadViewController:(BookReadViewController *)readViewController isSave:(BOOL)isSave {
    [self readRecordUpdate:readViewController.readRecordModel isSave:isSave];
}

/// 更新记录
- (void)readRecordUpdate:(ReadRecordModel *)readRecordModel isSave:(BOOL)isSave {
    if (readRecordModel) {
        self.vc.readModel.readRecordModel = readRecordModel;
        
        if (isSave) {
            [self.vc.readModel.readRecordModel save];
            
            // 更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                // 进度条数据初始化
            });
        }
    }
}

@end
