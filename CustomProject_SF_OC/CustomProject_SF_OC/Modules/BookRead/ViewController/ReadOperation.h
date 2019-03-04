//
//  ReadOperation.h
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/12.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookReadDetailViewController.h"
#import "BookReadViewController.h"

@interface ReadOperation : NSObject

- (instancetype)initWithVc:(BookReadDetailViewController *)vc;

/// 获取当前阅读记录的阅读View控制器
- (BookReadViewController *)getCurrentReadViewController:(BOOL)isUpdateFont isSave:(BOOL)isSave;

/// 获取上一页控制器
- (BookReadViewController *)getAboveReadViewController;
/// 获得下一页控制器
- (BookReadViewController *)getBelowReadViewController;

- (void)readRecordUpdateWithReadViewController:(BookReadViewController *)readViewController isSave:(BOOL)isSave;
- (void)readRecordUpdate:(ReadRecordModel *)readRecordModel isSave:(BOOL)isSave;

@end
