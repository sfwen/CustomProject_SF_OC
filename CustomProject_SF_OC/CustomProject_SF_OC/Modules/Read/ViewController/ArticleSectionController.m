//
//  ArticleSectionController.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/28.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "ArticleSectionController.h"
#import "ArticleInfoModel.h"
#import "ArticleCollectionViewCell.h"

@interface ArticleSectionController ()

@property (nonatomic, strong) ArticleInfoModel * model;

@end

@implementation ArticleSectionController

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    [self.model initData];
    return CGSizeMake(self.collectionContext.containerSize.width, self.model.cellHeight);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    ArticleCollectionViewCell *cell = [self.collectionContext dequeueReusableCellOfClass:[ArticleCollectionViewCell class] forSectionController:self atIndex:index];
    cell.contentView.backgroundColor = FlatWhite;//[UIColor whiteColor];
    [cell configCellData:self.model];
    return cell;
}

- (void)didUpdateToObject:(id)object {
    [self.model initData];
    self.model = object;
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    [PushHelper toArticleDetailWithColumnID:self.columnsId articleID:self.model.article_id];
}

@end
