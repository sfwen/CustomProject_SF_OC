//
//  UIFont+Adapter.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/8.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "UIFont+Adapter.h"
#import "NSObject+Method.h"

@implementation UIFont (Adapter)

+ (void)load {
    [self swizzleClassMethod:@selector(systemFontOfSize:) with:@selector(sf_systemFontOfSize:)];
    [self swizzleClassMethod:@selector(fontWithName:size:) with:@selector(sf_fontWithName:size:)];
}

+ (UIFont *)sf_systemFontOfSize:(CGFloat)pxSize {
    /*
     ps和pt转换
     
     px:相对长度单位。像素（Pixel）。（PS字体）
     pt:绝对长度单位。点（Point）。（iOS字体）
     UI标记图上给我们字体的大小一般都是像素点，如图
     
     */
    UIFont *font = [UIFont sf_systemFontOfSize:pxSize * [UIScreen mainScreen].bounds.size.width / SF_UIScreen];
    return font;
}

+ (UIFont *)sf_fontWithName:(NSString *)name size:(CGFloat)pxSize {
    UIFont * font = [UIFont sf_fontWithName:name size:pxSize * [UIScreen mainScreen].bounds.size.width / SF_UIScreen];
    return font;
}

@end
