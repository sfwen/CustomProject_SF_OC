//
//  CellFakeView.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/18.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "CellFakeView.h"

@implementation CellFakeView

- (instancetype)initWithCell:(UICollectionViewCell *)cell {
    self = [super initWithFrame:cell.frame];
    if (self) {
        self.cell = cell;
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 0;
        self.layer.shadowRadius = 5.0;
        self.layer.shouldRasterize = NO;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        
        self.cellFakeImageNode = [[ASImageNode alloc] init];
        self.cellFakeImageNode.frame = self.bounds;
        self.cellFakeImageNode.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.cellFakeHeightedImageNode = [[ASImageNode alloc] init];
        self.cellFakeHeightedImageNode.frame = self.bounds;
        self.cellFakeHeightedImageNode.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        cell.highlighted = YES;
        [self.cellFakeHeightedImageNode setImage:[self getCellImage]];
        cell.highlighted = NO;
        [self.cellFakeImageNode setImage:[self getCellImage]];
        
        [self addSubview:self.cellFakeImageNode.view];
        [self addSubview:self.cellFakeHeightedImageNode.view];
    }
    return self;
}

- (void)changeBoundsIfNeeded:(CGRect)bounds {
    if (CGRectEqualToRect(self.bounds, bounds)) {
        return;
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.bounds = bounds;
    } completion:nil];
}

- (void)pushFowardView {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.center = self.originalCenter;
        self.transform = CGAffineTransformMakeScale(1.1, 1.1);
        self.cellFakeHeightedImageNode.alpha = 0;
        
        CABasicAnimation * shadowAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
        shadowAnimation.fromValue = @(0);
        shadowAnimation.toValue = @(0.7);
        shadowAnimation.removedOnCompletion = NO;
        shadowAnimation.fillMode = kCAFillModeForwards;
        [self.layer addAnimation:shadowAnimation forKey:@"applyShadow"];
    } completion:^(BOOL finished) {
        [self.cellFakeHeightedImageNode.view removeFromSuperview];
    }];
}

- (void)pushBackView:(void (^)(void))completion {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        CABasicAnimation * shadowAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
        shadowAnimation.fromValue = @(0.7);
        shadowAnimation.toValue = @(0);
        shadowAnimation.removedOnCompletion = NO;
        shadowAnimation.fillMode = kCAFillModeForwards;
        [self.layer addAnimation:shadowAnimation forKey:@"removeShadow"];
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (UIImage *)getCellImage {
    UIGraphicsBeginImageContextWithOptions(self.cell.bounds.size, NO, [UIScreen mainScreen].scale * 2);
    
    [self.cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
