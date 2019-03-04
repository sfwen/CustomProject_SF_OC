//
//  ASImageNode+Category.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/25.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface ASImageNode (Category)

- (void)sf_loadImageWithURL:(NSString *_Nonnull)url;
- (void)sf_loadImageWithURL:(NSString *_Nonnull)url
           placeholderImage:(nullable UIImage *)placeholder;
- (void)sf_loadImageWithURL:(NSString *_Nonnull)url
           placeholderImage:(nullable UIImage *)placeholder
                    options:(SDWebImageOptions)options;

@end
