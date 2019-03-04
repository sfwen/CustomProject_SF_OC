//
//  BasicNavigationController.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/6.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+NavigationBar.h"

@interface BasicNavigationController : UINavigationController

- (void)updateNavigationBarForViewController:(UIViewController *)vc;
- (void)updateNavigationBarAlphaForViewController:(UIViewController *)vc;
- (void)updateNavigationBarColorOrImageForViewController:(UIViewController *)vc;
- (void)updateNavigationBarShadowImageIAlphaForViewController:(UIViewController *)vc;

@end

@interface UINavigationController(UINavigationBar) <UINavigationBarDelegate>

@end
