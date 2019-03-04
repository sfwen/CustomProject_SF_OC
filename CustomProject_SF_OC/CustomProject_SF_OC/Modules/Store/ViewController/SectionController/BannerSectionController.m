//
//  BannerSectionController.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/21.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "BannerSectionController.h"
#import "BannerModel.h"
#import "BannerCollectionViewCell.h"

@interface BannerSectionController ()

@property (nonatomic, strong) BannerModel * model;

@end

@implementation BannerSectionController

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(self.collectionContext.containerSize.width, 200);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    BannerCollectionViewCell * cell = [self.collectionContext dequeueReusableCellOfClass:[BannerCollectionViewCell class] forSectionController:self atIndex:index];
    [cell configCellData:self.model];
    return cell;
}

- (void)didUpdateToObject:(id)object {
    self.model = object;
}

@end
