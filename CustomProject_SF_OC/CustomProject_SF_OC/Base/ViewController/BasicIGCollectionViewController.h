//
//  BasicIGCollectionViewController.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/20.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicIGCollectionViewController : BasicViewController <IGListAdapterDataSource>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) IGListAdapter    * adapter;

@property (nonatomic, strong) QueryPara *queryPara;

/**
 是否开启下拉刷新 默认为YES 开启
 */
@property (nonatomic, assign) BOOL openPullDownRefresh;
/**
 是否开启上拉刷新 默认为YES 开启
 */
@property (nonatomic, assign) BOOL openPullUpRefresh;

/** 是否锁定头部 */
@property (nonatomic, assign) BOOL shouldStickHeader;

@property (nonatomic, assign) PullUpRefreshType pullUpRefreshType;

/** 数据处理 */
- (void)handleRequestResult:(NSArray *)data cache:(BOOL)cache;

@end
