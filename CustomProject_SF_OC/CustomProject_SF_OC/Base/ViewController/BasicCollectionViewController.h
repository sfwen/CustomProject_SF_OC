//
//  BasicCollectionViewController.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/15.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "BasicViewController.h"
#import "SFCollectionViewFlowLayout.h"
#import "BasicCollectionViewCell.h"

//列表模式
typedef NS_ENUM(NSInteger, CollectionMode){
    CollectionModeNormal = 0,//默认状态
    CollectionModeLong,//长款
};


@interface BasicCollectionViewController : BasicViewController <UICollectionViewDelegate, UICollectionViewDataSource, SFCollectionViewFlowLayoutDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (assign, nonatomic) CollectionMode collectionMode;//列表模式

- (void)registerCollectionViewCell;

@end
