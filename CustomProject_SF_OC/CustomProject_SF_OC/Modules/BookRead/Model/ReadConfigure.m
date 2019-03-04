//
//  ReadConfigure.m
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/6.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "ReadConfigure.h"

@interface ReadConfigure ()

@property (nonatomic, strong) NSMutableArray * readBGColorsArray;

@end

@implementation ReadConfigure

static ReadConfigure * _instance = nil;

+ (instancetype) shareInstance {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
        _instance.effectType = RMEffectType_UpAndDown;
    }) ;
    return _instance ;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [ReadConfigure shareInstance] ;
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [ReadConfigure shareInstance] ;
}

- (NSMutableArray *)readBGColorsArray {
    if (!_readBGColorsArray) {
        _readBGColorsArray = [[NSMutableArray alloc] init];
        [_readBGColorsArray addObject:[UIColor whiteColor]];
        [_readBGColorsArray addObject:rgb(238, 224, 202)];
        [_readBGColorsArray addObject:rgb(205, 239, 205)];
        [_readBGColorsArray addObject:rgb(206, 233, 241)];
        [_readBGColorsArray addObject:rgb(251, 237, 199)];//牛皮黄
         
    }
    return _readBGColorsArray;
}

/// 获得文字Font
- (UIFont *)readFont:(BOOL)isTile {
    return APPFONT(18);
}

@end
