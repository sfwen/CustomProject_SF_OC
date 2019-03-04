//
//  ReadMenu.h
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/15.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookReadDetailViewController.h"
//#import "<#header#>"

typedef NS_ENUM(NSInteger, RMEffectType) {
    RMEffectType_None,//无效果
    RMEffectType_Translation,//平移
    RMEffectType_Simulation,//仿真
    RMEffectType_UpAndDown,// 上下
};

@interface ReadMenu : NSObject

+ (instancetype)sharedManager;

//@property (nonatomic, weak) BookReadDetailViewController
/// 翻页效果
@property (nonatomic, assign) RMEffectType effectType;

@end
