//
//  ArticleRequestManager.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/8.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleRequestManager : NSObject

+ (void)getUserColumnsSuccess:(ResponseSuccessBlock)success fail:(ResponseFailBlock *)fail;

@end
