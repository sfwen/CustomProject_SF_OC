//
//  UIImage+Category.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/6.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)

+ (UIImage *)scaleImage:(UIImage *)image;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
