//
//  GoodsInfoModel.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/26.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "GoodsInfoModel.h"

@implementation GoodsInfoModel

- (NSMutableAttributedString *)titleAttributedString {
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] initWithString:self.title];
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 2;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributeString.length)];
    [attributeString addAttribute:NSFontAttributeName value:APPFONT(kStoreTitleFont) range:NSMakeRange(0, attributeString.length)];
    [attributeString addAttribute:NSForegroundColorAttributeName value:Color_Block_51 range:NSMakeRange(0, attributeString.length)];
    
    return attributeString;
}

- (NSMutableAttributedString *)priceAttributedString {
    NSString * str = [self.employeePrice stringByAppendingString:@"元"];
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 1;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributeString.length)];
    [attributeString addAttribute:NSFontAttributeName value:APPFONT(kStoreTitleFont) range:NSMakeRange(0, attributeString.length)];
    [attributeString addAttribute:NSForegroundColorAttributeName value:FlatRed range:NSMakeRange(0, attributeString.length)];
    
    return attributeString;
}

- (NSMutableAttributedString *)remarkAttributedString {
    NSString * str = @"近期加入购物车";
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    //行间距
    style.lineSpacing = 1;
    //整段缩进
//    style.headIndent = 6;
    //右侧缩进
//    style.tailIndent = -6;
//    style.ba
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributeString.length)];
    [attributeString addAttribute:NSFontAttributeName value:APPFONT(kStoreRemarkFont) range:NSMakeRange(0, attributeString.length)];
    [attributeString addAttribute:NSForegroundColorAttributeName value:FlatRed range:NSMakeRange(0, attributeString.length)];
    [attributeString addAttribute:NSBackgroundColorAttributeName value:rgb(6, 60, 80) range:NSMakeRange(0, attributeString.length)];
    
    //添加阴影
//    NSShadow *shadow = [[NSShadow alloc] init];
//    shadow.shadowColor = [UIColor whiteColor];
//    shadow.shadowBlurRadius = 4;
//    [attributeString addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(0, attributeString.length)];
    
    return attributeString;
}

@end
