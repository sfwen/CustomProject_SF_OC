//
//  AttributeImageCollectionViewCell.m
//  CustomProject_SF_OC
//
//  Created by Land on 2019/3/2.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "AttributeImageCollectionViewCell.h"
#import <FLAnimatedImage/FLAnimatedImage.h>

@interface AttributeImageCollectionViewCell ()

@property (nonatomic, strong) FLAnimatedImageView * iconImageView;

@end

@implementation AttributeImageCollectionViewCell

- (void)configCellData:(NSString *)model {
    NSLog(@"--图片地址-- %@", model);
    if ([model isGifImage]) {
        FLAnimatedImage * image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model]]];
        self.iconImageView.animatedImage = image;
    } else {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model] placeholderImage:[UIImage imageWithColor:FlatGray] options:SDWebImageLowPriority | SDWebImageProgressiveDownload];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (FLAnimatedImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[FLAnimatedImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.clipsToBounds = YES;
        [self.contentView addSubview:_iconImageView];
    }
    return _iconImageView;
}

@end
