//
//  TopicCollectionViewCell.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/25.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "TopicCollectionViewCell.h"

@implementation TopicCollectionViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.collectionView.frame = self.contentView.bounds;
//    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.alwaysBounceVertical = NO;
        _collectionView.alwaysBounceHorizontal = YES;
        [self.contentView addSubview:_collectionView];
    }
    return _collectionView;
}

@end
