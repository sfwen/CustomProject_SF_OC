//
//  TopicSectionController.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/25.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "TopicSectionController.h"
#import "TopicCollectionViewCell.h"
#import "TopicObject.h"
#import "PromoSectionController.h"

@interface TopicSectionController () <IGListAdapterDataSource>

@property (nonatomic, strong) TopicObject * topicObject;
@property (nonatomic, strong) IGListAdapter * adapter;

@end

@implementation TopicSectionController

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(self.collectionContext.containerSize.width, 120);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    TopicCollectionViewCell * cell = [self.collectionContext dequeueReusableCellOfClass:[TopicCollectionViewCell class] forSectionController:self atIndex:index];
    self.adapter.collectionView = cell.collectionView;
    return cell;
}

- (void)didUpdateToObject:(id)object {
    self.topicObject = object;
}

#pragma mark - IGListAdapterDataSource
- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.topicObject.topics;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    return [PromoSectionController new];
}

- (IGListAdapter *)adapter {
    if (!_adapter) {
        _adapter = [[IGListAdapter alloc] initWithUpdater:[IGListAdapterUpdater new] viewController:self.viewController];
        _adapter.dataSource = self;
    }
    return _adapter;
}

@end
