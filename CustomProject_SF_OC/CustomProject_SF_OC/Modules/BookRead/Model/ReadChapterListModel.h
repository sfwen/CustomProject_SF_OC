//
//  ReadChapterListModel.h
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/11.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "BasicModel.h"

@interface ReadChapterListModel : NSObject <NSCoding>

@property (nonatomic, strong) NSString * bookID;
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger priority;

@end
