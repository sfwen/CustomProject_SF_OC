//
//  PromoSectionController.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/25.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "PromoSectionController.h"
#import "PromoCollectionViewCell.h"
#import "TopicModel.h"

@interface PromoSectionController ()

@property (nonatomic, strong) TopicModel * topicModel;

@end

@implementation PromoSectionController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.inset = UIEdgeInsetsMake(0, 0, 0, 8);
    }
    return self;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(self.collectionContext.containerSize.width / 2.5, 120);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    PromoCollectionViewCell * cell = [self.collectionContext dequeueReusableCellOfClass:[PromoCollectionViewCell class] forSectionController:self atIndex:index];
        [cell configCellData:self.topicModel];
    return cell;
}

- (void)didUpdateToObject:(id)object {
    self.topicModel = object;
}

@end
