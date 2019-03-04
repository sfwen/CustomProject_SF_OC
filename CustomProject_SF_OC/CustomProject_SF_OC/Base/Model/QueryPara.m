//
//  QueryPara.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/12.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "QueryPara.h"

@implementation QueryPara

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.isPaging = YES;
        self.page = 0;
        self.bigStart = 0;
        self.singleStart = 0;
        self.pagenum = 0;//每页的数量由服务器决定
    }
    return self;
}

@end
