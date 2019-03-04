//
//  ConfigManager.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/8.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#ifndef ConfigManager_h
#define ConfigManager_h

typedef NS_ENUM(NSInteger, NetworkEnvironment) {
    /**
     开发环境
     */
    NetworkEnvironmentDevelopment   = 1 << 0,
    /**
     测试环境
     */
    NetworkEnvironmentTest          = 1 << 1,
    /**
     正式环境
     */
    NetworkEnvironmentDistribution = 1 << 2,
    /**
     文章的URL
     */
    NetworkEnvironmentArticle     = 1 << 3
};

/*
 设置网络环境
 */
static NetworkEnvironment networkEnvironment = NetworkEnvironmentDevelopment;

static NSString * kBasicURL_Article     = @"";
#define kArticleDetailBasicURL @"http://www.yanwei365.com/yw_cloud/static_file/article/detailPage.html"

static NSString * kBasicURL_Store       = @"http://api.yuntujk.com";

static NSString * kCellIdentifierDefault = @"Cell";

static NSString * kRevisionControlName   = @"tp";
static NSString * kChannelValue          = @"ooo_PJ";

#pragma mark - 文字相关字体
static CGFloat kArticleTitleFont         = 14.0;
static CGFloat kArticleContentFont       = 12.0;
static CGFloat kArticleAssistFont        = 9.0;
//static CGFloat kArticleTimeFont          = 12.0;
//static CGFloat kArticleSourceFont        = 12.0;
//static CGFloat kArticleReadCountFont     = 12.0;
static CGFloat kArticleLeftMargin        = 12.0;
static CGFloat kArticleRightMargin       = 12.0;
static CGFloat kArticleTopMargin         = 10.0;
static CGFloat kArticleBottomMargin      = 10.0;

static CGFloat kStoreTitleFont = 12.0f;
static CGFloat kStoreMenuFont = 8.0f;
static CGFloat kStoreRemarkFont = 7.0f;

#pragma mark - 阅读器

#pragma mark - 字体支持
static CGFloat kReadBookFont_10 = 10.0f;
static CGFloat kReadBookFont_12 = 12.0f;
static CGFloat kReadBookFont_18 = 18.0f;

#pragma mark - 间距支持
static CGFloat kReadBookSpace_1 = 1.0f;
static CGFloat kReadBookSpace_5 = 5.0f;
static CGFloat kReadBookSpace_10 = 10.0f;
static CGFloat kReadBookSpace_15 = 15.0f;
static CGFloat kReadBookSpace_20 = 20.0f;
static CGFloat kReadBookSpace_25 = 25.0f;

#pragma mark - 拖拽触发光标范围
static CGFloat kCursorOffset = -20;

#pragma mark - key
/// 是夜间还是日间模式   true:夜间 false:日间
static NSString * Key_IsNighOrtDay = @"isNightOrDay";

/// ReadView 手势开启状态
static NSString * Key_ReadView_Ges_isOpen = @"isOpen";

/// 段落头部双圆角空格
static NSString * KParagraphHeaderSpace = @"　　";


#endif /* ConfigManager_h */



