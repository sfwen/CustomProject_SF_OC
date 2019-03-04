//
//  ODY_NavigationBarShadow.h
//  导航栏渐变
//
//  Created by MuHao_NB on 16/8/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface ODY_NavigationBarShadow : NSObject
@property (assign, nonatomic) BOOL firstAppear;
/**
 *  导航栏渐变的调用方法 （此方法放在viewWillAppear中调用）
 *
 *  @param viewController 传入当前视图控制器 用于获取导航控制器
 *  @param valueRGB       导航栏颜色16进制色值
 */
- (void)shadowNavigationBar:(UIViewController *)viewController
               colorWithRGB:(NSInteger)valueRGB;
/**
 *  在viewWillAppear中调用，保证进栈后再返回时透明度记录之前的 alpha 值
 *
 *  @param viewController 当前视图控制器
 */
- (void)enterWith:(UIViewController *)viewController;
/**
 *  在viewWillDisappear中调用，保证控制器进出栈时，下一栈的导航栏透明度不会改变
 *
 *  @param viewController 当前视图控制器
 */
- (void)leaveWith:(UIViewController *)viewController;
/**
 *  滑动列表时触发 根据滑动的偏移量计算导航栏透明度改变
 *
 *  @param viewController 当前视图控制器
 *  @param scrollView     滑动的列表或者视图
 */
- (void)scrollToChangeShadowValueWith:(UIViewController *)viewController
                           scrollView:(UIScrollView *)scrollView;
@end
