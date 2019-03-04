//
//  BookReadViewController.h
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/12.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "BasicViewController.h"
#import "ReadRecordModel.h"
#import "BookReadDetailViewController.h"

@interface BookReadViewController : BasicViewController

/// 临时阅读记录
@property (nonatomic, strong) ReadRecordModel * readRecordModel;

/// 阅读控制器
@property (nonatomic, strong) BookReadDetailViewController * readController;

@end
