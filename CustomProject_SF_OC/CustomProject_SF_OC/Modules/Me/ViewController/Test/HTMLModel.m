//
//  HTMLModel.m
//  CustomProject_SF_OC
//
//  Created by Land on 2019/3/1.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "HTMLModel.h"

@implementation HTMLModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentArray = [[NSMutableArray alloc] init];
    }
    return self;
}

@end

@implementation HTMLItemModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.imagesArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSMutableAttributedString *)contentAttribute {
    NSMutableAttributedString * abs = [[NSMutableAttributedString alloc] initWithString:self.content];
    // 2. 为文本设置属性
    abs.font = APPFONT(14);
    abs.color = FlatBlack;
    abs.lineSpacing = 8;
    return abs;
}

- (CGSize)contentSize {
    return [NSString sizeLabelToFit:self.contentAttribute width:ScreenWidth height:1000];
}

@end
