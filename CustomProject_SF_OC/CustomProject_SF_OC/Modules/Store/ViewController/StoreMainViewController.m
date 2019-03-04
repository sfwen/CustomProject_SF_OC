//
//  StoreMainViewController.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/6.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "StoreMainViewController.h"
#import "StoreMainModel.h"
#import "AdSectionController.h"
#import "BannerSectionController.h"
#import "MenuSectionController.h"
#import "TopicSectionController.h"
#import "GoodsSectionController.h"
#import "GoodsObject.h"

@interface StoreMainViewController ()

@end

@implementation StoreMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.adapter.scrollViewDelegate = self;
//    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    self.openPullUpRefresh = NO;
    self.openPullDownRefresh = NO;
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


#pragma mark - Base Method
- (void)loadData {
    [NetworkHelper body_getWithUrl:StoreGetMainData_API refreshRequest:YES cache:YES params:nil progressBlock:nil successBlock:^(id response, BOOL cache) {
        StoreMainModel * model = [[StoreMainModel alloc] initWithDictionary:response[@"data"] error:nil];
        
        [self.contentArray removeAllObjects];
        
        //添加banner
        [self.contentArray addObject:model.banner];
        //添加广告
        if (model.advertising) {
            [self.contentArray addObject:model.advertising];
        }
        
        //添加菜单
        MenuListObject * menuObject = [[MenuListObject alloc] init];
        menuObject.menus = model.menus;
        [self.contentArray addObject:menuObject];
        
        //添加
        TopicObject * topicObject = [[TopicObject alloc] init];
        topicObject.topics = model.topics;
        [self.contentArray addObject:topicObject];
        
        //添加广告
        AdvertisingModel * adModel = [[AdvertisingModel alloc] initWithDictionary:[model.advertising toDictionary] error:nil];
        [self.contentArray addObject:adModel];
        
        [self loadGoodsData];
        
    } failBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)loadGoodsData {
    NSString * url = [NSString stringWithFormat:@"%@%@", kBasicURL_Store, LoadAllGoodsList_API];
    [NetworkHelper getWithUrl:url refreshRequest:YES cache:NO params:@{@"pageIndex" : @(self.queryPara.page)} progressBlock:nil successBlock:^(id response, BOOL cache) {
        NSMutableArray * arr = [GoodsInfoModel arrayOfModelsFromDictionaries:response[@"data"] error:nil];
        GoodsObject * goodsObject = [[GoodsObject alloc] init];
        goodsObject.goodsDataArray = arr;
        [self.contentArray addObject:goodsObject];
        
        //更新数据
        [self.adapter performUpdatesAnimated:YES completion:nil];
    } failBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark -
- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    if ([object isKindOfClass:[AdvertisingModel class]]) {
        return [AdSectionController new];
    } else if ([object isKindOfClass:[BannerModel class]]) {
        return [BannerSectionController new];
    } else if ([object isKindOfClass:[MenuListObject class]]) {
        return [MenuSectionController new];
    } else if ([object isKindOfClass:[TopicObject class]]) {
        return [TopicSectionController new];
    } else if ([object isKindOfClass:[GoodsObject class]]) {
        return [GoodsSectionController new];
    }
    
    return nil;
}

/** 空数据页面 */
- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    return view;
}

//获取将要旋转的状态
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self.adapter performUpdatesAnimated:NO completion:nil];
}

@end
