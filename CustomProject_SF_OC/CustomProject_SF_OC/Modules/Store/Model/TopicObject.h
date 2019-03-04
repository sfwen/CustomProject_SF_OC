//
//  TopicObject.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/21.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "BasicModel.h"
#import "TopicModel.h"

@protocol TopicModel;

@interface TopicObject : BasicModel

@property (nonatomic, strong) NSArray <TopicModel> *topics;

@end
