//
//  BannerModel.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/20.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "BannerModel.h"

@implementation BannerModel

- (double)intervalTime {
    if (_intervalTime > 0) {
        return _intervalTime;
    } else {
        return 3;
    }
}

@end
