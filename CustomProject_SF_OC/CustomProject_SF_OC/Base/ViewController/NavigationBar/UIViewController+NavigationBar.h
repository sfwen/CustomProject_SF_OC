//
//  UIViewController+NavigationBar.h
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/4.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationBar)

@property (nonatomic, assign) IBInspectable BOOL sf_blackBarStyle;
@property (nonatomic, assign) UIBarStyle sf_barStyle;
@property (nonatomic, strong) IBInspectable UIColor *sf_barTintColor;
@property (nonatomic, strong) IBInspectable UIImage *sf_barImage;
@property (nonatomic, strong) IBInspectable UIColor *sf_tintColor;
@property (nonatomic, strong) NSDictionary *sf_titleTextAttributes;

@property (nonatomic, assign) IBInspectable float sf_barAlpha;
@property (nonatomic, assign) IBInspectable BOOL sf_barHidden;
@property (nonatomic, assign) IBInspectable BOOL sf_barShadowHidden;
@property (nonatomic, assign) IBInspectable BOOL sf_backInteractive;
@property (nonatomic, assign) IBInspectable BOOL sf_swipeBackEnabled;
@property (nonatomic, assign) IBInspectable BOOL sf_clickBackEnabled;

// computed
@property (nonatomic, assign, readonly) float sf_computedBarShadowAlpha;
@property (nonatomic, strong, readonly) UIColor *sf_computedBarTintColor;
@property (nonatomic, strong, readonly) UIImage *sf_computedBarImage;

- (void)sf_setNeedsUpdateNavigationBar;
- (void)sf_setNeedsUpdateNavigationBarAlpha;
- (void)sf_setNeedsUpdateNavigationBarColorOrImage;
- (void)sf_setNeedsUpdateNavigationBarShadowAlpha;

@end
