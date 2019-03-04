//
//  UIViewController+NavigationBar.m
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/4.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "UIViewController+NavigationBar.h"
#import <objc/runtime.h>

@implementation UIViewController (NavigationBar)

- (BOOL)sf_blackBarStyle{
    return self.sf_barStyle == UIBarStyleBlack;
}

- (void)setSf_blackBarStyle:(BOOL)sf_blackBarStyle{
    self.sf_barStyle = sf_blackBarStyle ? UIBarStyleBlack : UIBarStyleDefault;
}

- (UIBarStyle)sf_barStyle {
    id obj = objc_getAssociatedObject(self, _cmd);
    if (obj) {
        return [obj integerValue];
    }
    return [UINavigationBar appearance].barStyle;
}

- (void)setSf_barStyle:(UIBarStyle)hbd_barStyle {
    objc_setAssociatedObject(self, @selector(sf_barStyle), @(hbd_barStyle), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIColor *)sf_barTintColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSf_barTintColor:(UIColor *)tintColor {
    objc_setAssociatedObject(self, @selector(sf_barTintColor), tintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)sf_barImage {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSf_barImage:(UIImage *)image {
    objc_setAssociatedObject(self, @selector(sf_barImage), image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)sf_tintColor {
    id obj = objc_getAssociatedObject(self, _cmd);
    return obj ?: [UINavigationBar appearance].tintColor;
}

- (void)setSf_tintColor:(UIColor *)tintColor {
    objc_setAssociatedObject(self, @selector(sf_tintColor), tintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)sf_titleTextAttributes {
    id obj = objc_getAssociatedObject(self, _cmd);
    return obj ?: [UINavigationBar appearance].titleTextAttributes;
}

- (void)setSf_titleTextAttributes:(NSDictionary *)attributes {
    objc_setAssociatedObject(self, @selector(sf_titleTextAttributes), attributes, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (float)sf_barAlpha {
    id obj = objc_getAssociatedObject(self, _cmd);
    if (self.sf_barHidden) {
        return 0;
    }
    return obj ? [obj floatValue] : 1.0f;
}

- (void)setSf_barAlpha:(float)alpha {
    objc_setAssociatedObject(self, @selector(sf_barAlpha), @(alpha), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)sf_barHidden {
    id obj = objc_getAssociatedObject(self, _cmd);
    return obj ? [obj boolValue] : NO;
}

- (void)setSf_barHidden:(BOOL)hidden {
    if (hidden) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
        self.navigationItem.titleView = [UIView new];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.titleView = nil;
    }
    objc_setAssociatedObject(self, @selector(sf_barHidden), @(hidden), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)sf_barShadowHidden {
    id obj = objc_getAssociatedObject(self, _cmd);
    return  self.sf_barHidden || obj ? [obj boolValue] : NO;
}

- (void)setSf_barShadowHidden:(BOOL)hidden {
    objc_setAssociatedObject(self, @selector(sf_barShadowHidden), @(hidden), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)sf_backInteractive {
    id obj = objc_getAssociatedObject(self, _cmd);
    return obj ? [obj boolValue] : YES;
}

-(void)setSf_backInteractive:(BOOL)interactive {
    objc_setAssociatedObject(self, @selector(sf_backInteractive), @(interactive), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)sf_swipeBackEnabled {
    id obj = objc_getAssociatedObject(self, _cmd);
    return obj ? [obj boolValue] : YES;
}

- (void)setSf_swipeBackEnabled:(BOOL)enabled {
    objc_setAssociatedObject(self, @selector(sf_swipeBackEnabled), @(enabled), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)sf_clickBackEnabled {
    id obj = objc_getAssociatedObject(self, _cmd);
    return obj ? [obj boolValue] : YES;
}

- (void)setSf_clickBackEnabled:(BOOL)enabled {
    objc_setAssociatedObject(self, @selector(sf_clickBackEnabled), @(enabled), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (float)sf_computedBarShadowAlpha {
    return  self.sf_barShadowHidden ? 0 : self.sf_barAlpha;
}

- (UIImage *)sf_computedBarImage {
    UIImage *image = self.sf_barImage;
    if (!image) {
        if (self.sf_barTintColor) {
            return nil;
        }
        return [[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault];
    }
    return image;
}

- (UIColor *)sf_computedBarTintColor {
    if (self.sf_barImage) {
        return nil;
    }
    UIColor *color = self.sf_barTintColor;
    if (!color) {
        if ([[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault]) {
            return nil;
        }
        if ([UINavigationBar appearance].barTintColor) {
            color = [UINavigationBar appearance].barTintColor;
        } else {
            color = [UINavigationBar appearance].barStyle == UIBarStyleDefault ? [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:0.8]: [UIColor colorWithRed:28/255.0 green:28/255.0 blue:28/255.0 alpha:0.729];
        }
    }
    return color;
}

- (void)sf_setNeedsUpdateNavigationBar {
    if (self.navigationController && [self.navigationController isKindOfClass:[BasicNavigationController class]]) {
        BasicNavigationController *nav = (BasicNavigationController *)self.navigationController;
        [nav updateNavigationBarForViewController:self];
    }
}

-(void)sf_setNeedsUpdateNavigationBarAlpha {
    if (self.navigationController && [self.navigationController isKindOfClass:[BasicNavigationController class]]) {
        BasicNavigationController *nav = (BasicNavigationController *)self.navigationController;
        [nav updateNavigationBarAlphaForViewController:self];
    }
}

- (void)sf_setNeedsUpdateNavigationBarColorOrImage {
    if (self.navigationController && [self.navigationController isKindOfClass:[BasicNavigationController class]]) {
        BasicNavigationController *nav = (BasicNavigationController *)self.navigationController;
        [nav updateNavigationBarColorOrImageForViewController:self];
    }
}

- (void)sf_setNeedsUpdateNavigationBarShadowAlpha {
    if (self.navigationController && [self.navigationController isKindOfClass:[BasicNavigationController class]]) {
        BasicNavigationController *nav = (BasicNavigationController *)self.navigationController;
        [nav updateNavigationBarShadowImageIAlphaForViewController:self];
    }
}

@end
