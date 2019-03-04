//
//  UIImageView+Category.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/29.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Category)

- (void)sf_loadImageWithURL:(NSString *_Nonnull)url;
- (void)sf_loadImageWithURL:(NSString *_Nonnull)url
           placeholderImage:(nullable UIImage *)placeholder;
- (void)sf_loadImageWithURL:(NSString *_Nonnull)url
           placeholderImage:(nullable UIImage *)placeholder
                    options:(SDWebImageOptions)options;

@end
