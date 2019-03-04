//
//  AdCollectionViewCell.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/20.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "AdCollectionViewCell.h"
#import "AdvertisingModel.h"

@interface AdCollectionViewCell ()

@property (nonatomic, strong) UIImageView * iconImageView;

@end

@implementation AdCollectionViewCell

- (void)bindViewModel:(AdvertisingModel *)viewModel {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.imagePath] placeholderImage:[UIImage imageWithColor:FlatGray] options:SDWebImageLowPriority | SDWebImageProgressiveDownload];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
//        _iconImageView.frame = CGRectZero;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.clipsToBounds = YES;
//        _iconImageView.view.loadStyle = TABViewLoadAnimationWithOnlySkeleton;
        [self.contentView addSubview:_iconImageView];
        
//        UIView * line = [[UIView alloc] init];
//        line.backgroundColor = Color_Groy_Line_217;
//        [self.contentView addSubview:line];
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView).offset(kArticleLeftMargin);
//            make.right.equalTo(self.contentView);
//            make.bottom.equalTo(self.contentView);
//            make.height.mas_equalTo(0.5);
//        }];
    }
    return _iconImageView;
}

@end
