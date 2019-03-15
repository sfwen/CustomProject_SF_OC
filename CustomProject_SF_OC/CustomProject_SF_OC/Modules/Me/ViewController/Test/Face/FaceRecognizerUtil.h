//
//  FaceRecognizerUtil.h
//  CustomProject_SF_OC
//
//  Created by Land on 2019/3/9.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaceRecognizerUtil : NSObject

+ (FaceRecognizerUtil *)faceRecWithFile:(NSString *)path;

- (BOOL)writeFaceRecParamatersToFile:(NSString *)path;

- (NSString *)predict:(UIImage *)image confidence:(double *)confidence;

- (void)updateFace:(UIImage *)faceImg name:(NSString *)name;

- (NSArray *)labels;

@end
