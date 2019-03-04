//
//  ReadMarkModel.h
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/10.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "BasicModel.h"

@interface ReadMarkModel : BasicModel

@property (nonatomic, strong) NSString * bookID;
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSDate * time;
@property (nonatomic, strong) NSNumber * location;

@end
