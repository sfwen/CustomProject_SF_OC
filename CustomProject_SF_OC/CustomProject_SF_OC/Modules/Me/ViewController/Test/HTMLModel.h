//
//  HTMLModel.h
//  CustomProject_SF_OC
//
//  Created by Land on 2019/3/1.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "BasicModel.h"

@class HTMLItemModel;

@interface HTMLModel : BasicModel

@property (nonatomic, copy) NSString * title;
@property (nonatomic, strong) NSMutableArray <HTMLItemModel *> * contentArray;

@end

typedef NS_ENUM(NSInteger, ItemDataType) {
    ItemDataType_Text =0,
    ItemDataType_Image,
    ItemDataType_Gif,
    ItemDataType_Video
};

@interface HTMLItemModel : BasicModel

@property (nonatomic, assign) ItemDataType dataType;

@property (nonatomic, copy) NSString * content;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, copy) NSMutableAttributedString * contentAttribute;

@property (nonatomic, strong) NSMutableArray * imagesArray;

@end
