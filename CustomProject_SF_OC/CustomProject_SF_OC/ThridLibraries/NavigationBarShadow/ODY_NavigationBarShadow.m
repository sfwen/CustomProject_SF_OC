//
//  ODY_NavigationBarShadow.m
//  导航栏渐变
//
//  Created by MuHao_NB on 16/8/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ODY_NavigationBarShadow.h"

#define WHITE_COLOR [UIColor whiteColor]
static CGFloat kDefaultAlpha = 1.0;

@interface ODY_NavigationBarShadow ()
/**
 *  记录上次导航栏透明度
 */
@property (nonatomic, assign) float                 myalpha;
/**
 *  是否跳转
 */
@property (nonatomic, assign) BOOL                  isRouter;
/**
 *  颜色色值
 */
@property (nonatomic, assign) NSInteger             valueRGB;

@end

@implementation ODY_NavigationBarShadow
/**
 *  导航栏的颜色//FIGURE_COLOR
 */
- (void)shadowNavigationBar:(UIViewController *)viewController colorWithRGB:(NSInteger)valueRGB {
    _valueRGB = valueRGB;
    [viewController.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[self colorWithRed:0 geen:0 blue:0 alpha:0.5] height:1.0f] forBarMetrics:UIBarMetricsDefault];
    [viewController.navigationController.navigationBar setShadowImage:[self imageWithBgColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0] height:0.5f]];
}

- (UIImage *)imageWithBgColor:(UIColor *)color height:(CGFloat)h {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, h);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)enterWith:(UIViewController *)viewController {
    if (self.firstAppear) {
        self.firstAppear = NO;
        [viewController.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[self colorWithRed:0 geen:0 blue:0 alpha:0.0] height:1.0f] forBarMetrics:UIBarMetricsDefault];
    } else {
        if (self.myalpha >= 1.0) {
            self.myalpha = kDefaultAlpha;
        }
        _isRouter = NO;
        [viewController.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[self colorWithRGB:_valueRGB alpha:_myalpha] height:1.0f] forBarMetrics:UIBarMetricsDefault];
        [viewController.navigationController.navigationBar setShadowImage:[self imageWithBgColor:[self colorWithRed:217 geen:217 blue:217 alpha:_myalpha] height:0.5f]];
    }
}

- (void)leaveWith:(UIViewController *)viewController {
    _isRouter = YES;
    [viewController.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:WHITE_COLOR height:1.0f] forBarMetrics:UIBarMetricsDefault];
    viewController.navigationController.navigationBar.barTintColor = WHITE_COLOR;
    [viewController.navigationController.navigationBar setShadowImage:nil];
    viewController.navigationController.navigationBar.translucent = YES;
}

- (void)scrollToChangeShadowValueWith:(UIViewController *)viewController scrollView:(UIScrollView *)scrollView {
    if (_isRouter == NO) {
        self.myalpha = scrollView.contentOffset.y / 300;
        if (self.myalpha >= 1.0) {
            self.myalpha = kDefaultAlpha;
        }
        
        [viewController.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[self colorWithRGB:_valueRGB alpha:_myalpha] height:1.0f] forBarMetrics:UIBarMetricsDefault];
        if (self.myalpha == 0) {
            [viewController.navigationController.navigationBar setShadowImage:[self imageWithBgColor:[self colorWithRed:217 geen:217 blue:217 alpha:0] height:0.5f]];
        } else {
            [viewController.navigationController.navigationBar setShadowImage:[self imageWithBgColor:[self colorWithRed:217 geen:217 blue:217 alpha:_myalpha] height:0.5f]];
        }
    }
//    viewController.navigationController.navigationBar.alpha = (64 + scrollView.contentOffset.y) / 64;
}

- (UIColor *)colorWithRGB:(NSUInteger)aRGB alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((float)((aRGB & 0xFF0000) >> 16))/255.0 green:((float)((aRGB & 0xFF00) >> 8))/255.0 blue:((float)(aRGB & 0xFF))/255.0 alpha:alpha];
}

- (UIColor *)colorWithRed:(NSInteger)r geen:(NSInteger)g blue:(NSInteger)b alpha:(CGFloat)a {
    return [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)];
}

@end
