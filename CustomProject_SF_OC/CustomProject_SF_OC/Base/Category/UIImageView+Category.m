//
//  UIImageView+Category.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/29.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "UIImageView+Category.h"

@implementation UIImageView (Category)

- (void)sf_loadImageWithURL:(NSString *)url {
    [self sf_loadImageWithURL:url placeholderImage:[UIImage imageWithColor:FlatGray] options:SDWebImageLowPriority | SDWebImageProgressiveDownload];
}


- (void)sf_loadImageWithURL:(NSString *)url
           placeholderImage:(nullable UIImage *)placeholder {
    [self sf_loadImageWithURL:url placeholderImage:placeholder options:SDWebImageLowPriority | SDWebImageProgressiveDownload];
}
- (void)sf_loadImageWithURL:(NSString *)url
           placeholderImage:(nullable UIImage *)placeholder
                    options:(SDWebImageOptions)options {
    if (url.length == 0) {
        return;
    }
    
    NSString * newUrl = [url stringByReplacingOccurrencesOfString:@"-w220" withString:@"-w1080"];
     [self sd_setImageWithURL:[NSURL URLWithString:newUrl] placeholderImage:[UIImage imageWithColor:FlatWhite] options:SDWebImageLowPriority | SDWebImageProgressiveDownload];
}

@end
