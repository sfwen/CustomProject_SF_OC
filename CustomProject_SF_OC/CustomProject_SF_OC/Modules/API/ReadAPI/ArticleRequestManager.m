//
//  ArticleRequestManager.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/8.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "ArticleRequestManager.h"

@implementation ArticleRequestManager

+ (void)getUserColumnsSuccess:(ResponseSuccessBlock)success fail:(ResponseFailBlock *)fail {
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setObject:kRevisionControlName forKey:@"vertype"];
    [NetworkHelper getWithUrl:ReadColumnsList_API refreshRequest:YES cache:YES params:params progressBlock:nil successBlock:^(id response, BOOL cache) {
        
    } failBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
