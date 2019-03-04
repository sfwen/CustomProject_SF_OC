//
//  QueryPara.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/12.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface QueryPara : JSONModel

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger bigStart;
@property (nonatomic, assign) NSInteger singleStart;
@property (nonatomic, assign) NSInteger pagenum;

//@property (nonatomic, assign) int pageSize;
//@property (nonatomic, assign) int pageCount;
//@property (nonatomic, copy) NSString *queryKey;
//@property (nonatomic, assign) BOOL isPaging;

@end
