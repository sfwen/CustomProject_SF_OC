//
//  StoreMainModel.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/20.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "BasicModel.h"
#import "AdvertisingModel.h"
#import "BannerModel.h"
#import "MenuModel.h"
#import "TopicModel.h"
#import "MenuListObject.h"
#import "TopicObject.h"

@protocol MenuModel, TopicModel;

@interface StoreMainModel : BasicModel

@property (nonatomic, strong) NSArray <MenuModel> *menus;
@property (nonatomic, strong) AdvertisingModel *advertising;
@property (nonatomic, strong) NSArray <TopicModel> *topics;
@property (nonatomic, strong) NSArray *windowAndBanners;
@property (nonatomic, strong) BannerModel *banner;

@end
