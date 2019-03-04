//
//  ReadMenu.m
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/15.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "ReadMenu.h"

@interface ReadMenu ()

@end

@implementation ReadMenu

+ (instancetype)sharedManager {
    static ReadMenu *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[ReadMenu alloc] init];
        _manager.effectType = RMEffectType_Simulation;
    });
    return _manager;
}

@end
