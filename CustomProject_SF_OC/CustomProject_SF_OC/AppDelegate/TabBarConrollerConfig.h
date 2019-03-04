//
//  TabBarConrollerConfig.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/7.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "ViewController.h"

@interface TabBarConrollerConfig : NSObject

@property (nonatomic, strong) ViewController * tabBarController;

- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control;

@end
