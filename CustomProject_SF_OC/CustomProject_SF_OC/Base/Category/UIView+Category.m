//
//  UIView+Category.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/26.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "UIView+Category.h"
#import <objc/runtime.h>

static const char *kTapGestureRecognizerBlockAddress;

@implementation UIView (Category)

#pragma mark - 圆角
- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)tapUpWithBlock:(void(^)(UIView *))aBlock {
    if(aBlock) {
        self.tapAction = aBlock;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelfTargetAction)];
        //        tapGestureRecognizer.delegate = self;
        [self addGestureRecognizer:tapGestureRecognizer];
    }
}

- (void)setTapAction:(void (^)(UIView *))tapAction {
    objc_setAssociatedObject(self, &kTapGestureRecognizerBlockAddress, tapAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void(^)(UIView *))tapAction {
    return objc_getAssociatedObject(self, &kTapGestureRecognizerBlockAddress);
}

- (void)tapSelfTargetAction {
    id block = objc_getAssociatedObject(self, &kTapGestureRecognizerBlockAddress);
    if(!block){
        return;
    }
    void(^touchUpBlock)(UIView *) = block;
    touchUpBlock(self);
}

@end
