//
//  AttributeSectionController.m
//  CustomProject_SF_OC
//
//  Created by Land on 2019/3/2.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "AttributeSectionController.h"
#import "HTMLModel.h"
#import "AttributeContentCollectionViewCell.h"
#import "AttributeImageCollectionViewCell.h"
#import "AttributeVideoCollectionViewCell.h"

@interface AttributeSectionController ()

@property (nonatomic, strong) HTMLItemModel * model;

@end

@implementation AttributeSectionController

- (void)didUpdateToObject:(id)object {
    self.model = object;
}

- (NSInteger)numberOfItems {
    NSInteger count = self.model.imagesArray.count;
    if (self.model.content.length > 0) {
        count += 1;
    }
    return count;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat h = 0;
    if (self.model.content.length > 0 && index == 0) {
        h = self.model.contentSize.height + 0.5;
    } else {
        NSInteger i = self.model.content.length > 0 ? index - 1 : index;
        id obj = [self.model.imagesArray objectAtIndex:i];
        
        ImageModel * imageModel;
        if ([[obj class] isEqual:[ImageModel class]]) {
            imageModel = [self.model.imagesArray objectAtIndex:i];
        } else if ([[obj class] isEqual:[VideoModel class]]) {
            VideoModel * videoModel = [self.model.imagesArray objectAtIndex:i];
            imageModel = videoModel.imageModel;
        } else {
            imageModel = [ImageModel new];
            imageModel.w = 1;
            imageModel.h = 0;
        }
        h = self.collectionContext.containerSize.width / imageModel.w * imageModel.h;
    }
    
    return CGSizeMake(ScreenWidth, h);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    if (self.model.content.length > 0 && index == 0) {
        AttributeContentCollectionViewCell * cell = [self.collectionContext dequeueReusableCellOfClass:[AttributeContentCollectionViewCell class] forSectionController:self atIndex:index];
        [cell configCellData:self.model.contentAttribute];
        return cell;
    } else {
        NSInteger i = self.model.content.length > 0 ? index - 1 : index;
        id obj = [self.model.imagesArray objectAtIndex:i];
        
        BasicCollectionViewCell * cell;
        if ([[obj class] isEqual:[ImageModel class]]) {
            ImageModel * imageModel = [self.model.imagesArray objectAtIndex:i];
            cell = [self.collectionContext dequeueReusableCellOfClass:[AttributeImageCollectionViewCell class] forSectionController:self atIndex:index];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            [cell configCellData:imageModel.urlStr];
        } else if ([[obj class] isEqual:[VideoModel class]]) {
            cell = [self.collectionContext dequeueReusableCellOfClass:[AttributeVideoCollectionViewCell class] forSectionController:self atIndex:index];
            [cell configCellData:nil];
        }
        
        return cell;
    }
}

@end
