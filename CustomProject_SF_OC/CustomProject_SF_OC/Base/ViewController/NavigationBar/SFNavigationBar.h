//
//  SFNavigationBar.h
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/4.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFNavigationBar : UINavigationBar

@property (nonatomic, strong, readonly) UIImageView        *shadowImageView;
@property (nonatomic, strong, readonly) UIVisualEffectView *fakeView;
@property (nonatomic, strong, readonly) UIImageView        *backgroundImageView;

@end
