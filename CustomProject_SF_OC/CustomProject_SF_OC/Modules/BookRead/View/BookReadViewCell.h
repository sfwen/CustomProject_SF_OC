//
//  BookReadViewCell.h
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/15.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "BasicCell.h"
#import "ReadView.h"

@interface BookReadViewCell : BasicCell

+ (BookReadViewCell *)cellWithTableView:(UITableView *)tableView;

/// 当前的显示的内容
@property (nonatomic, strong) NSMutableAttributedString * content;

/// 阅读View 显示使用
@property (nonatomic, strong) ReadView * readView;

@end
