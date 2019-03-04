//
//  APIManager.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/8.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#ifndef APIManager_h
#define APIManager_h

#pragma mark - 文章
//用户自己的栏目
#define ReadColumnsList_API @"/columnsControl/columnsbyuser"
/** 根据栏目获取列表 */
#define ArticleColumnsList_API @"/articleControl/findlist"

#pragma mark - 商城
#define StoreGetMainData_API @"/mall/home/"
#define LoadAllGoodsList_API @"/spu/app/all"

#endif /* APIManager_h */
