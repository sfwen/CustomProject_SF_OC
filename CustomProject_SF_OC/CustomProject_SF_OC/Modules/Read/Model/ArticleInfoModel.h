//
//  ArticleInfoModel.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/12.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "BasicModel.h"



typedef NS_ENUM(NSInteger, ArticleListShowType) {
    //图片居右显示
    ArticleListShowType_Right = 101,
    //图片大图展示
    ArticleListShowType_Big = 104,
    //图片居左展示
//    ArticleListShowType_Left = 200,
//    ArticleListShowType
};

@interface ArticleInfoModel : BasicModel

@property (nonatomic, assign) double isad;
@property (nonatomic, strong) NSString *source_avatar;
@property (nonatomic, strong) NSString *factor_column;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *article_thumb;
@property (nonatomic, assign) double article_id;
@property (nonatomic, assign) double article_type;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL canShare;
@property (nonatomic, assign) double authorId;
@property (nonatomic, assign) ArticleListShowType format;
@property (nonatomic, strong) NSString *article_img;
@property (nonatomic, strong) NSString *publish_time;
@property (nonatomic, strong) NSString *original_img;
@property (nonatomic, assign) double read_num;

#pragma mark - readonly
@property (nonatomic, strong, readonly) NSString * assistContent;

@property (nonatomic, assign, readonly) CGRect imageFrame;
@property (nonatomic, assign, readonly) CGRect titleFrame;
@property (nonatomic, assign, readonly) CGRect assistContentFrame;

@property (nonatomic, copy, readonly) NSAttributedString *attributeTitle;
@property (nonatomic, copy, readonly) NSAttributedString *attributeAssistContent;

- (void)initData;


@end
