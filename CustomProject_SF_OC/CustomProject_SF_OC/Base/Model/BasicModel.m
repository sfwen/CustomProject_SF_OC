//
//  BasicModel.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/11.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "BasicModel.h"

@implementation BasicModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

- (id<NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    return [self isEqual:object];
}

- (NSMutableAttributedString *)getMutableAttributedStringWithContent:(NSString *)content fontSize:(CGFloat)fontSize {
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 2;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, content.length)];
    [attributeString addAttribute:NSFontAttributeName value:APPFONT(fontSize) range:NSMakeRange(0, content.length)];
    return attributeString;
}


@end
