//
//  BasicCell.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/11.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicCell : UITableViewCell

- (void)configCellData:(id)model;
/** 设置字体 */
- (NSAttributedString *)getAttributeString:(CGFloat)fontSize;

@end
