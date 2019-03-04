//
//  ArticleMainViewController.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/6.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "ArticleMainViewController.h"
#import <TYPagerController/TYPagerController.h>
#import <TYPagerController/TYTabPagerBar.h>
//#import "ArticleListViewController.h"
#import "ArticleListIGViewController.h"

#import "ArticleColumnModel.h"

@interface ArticleMainViewController () <TYTabPagerBarDataSource, TYTabPagerBarDelegate, TYPagerControllerDataSource, TYPagerControllerDelegate>
/**
 顶部标签导航
 */
@property (nonatomic, strong) TYTabPagerBar * tabBar;
/**
 tabbar底部的线条
 */
@property (nonatomic, strong) UIView * lineBottomToTabBar;

/**
 页面控制器
 */
@property (nonatomic, strong) TYPagerController * pagerController;

@end

@implementation ArticleMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.tabBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset([Tools sharedManager].isNeatBang ? 44 : 20);//44 刘海为44 
        make.height.mas_equalTo(44);
    }];
    
    [self.pagerController.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.tabBar.mas_bottom);
    }];
}

#pragma mark - TYTabPagerBarDataSource
- (NSInteger)numberOfItemsInPagerTabBar {
    return self.contentArray.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    if (self.contentArray.count > 0) {
        ArticleColumnModel * model = [self.contentArray objectAtIndex:index];
        cell.titleLabel.text = model.title;
    }
    
    return cell;
}

#pragma mark - TYTabPagerBarDelegate
- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    ArticleColumnModel * model = [self.contentArray objectAtIndex:index];
    return [pagerTabBar cellWidthForTitle:model.title];
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [self.pagerController scrollToControllerAtIndex:index animate:YES];
}

#pragma mark - TYPagerControllerDataSource
- (NSInteger)numberOfControllersInPagerController {
    return self.contentArray.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    ArticleColumnModel * model = [self.contentArray objectAtIndex:index];
    ArticleListIGViewController *vc = [[ArticleListIGViewController alloc] init];
    vc.columnsId = model.columnsId;
    return vc;
}

#pragma mark - TYPagerControllerDelegate
- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [self.tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [self.tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

#pragma mark - Base Method
- (void)loadData {
    [NetworkHelper getWithUrl:ReadColumnsList_API refreshRequest:YES cache:YES params:nil progressBlock:nil successBlock:^(NSDictionary * response, BOOL cache) {
        NSArray * arr = [ArticleColumnModel arrayOfModelsFromDictionaries:response[@"data"] error:nil];
        [self.contentArray removeAllObjects];
        [self.contentArray addObjectsFromArray:arr];
        [self reloadData];
    } failBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - Custom Method
- (void)reloadData {
    [self.tabBar reloadData];
    [self.pagerController reloadData];
}

#pragma mark - 懒加载
- (TYTabPagerBar *)tabBar {
    if (!_tabBar) {
        _tabBar = [[TYTabPagerBar alloc] init];
        _tabBar.layout.barStyle = TYPagerBarStyleProgressView;
        _tabBar.layout.normalTextFont = APPFONT(16);
        _tabBar.layout.selectedTextFont = APPFONT(20);
        _tabBar.dataSource = self;
        _tabBar.delegate = self;
        [_tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
        [self.view addSubview:_tabBar];
    }
    return _tabBar;
}

- (UIView *)lineBottomToTabBar {
    if (!_lineBottomToTabBar) {
        _lineBottomToTabBar = [[UIView alloc] init];
    }
    return _lineBottomToTabBar;
}

- (TYPagerController *)pagerController {
    if (!_pagerController) {
        _pagerController = [[TYPagerController alloc] init];
        _pagerController.layout.prefetchItemCount = 1;
        _pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
        _pagerController.dataSource = self;
        _pagerController.delegate = self;
        [self addChildViewController:_pagerController];
        [self.view addSubview:_pagerController.view];
    }
    return _pagerController;
}

@end
