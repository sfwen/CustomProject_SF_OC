//
//  BookReadViewCell.m
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/15.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "BookReadViewCell.h"

@interface BookReadViewCell ()

@end

@implementation BookReadViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (BookReadViewCell *)cellWithTableView:(UITableView *)tableView {
    NSString * identifier = @"BookReadViewCell";
    BookReadViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[BookReadViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews {
    // 阅读View
    self.readView = [[ReadView alloc] init];
    self.readView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.readView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.readView.frame = CGRectMake(0, 0, ScreenWidth - 2 * kReadBookSpace_15, ScreenHeight - 2 * (kReadBookSpace_25 + kReadBookSpace_10));
}

- (void)setContent:(NSMutableAttributedString *)content {
    _content = content;
    self.readView.content = content;
}

@end
