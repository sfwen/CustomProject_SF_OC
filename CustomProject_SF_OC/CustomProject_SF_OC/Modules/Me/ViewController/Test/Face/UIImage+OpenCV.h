//
//  UIImage+OpenCV.h
//  CustomProject_SF_OC
//
//  Created by Land on 2019/3/7.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (OpenCV)

+ (cv::Mat)cvMatFromUIImage:(UIImage *)image;
+ (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image;
+ (UIImage *)imageFromCVMat:(cv::Mat)cvMat;

@end
