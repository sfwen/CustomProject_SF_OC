//
//  ArticleColumnModel.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/10.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ArticleColumnModel : JSONModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger columnsId;
@property (nonatomic, assign) BOOL edit;
@property (nonatomic, assign) BOOL guidePrefer;

@end
