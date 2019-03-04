//
//  GoodsSectionController.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/26.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "GoodsSectionController.h"
//#import "GoodsCollectionViewCell.h"
#import "M_GoodsCollectionViewCell.h"
#import "GoodsObject.h"

@interface GoodsSectionController ()

@property (nonatomic, strong) GoodsObject * model;

@end

@implementation GoodsSectionController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.inset = UIEdgeInsetsMake(0, 12, 0, 12);
        self.minimumLineSpacing = 6;
        self.minimumInteritemSpacing = 6;
    }
    return self;
}

- (NSInteger)numberOfItems {
    return self.model.goodsDataArray.count;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(self.collectionContext.containerSize.width / 2 - self.minimumInteritemSpacing / 2 - 12, 280);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    M_GoodsCollectionViewCell * cell = [self.collectionContext dequeueReusableCellOfClass:[M_GoodsCollectionViewCell class] forSectionController:self atIndex:index];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.contentView.cornerRadius = 6;
    [cell configCellData:self.model.goodsDataArray[index]];
    return cell;
}

- (void)didUpdateToObject:(id)object {
    self.model = object;
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    [PushHelper toBookDetail];
}

@end
