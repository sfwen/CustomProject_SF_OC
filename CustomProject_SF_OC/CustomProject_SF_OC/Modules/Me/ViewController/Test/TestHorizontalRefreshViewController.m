//
//  TestHorizontalRefreshViewController.m
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/18.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "TestHorizontalRefreshViewController.h"
#import "BasicCollectionViewCell.h"

@interface TestHorizontalRefreshViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) UIView * loadMoreView;
@property (nonatomic, strong) UIActivityIndicatorView * indicatorView;

@end

@implementation TestHorizontalRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(20);
        make.height.mas_equalTo(190);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BasicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BasicCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = randomColor;
    return cell;
}

- (void)headerRefresh {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        // 检测左侧滑动，开始加载更多
        NSLog(@"scrollview.contentOffset.x-->%f \n scrollview.width-->%f \n scrollview.contentsize.width--%f", scrollView.contentOffset.x, scrollView.width, scrollView.contentSize.width);
        if (scrollView.contentOffset.x > 0 && scrollView.contentOffset.x + scrollView.width - scrollView.contentSize.width > 30) {
            NSLog(@"执行加载更多");
            
            scrollView.left = -30;
            
            if (self.indicatorView == nil) {
                UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(scrollView.width - 20, scrollView.top + scrollView.height/2 - 10, 20, 20)];
                indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
                indicatorView.hidesWhenStopped = YES;
                self.indicatorView = indicatorView;
                [self.indicatorView stopAnimating];
                [scrollView.superview addSubview:self.indicatorView];
            }
            
            if (!self.indicatorView.isAnimating) {
                [self.indicatorView startAnimating];
                [self loadMoreData];
            }
        }
    }
}

- (void)loadMoreData {
//    self.collectionView.left = -50;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.collectionView.left = 0;
        [self.indicatorView stopAnimating];
        
        NSLog(@"OK");
    });
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        // 布局
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(100, 180);
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = FlatWhite;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [self.view addSubview:_collectionView];
        
        [_collectionView registerClass:[BasicCollectionViewCell class] forCellWithReuseIdentifier:@"BasicCollectionViewCell"];
    }
    return _collectionView;
}

- (UIView *)loadMoreView {
    if (!_loadMoreView) {
        _loadMoreView = [[UIView alloc] init];
    }
    return _loadMoreView;
}

@end
