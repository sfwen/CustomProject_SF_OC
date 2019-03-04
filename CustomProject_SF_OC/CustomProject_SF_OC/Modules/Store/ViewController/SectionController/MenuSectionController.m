//
//  MenuSectionController.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/21.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "MenuSectionController.h"
#import "MenuListObject.h"
#import "MenuBackgroundCollectionViewCell.h"

@interface MenuSectionController ()

@property (nonatomic, strong) MenuListObject * model;

@end

@implementation MenuSectionController

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(self.collectionContext.containerSize.width, 160);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    MenuBackgroundCollectionViewCell * cell = [self.collectionContext dequeueReusableCellOfClass:[MenuBackgroundCollectionViewCell class] forSectionController:self atIndex:index];
    [cell configCellData:self.model];
    return cell;
}

- (void)didUpdateToObject:(id)object {
    self.model = object;
}

@end
