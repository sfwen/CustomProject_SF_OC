//
//  ImageModel.h
//  CustomProject_SF_OC
//
//  Created by Land on 2019/3/2.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ImageModel : JSONModel

@property (nonatomic, assign) CGFloat w;
@property (nonatomic, assign) CGFloat h;
@property (nonatomic, copy) NSString * urlStr;
@property (nonatomic, copy, readonly) NSURL * url;

@end
