//
//  AttributeContentCollectionViewCell.m
//  CustomProject_SF_OC
//
//  Created by Land on 2019/3/2.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "AttributeContentCollectionViewCell.h"

@interface AttributeContentCollectionViewCell ()

@property (nonatomic, strong) UILabel * contentLabel;

@end

@implementation AttributeContentCollectionViewCell

- (void)configCellData:(NSMutableAttributedString *)model {
    self.contentLabel.attributedText = model;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

@end
