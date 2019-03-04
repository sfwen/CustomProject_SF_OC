//
//  ArticleCollectionViewCell.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/28.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "ArticleCollectionViewCell.h"
#import "ArticleInfoModel.h"

@interface ArticleCollectionViewCell ()

@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * assistContentLabel;

@property (nonatomic, strong) ArticleInfoModel * model;

@end

@implementation ArticleCollectionViewCell

- (void)configCellData:(ArticleInfoModel *)model {
    self.model = model;
    self.titleLabel.attributedText = model.attributeTitle;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.original_img] placeholderImage:[UIImage imageWithColor:FlatWhite] options:SDWebImageLowPriority | SDWebImageProgressiveDownload];
    self.assistContentLabel.attributedText = model.attributeAssistContent;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = self.model.titleFrame;
    self.iconImageView.frame = self.model.imageFrame;
    self.assistContentLabel.frame = self.model.assistContentFrame;
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
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = APPFONT(kArticleTitleFont);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)assistContentLabel {
    if (!_assistContentLabel) {
        _assistContentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_assistContentLabel];
    }
    return _assistContentLabel;
}

@end
