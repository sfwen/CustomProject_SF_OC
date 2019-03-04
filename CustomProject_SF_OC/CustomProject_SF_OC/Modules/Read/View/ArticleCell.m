//
//  ArticleCell.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/11.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "ArticleCell.h"
#import "ArticleInfoModel.h"
//#import <SDWebImage/UIImage+MultiFormat.h>

@interface ArticleCell ()

@property (nonatomic, strong) ArticleInfoModel * model;

@property (nonatomic, strong) ASImageNode * iconImageView;
@property (nonatomic, strong) ASTextNode * titleTextNode;
@property (nonatomic, strong) ASTextNode * assistContentTextNode;
//@property (nonatomic, strong) ASTextNode * timeTextNode;
//@property (nonatomic, strong) ASTextNode * sourceTextNode;
//@property (nonatomic, strong) ASTextNode * readCountTextNode;

@end

@implementation ArticleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.titleTextNode.attributedText = [[NSMutableAttributedString alloc] initWithString:@""];
    }
    return self;
}

- (void)configCellData:(ArticleInfoModel *)model {
    self.model = model;
    
    self.titleTextNode.attributedText = model.attributeTitle;
    [self.iconImageView sf_loadImageWithURL:model.original_img];
    self.assistContentTextNode.attributedText = model.attributeAssistContent;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleTextNode.frame = self.model.titleFrame;
    self.iconImageView.frame = self.model.imageFrame;
    self.assistContentTextNode.frame = self.model.assistContentFrame;
}


- (ASImageNode *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[ASImageNode alloc] init];
//        _iconImageView.frame = CGRectMake(CGRectGetWidth(self.contentView.bounds) - 24 - 80, 10, 80, 80);
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.clipsToBounds = YES;
        _iconImageView.view.loadStyle = TABViewLoadAnimationWithOnlySkeleton;
        [self.contentView addSubview:_iconImageView.view];
        
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = Color_Groy_Line_217;
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(kArticleLeftMargin);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _iconImageView;
}

- (ASTextNode *)titleTextNode {
    if (!_titleTextNode) {
        _titleTextNode = [[ASTextNode alloc] init];
        _titleTextNode.frame = CGRectMake(12, 20, 200, 30);
        _titleTextNode.highlightStyle = ASTextNodeHighlightStyleLight;
//        _titleTextNode.maximumNumberOfLines = 2;
        _titleTextNode.view.loadStyle = TABViewLoadAnimationLong;
        [self.contentView addSubview:_titleTextNode.view];
    }
    return _titleTextNode;
}

- (ASTextNode *)assistContentTextNode {
    if (!_assistContentTextNode) {
        _assistContentTextNode = [[ASTextNode alloc] init];
        _assistContentTextNode.frame = CGRectMake(12, 70, 60, 30);
        _assistContentTextNode.highlightStyle = ASTextNodeHighlightStyleLight;
        _assistContentTextNode.view.loadStyle = TABViewLoadAnimationWithOnlySkeleton;
        [self.contentView addSubview:_assistContentTextNode.view];
    }
    return _assistContentTextNode;
}

//- (ASTextNode *)sourceTextNode {
//    if (!_sourceTextNode) {
//        _sourceTextNode = [[ASTextNode alloc] init];
//        _sourceTextNode.frame = CGRectMake(12, 70, 60, 30);
//        _sourceTextNode.highlightStyle = ASTextNodeHighlightStyleLight;
//        //        _titleTextNode.maximumNumberOfLines = 2;
//        _sourceTextNode.view.loadStyle = TABViewLoadAnimationWithOnlySkeleton;
//        [self.contentView addSubview:_sourceTextNode.view];
//    }
//    return _sourceTextNode;
//}

@end
