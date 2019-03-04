//
//  BasicIGCollectionViewController.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/20.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "BasicIGCollectionViewController.h"

@interface BasicIGCollectionViewController ()

@end

@implementation BasicIGCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.openPullUpRefresh = YES;
    self.openPullDownRefresh = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleRequestResult:(NSArray *)data cache:(BOOL)cache {
    if (self.queryPara.page == 0) {
        NSLog(@"执行了");
        [self.contentArray removeAllObjects];
        [self.collectionView.mj_header setState:MJRefreshStateIdle];
    }
    if (data.count > 0) {
        if (!cache) {
            self.queryPara.page++;
        }
        
        [self.contentArray addObjectsFromArray:data];
        if (self.collectionView.mj_header.state != MJRefreshStateIdle) {
            [self.collectionView.mj_header endRefreshing];
        }
        if (self.collectionView.mj_footer.state != MJRefreshStateIdle) {
            [self.collectionView.mj_footer endRefreshing];
        }
    } else {
        [self.collectionView.mj_footer setState:MJRefreshStateNoMoreData];
    }
    
    self.collectionView.animatedStyle = TABTableViewAnimationEnd;
    [self.adapter performUpdatesAnimated:YES completion:nil];
}

#pragma mark - IGListAdapterDataSource
- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.contentArray;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    return nil;
}

//获取将要旋转的状态
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    NSLog(@"旋转了");
    [self.collectionView reloadData];
//    [self.adapter performUpdatesAnimated:NO completion:nil];
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        if (self.shouldStickHeader) {
            IGListCollectionViewLayout * flowLayout = [[IGListCollectionViewLayout alloc] initWithStickyHeaders:YES scrollDirection:UICollectionViewScrollDirectionVertical topContentInset:0 stretchToEdge:NO];
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        } else {
            UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
//            flowLayout.sectionHeadersPinToVisibleBounds
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        }
        
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_collectionView];
        
        if (self.openPullDownRefresh) {
            _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                self.queryPara = nil;
                [self loadData];
            }];
        }
        
        if (self.openPullUpRefresh) {
            if (self.pullUpRefreshType == PullUpRefreshType_Auto) {
                _collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
                    [self loadData];
                }];
            } else if (self.pullUpRefreshType == PullUpRefreshType_Block) {
                _collectionView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
                    [self loadData];
                }];
            }
        }
    }
    return _collectionView;
}

- (IGListAdapter *)adapter {
    if (!_adapter) {
        _adapter = [[IGListAdapter alloc] initWithUpdater:[IGListAdapterUpdater new] viewController:self];
        _adapter.dataSource = self;
        _adapter.collectionView = self.collectionView;
    }
    return _adapter;
}

- (QueryPara *)queryPara {
    if (!_queryPara) {
        _queryPara = [[QueryPara alloc] init];
    }
    return _queryPara;
}

@end
