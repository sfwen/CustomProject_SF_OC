//
//  MenuCollectionViewCell.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/21.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "MenuCollectionViewCell.h"
#import "MenuModel.h"
#import "MenuItemCollectionViewCell.h"

@interface MenuCollectionViewCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView * collectionView;
//@property (nonatomic, strong) IGListAdapter * adapter;

@property (nonatomic, strong) NSArray * contentArray;

@end

@implementation MenuCollectionViewCell

- (void)configCellData:(NSArray *)model {
    self.contentArray = model;
}

- (void)reloadData {
//    self.collectionView.backgroundColor = randomColor;
    [self.collectionView reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.contentArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MenuItemCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MenuItemCollectionViewCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(MenuItemCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [cell configCellData:[self.contentArray objectAtIndex:indexPath.item]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(ScreenWidth / 4.0, 65);
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 4;
        flowLayout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.alwaysBounceVertical = NO;
        _collectionView.alwaysBounceHorizontal = NO;
        [self.contentView addSubview:_collectionView];
        
        [_collectionView registerClass:[MenuItemCollectionViewCell class] forCellWithReuseIdentifier:@"MenuItemCollectionViewCell"];
    }
    return _collectionView;
}

@end
