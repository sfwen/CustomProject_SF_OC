//
//  MenuListObject.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/21.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "BasicModel.h"
#import "MenuModel.h"

@protocol MenuModel;

@interface MenuListObject : BasicModel

@property (nonatomic, strong) NSArray <MenuModel> *menus;

@end