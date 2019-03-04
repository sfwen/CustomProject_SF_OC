//
//  ASImageNode+Category.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/25.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "ASImageNode+Category.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>

@implementation ASImageNode (Category)

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
//    NSCAssert(url.length > 0, @"地址不能为空");
    NSString * newUrl = [url stringByReplacingOccurrencesOfString:@"-w220" withString:@"-w1080"];
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    if (manager.reachableViaWWAN) {
        SDImageCache * imageCache = [SDImageCache sharedImageCache];
        //查询缓存
        BOOL imageExist = [imageCache diskImageDataForKey:newUrl];
        if (!imageExist) {
            newUrl = url;
        }
    }
    
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:newUrl] options:options progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        self.image = placeholder;
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
//        NSLog(@"cacheType: %@", @(cacheType));
//        NSLog(@"%@", imageURL.absoluteString);
        self.image = image;
    }];
}

@end
