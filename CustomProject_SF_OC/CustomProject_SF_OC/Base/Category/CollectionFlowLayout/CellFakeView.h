//
//  CellFakeView.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/18.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellFakeView : UIView

@property (nonatomic, weak) UICollectionViewCell * cell;
@property (nonatomic, strong) ASImageNode * cellFakeImageNode;
@property (nonatomic, strong) ASImageNode * cellFakeHeightedImageNode;
@property (nonatomic, strong) NSIndexPath * indexPath;
@property (nonatomic, assign) CGPoint originalCenter;
@property (nonatomic, assign) CGRect cellFrame;

- (instancetype)initWithCell:(UICollectionViewCell *)cell;
- (void)changeBoundsIfNeeded:(CGRect)bounds;
- (void)pushFowardView;
- (void)pushBackView:(void(^)(void))completion;

@end
