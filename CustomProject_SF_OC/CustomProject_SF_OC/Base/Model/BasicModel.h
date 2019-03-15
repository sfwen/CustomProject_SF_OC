//
//  BasicModel.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/11.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ImageModel.h"
#import "VideoModel.h"

@interface BasicModel : JSONModel <IGListDiffable>

@property (nonatomic, assign) CGFloat cellHeight;

- (NSMutableAttributedString *)getMutableAttributedStringWithContent:(NSString *)content fontSize:(CGFloat)fontSize;

@end
