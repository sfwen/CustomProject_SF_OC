//
//  MenuBackgroundCollectionViewCell.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/21.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "MenuBackgroundCollectionViewCell.h"
#import "MenuListObject.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "MenuCollectionViewCell.h"

@interface MenuBackgroundCollectionViewCell () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) MenuListObject * menuListObject;
@property (nonatomic, strong) SDCycleScrollView * menuScrollView; // 滚动视图

@end

@implementation MenuBackgroundCollectionViewCell

- (void)configCellData:(MenuListObject *)model {
    self.menuListObject = model;
//    self.contentView.backgroundColor = [UIColor whiteColor];
    
    double a = model.menus.count / 8.0;
    CGFloat b = ceil(a);
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < b; i++) {
        [arr addObject:@"a"];
    }
    self.menuScrollView.imageURLStringsGroup = arr;
}

- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view {
    return [MenuCollectionViewCell class];
}

- (void)setupCustomCell:(MenuCollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view {
    NSInteger from = 0;
    if (index > 0) {
        from = index * 8;
    }
    NSInteger count = 8;
    NSInteger to = (index + 1) * 8;
    if (self.menuListObject.menus.count < to) {
        count = self.menuListObject.menus.count - index * 8;
    }
    NSArray * arr = [self.menuListObject.menus subarrayWithRange:NSMakeRange(from, count)];
    
    [cell configCellData:arr];
    [cell reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.menuScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
}

/** 滚动视图 */
- (SDCycleScrollView *)menuScrollView {
    if (!_menuScrollView) {
        _menuScrollView = [[SDCycleScrollView alloc] initWithFrame:self.contentView.bounds];
//        _menuScrollView.placeholderImage = [UIImage imageWithColor:FlatWhite];
        _menuScrollView.autoScroll = NO;
        _menuScrollView.infiniteLoop = NO;
        _menuScrollView.delegate = self;
        _menuScrollView.pageControlDotSize = CGSizeMake(12, 12);
        _menuScrollView.backgroundColor = FlatWhite;
        [self.contentView addSubview:_menuScrollView];
    }
    return _menuScrollView;
}

@end
