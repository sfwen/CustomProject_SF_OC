//
//  FaceDetectorUtil.h
//  CustomProject_SF_OC
//
//  Created by Land on 2019/3/9.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaceDetectorUtil : NSObject

- (instancetype)initWithParentView:(UIImageView *)parentView scale:(CGFloat)scale;

- (void)startCapture;
- (void)stopCapture;

- (NSArray *)detectedFaces;
- (UIImage *)faceWithIndex:(NSInteger)idx;

@end
