//
//  ArticleInfoModel.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/12.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "ArticleInfoModel.h"


@interface ArticleInfoModel () {
    CGFloat _smallImageWidth;// = ScreenWidth * 0.25;
    CGFloat _smallImageHeight;
}

@end

@implementation ArticleInfoModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData {
    _smallImageWidth = ScreenWidth * 0.32;
    _smallImageHeight = _smallImageWidth * 0.78;
}

- (CGFloat)cellHeight {
    CGFloat h = 0;
    if (self.format == ArticleListShowType_Big) {
//        h = kArticleTopMargin + self.titleHeight + self.imageFrame.size.height + 20;
        h = CGRectGetMaxY(self.imageFrame) + 30;
    } else {
        NSLog(@"%@", NSStringFromCGRect(self.imageFrame));
        h = self.imageFrame.size.height + kArticleTopMargin + kArticleBottomMargin;
    }
    return h;
}

- (CGFloat)titleHeight {
    CGFloat h = 0;//kArticleTopMargin + 8;

    NSMutableAttributedString * attributeString = [self getMutableAttributedStringWithContent:self.title fontSize:kArticleTitleFont];
    //文本绘制时的附加选项
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGFloat width = ScreenWidth - kArticleLeftMargin - kArticleRightMargin;
    CGFloat maxHeight = _smallImageHeight * 0.7;
    if (self.format != ArticleListShowType_Big) {
        width -= _smallImageWidth - 8;
    }

    CGRect rect = [attributeString boundingRectWithSize:CGSizeMake(width, maxHeight) options:options context:nil];
    h += rect.size.height;
    
    return h;
}

- (NSString *)assistContent {
    NSString * timeStr = [NSString convertTotimeSp:self.publish_time];
    timeStr = [NSString timeDifferenceWithNowTimer:timeStr];
    
    NSString * str = [NSString stringWithFormat:@"%@ %@阅读 %@", self.source, @(self.read_num), timeStr];
    return str;
}

#pragma mark - frame
- (CGRect)imageFrame {
    CGRect rect;
    if (self.format == ArticleListShowType_Big) {
        CGFloat width = ScreenWidth - kArticleLeftMargin - kArticleRightMargin;
        rect = CGRectMake(kArticleLeftMargin, kArticleTopMargin + self.titleHeight + 8, width, width * 0.6);
    } else {
        rect = CGRectMake(ScreenWidth - kArticleRightMargin - _smallImageWidth, kArticleTopMargin, _smallImageWidth, _smallImageHeight);
    }
    
    return rect;
}

- (CGRect)titleFrame {
    CGRect rect;
    if (self.format == ArticleListShowType_Big) {
        CGFloat width = ScreenWidth - kArticleLeftMargin - kArticleRightMargin;
        rect = CGRectMake(kArticleLeftMargin, kArticleTopMargin, width, self.titleHeight);
    } else {
        rect = CGRectMake(kArticleLeftMargin, kArticleTopMargin, ScreenWidth - kArticleLeftMargin - 8 - _smallImageWidth - kArticleRightMargin, self.titleHeight);
    }
    
    return rect;
}

- (CGRect)assistContentFrame {
    CGRect rect;
    CGSize size = [self.assistContent sizeForFont:APPFONT(kArticleAssistFont) size:CGSizeMake(200, 30) mode:NSLineBreakByWordWrapping];
    if (self.format == ArticleListShowType_Big) {
        rect = CGRectMake(kArticleLeftMargin, CGRectGetMaxY(self.imageFrame) + 8, size.width, size.height);
    } else {
        rect = CGRectMake(kArticleLeftMargin, CGRectGetMaxY(self.imageFrame) - size.height, CGRectGetWidth(self.titleFrame), size.height);
    }
    
    return rect;
}


#pragma mark - 展示内容
- (NSAttributedString *)attributeTitle {
    NSMutableAttributedString * attributeString = [self getMutableAttributedStringWithContent:self.title fontSize:kArticleTitleFont];
    [attributeString addAttribute:NSForegroundColorAttributeName value:Color_Block_51 range:NSMakeRange(0, attributeString.length)];
    return attributeString;
}

- (NSAttributedString *)attributeAssistContent {
    NSMutableAttributedString * attributeString = [self getMutableAttributedStringWithContent:self.assistContent fontSize:kArticleAssistFont];
    [attributeString addAttribute:NSForegroundColorAttributeName value:Color_Groy_140 range:NSMakeRange(0, attributeString.length)];
    return attributeString;
}

@end
