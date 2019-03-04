//
//  BannerCollectionViewCell.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/21.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "BannerCollectionViewCell.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "BannerModel.h"

@interface BannerCollectionViewCell () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView * imageScrollView; // 滚动视图

@property (nonatomic, strong) BannerModel * model;

@end

@implementation BannerCollectionViewCell

- (void)configCellData:(BannerModel *)model {
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    [model.banners enumerateObjectsUsingBlock:^(BannerInfoModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObject:obj.imagePath];
    }];
    self.imageScrollView.imageURLStringsGroup = arr;
    self.imageScrollView.autoScrollTimeInterval = model.intervalTime;
}

//- (void)bindViewModel:(BannerModel *)viewModel {
//    self.model = viewModel;
//
//    NSMutableArray * arr = [[NSMutableArray alloc] init];
//    [viewModel.banners enumerateObjectsUsingBlock:^(BannerInfoModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [arr addObject:obj.imagePath];
//    }];
//    self.imageScrollView.imageURLStringsGroup = arr;
//    self.imageScrollView.autoScrollTimeInterval = viewModel.intervalTime;
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_imageScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
}

/** 滚动视图 */
- (SDCycleScrollView *)imageScrollView {
    if (!_imageScrollView) {
        _imageScrollView = [[SDCycleScrollView alloc] initWithFrame:self.contentView.bounds];
        _imageScrollView.placeholderImage = [UIImage imageWithColor:FlatGray];
        _imageScrollView.autoScroll = true;
        _imageScrollView.delegate = self;
        _imageScrollView.pageControlDotSize = CGSizeMake(12, 12);
        [self.contentView addSubview:_imageScrollView];
    }
    return _imageScrollView;
}

@end
