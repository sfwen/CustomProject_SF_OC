//
//  ReadConfigure.h
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/6.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadMenu.h"

static NSString * kReadConfigureKey = @"ReadConfigure";

@interface ReadConfigure : NSObject

+ (instancetype) shareInstance;

/// 获得文字Font
- (UIFont *)readFont:(BOOL)isTile;

@property (nonatomic, assign) RMEffectType effectType;

@end
