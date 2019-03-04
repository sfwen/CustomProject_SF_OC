//
//  BookReadDetailViewController.h
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/10.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "BasicViewController.h"
#import "ReadModel.h"

@class ReadOperation;

@interface BookReadDetailViewController : BasicViewController

@property (nonatomic, strong) ReadModel * readModel;
/// 阅读操作对象
@property (nonatomic, strong) ReadOperation * readOperation;

@end
