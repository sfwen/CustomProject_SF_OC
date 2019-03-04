//
//  BannerModel.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/20.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "BasicModel.h"
#import "BannerInfoModel.h"

@protocol BannerInfoModel;

@interface BannerModel : BasicModel

@property (nonatomic, strong) NSArray <BannerInfoModel> *banners;
@property (nonatomic, assign) double intervalTime;

@end
