//
//  GoodsCollectionViewCell.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/26.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "GoodsCollectionViewCell.h"
#import "GoodsInfoModel.h"

@interface GoodsCollectionViewCell ()

@property (nonatomic, strong) ASImageNode  * iconImageNode;
@property (nonatomic, strong) ASTextNode   * titleTextNode;
@property (nonatomic, strong) ASTextNode   * priceTextNode;
@property (nonatomic, strong) ASButtonNode * similarButtonNode;
@property (nonatomic, strong) ASTextNode   * remarkTextNode;

@end

@implementation GoodsCollectionViewCell

- (void)configCellData:(GoodsInfoModel *)model {
    [self.iconImageNode sf_loadImageWithURL:model.mainImagePath];
    self.titleTextNode.attributedText = model.titleAttributedString;
    self.priceTextNode.attributedText = model.priceAttributedString;
    self.remarkTextNode.attributedText = model.remarkAttributedString;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconImageNode.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), CGRectGetHeight(self.contentView.bounds) / 3 * 2 + 5);
    self.iconImageNode.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.titleTextNode.frame = CGRectMake(4, CGRectGetMaxY(self.iconImageNode.bounds) + 8, CGRectGetWidth(self.contentView.bounds) - 8, 40);
    self.titleTextNode.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    self.priceTextNode.frame = CGRectMake(4 + 2, CGRectGetMaxY(self.titleTextNode.frame) + 4, CGRectGetWidth(self.contentView.bounds) / 2, 20);
    self.priceTextNode.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    self.remarkTextNode.frame = CGRectMake(CGRectGetMinX(self.priceTextNode.frame), CGRectGetMaxY(self.priceTextNode.frame), CGRectGetWidth(self.contentView.bounds) - 12, 15);
    self.remarkTextNode.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
}

- (ASImageNode *)iconImageNode {
    if (!_iconImageNode) {
        _iconImageNode = [[ASImageNode alloc] init];
        _iconImageNode.contentMode = UIViewContentModeScaleToFill;
        _iconImageNode.clipsToBounds = YES;
//        _iconImageNode.view.loadStyle = TABViewLoadAnimationWithOnlySkeleton;
        [self.contentView addSubview:_iconImageNode.view];
    }
    return _iconImageNode;
}

- (ASTextNode *)titleTextNode {
    if (!_titleTextNode) {
        _titleTextNode = [[ASTextNode alloc] init];
//        _titleTextNode.backgroundColor = FlatGreen;
        [self.contentView addSubview:_titleTextNode.view];
    }
    return _titleTextNode;
}

- (ASTextNode *)priceTextNode {
    if (!_priceTextNode) {
        _priceTextNode = [[ASTextNode alloc] init];
        [self.contentView addSubview:_priceTextNode.view];
    }
    return _priceTextNode;
}

- (ASTextNode *)remarkTextNode {
    if (!_remarkTextNode) {
        _remarkTextNode = [[ASTextNode alloc] init];
//        _remarkTextNode.view.cornerRadius = 4;
        [self.contentView addSubview:_remarkTextNode.view];
    }
    return _remarkTextNode;
}

@end
