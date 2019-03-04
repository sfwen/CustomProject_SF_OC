//
//  PushHelper.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/27.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushHelper : NSObject

+ (void)toArticleDetailWithColumnID:(NSInteger)columnID articleID:(NSInteger)articleID;
+ (void)toGoodsDetailWtihID:(NSString *)goodsID;
+ (void)toBookDetail;

@end
