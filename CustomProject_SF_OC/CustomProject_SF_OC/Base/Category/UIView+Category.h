//
//  UIView+Category.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/26.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)

@property(nonatomic, assign) CGFloat cornerRadius;
@property(copy, nonatomic) void(^tapAction)(UIView *v);

- (void)tapUpWithBlock:(void(^)(UIView *))aBlock;

@end
