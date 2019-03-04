//
//  MenuItemCollectionViewCell.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/21.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "MenuItemCollectionViewCell.h"
#import "MenuModel.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface MenuItemCollectionViewCell ()

@property (nonatomic, strong) UIImageView * backgroundImageView;
@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UILabel     * titleLabel;

@end

@implementation MenuItemCollectionViewCell

- (void)configCellData:(MenuModel *)model {
    [self.backgroundImageView sf_loadImageWithURL:model.backImgPath];
    [self.iconImageView sf_loadImageWithURL:model.logoPath];
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:model.title];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    [attributedString setAttributes:@{NSParagraphStyleAttributeName : style}];
    [attributedString addAttribute:NSForegroundColorAttributeName value:Color_Block_51 range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSFontAttributeName value:APPFONT(kStoreMenuFont) range:NSMakeRange(0, attributedString.length)];
    self.titleLabel.attributedText = attributedString;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.backgroundImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.top.equalTo(self.backgroundImageView).with.offset(3);
        make.centerX.equalTo(self.backgroundImageView);
    }];
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backgroundImageView).with.offset(8);
        make.right.equalTo(self.backgroundImageView).with.offset(-8);
        make.top.equalTo(self.iconImageView.mas_bottom).with.offset(4);
    }];
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_backgroundImageView];
    }
    return _backgroundImageView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        [self.backgroundImageView addSubview:_iconImageView];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [self.backgroundImageView addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
