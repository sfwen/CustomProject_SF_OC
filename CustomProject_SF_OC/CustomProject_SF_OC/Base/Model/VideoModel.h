//
//  VideoModel.h
//  CustomProject_SF_OC
//
//  Created by Land on 2019/3/12.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ImageModel.h"

@interface VideoModel : JSONModel

@property (nonatomic, copy) NSString * url;
@property (nonatomic, assign) CGFloat videoTime;
@property (nonatomic, strong) ImageModel * imageModel;

@end
