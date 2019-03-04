//
//  M_GoodsCollectionViewCell.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/27.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "M_GoodsCollectionViewCell.h"
#import "GoodsInfoModel.h"

@interface M_GoodsCollectionViewCell ()

@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UILabel     * titleLabel;
@property (nonatomic, strong) UILabel     * priceLabel;
@property (nonatomic, strong) UIButton    * similarButton;
@property (nonatomic, strong) UILabel     * remarkLabel;

@end

@implementation M_GoodsCollectionViewCell

- (void)configCellData:(GoodsInfoModel *)model {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.mainImagePath] placeholderImage:[UIImage imageWithColor:FlatWhite] options:SDWebImageLowPriority | SDWebImageProgressiveDownload];
    
    self.titleLabel.attributedText = model.titleAttributedString;
    self.priceLabel.attributedText = model.priceAttributedString;
    self.remarkLabel.attributedText = model.remarkAttributedString;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.equalTo(self.contentView).multipliedBy(0.7);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(6);
        make.right.equalTo(self.contentView).with.offset(-6);
        make.top.equalTo(self.iconImageView.mas_bottom).with.offset(4);
        make.height.mas_lessThanOrEqualTo(40);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(4);
    }];
    
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.priceLabel.mas_bottom).with.offset(2);
        make.right.lessThanOrEqualTo(self.titleLabel);
    }];
}


- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImageView];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = APPFONT(kStoreTitleFont);
        _titleLabel.textColor = Color_Block_51;
        _titleLabel.numberOfLines = 2;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (UILabel *)remarkLabel {
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.cornerRadius = 4;
        _remarkLabel.numberOfLines = 1;
//        _remarkLabel.backgroundColor = FlatGreen;
        [self.contentView addSubview:_remarkLabel];
    }
    return _remarkLabel;
}
@end
