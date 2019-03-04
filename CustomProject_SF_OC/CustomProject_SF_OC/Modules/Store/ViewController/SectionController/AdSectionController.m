//
//  AdSectionController.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/20.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "AdSectionController.h"
#import "AdvertisingModel.h"
#import "AdCollectionViewCell.h"

@interface AdSectionController ()

@property (nonatomic, strong) AdvertisingModel * model;

@end

@implementation AdSectionController

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(self.collectionContext.containerSize.width, 60);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    AdCollectionViewCell *cell = [self.collectionContext dequeueReusableCellOfClass:[AdCollectionViewCell class] forSectionController:self atIndex:index];
    [cell bindViewModel:self.model];
    return cell;
}

- (void)didUpdateToObject:(id)object {
    self.model = object;
}

@end
