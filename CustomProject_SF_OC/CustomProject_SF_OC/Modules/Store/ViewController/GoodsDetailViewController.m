//
//  GoodsDetailViewController.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/27.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "BasicIGCollectionViewController.h"

@interface GoodsDetailViewController () <YNPageViewControllerDataSource, YNPageViewControllerDelegate>

@end

@implementation GoodsDetailViewController

+ (instancetype)suspendTopPausePageVC {
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleSuspensionTopPause;
    configration.headerViewCouldScale = YES;
    configration.showTabbar = NO;
    configration.showNavigation = NO;
    configration.scrollMenu = NO;
    configration.aligmentModeCenter = NO;
    configration.lineWidthEqualFontWidth = NO;
    configration.showBottomLine = YES;
    
    GoodsDetailViewController *vc = [GoodsDetailViewController pageViewControllerWithControllers:[self getArrayVCs]
                                                                                          titles:[self getArrayTitles]
                                                                                          config:configration];
    vc.dataSource = vc;
    vc.delegate = vc;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    headerView.layer.contents = (id)[UIImage imageWithColor:FlatBlue].CGImage;
    
    vc.headerView = headerView;
    /// 指定默认选择index 页面
    vc.pageIndex = 0;
    
    return vc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (NSArray *)getArrayVCs {
    
    BasicIGCollectionViewController *vc_1 = [[BasicIGCollectionViewController alloc] init];
    //    vc_1.cellTitle = @"鞋子1";
    
    BasicIGCollectionViewController *vc_2 = [[BasicIGCollectionViewController alloc] init];
//    vc_2.cellTitle = @"衣服";
    
    BasicIGCollectionViewController *vc_3 = [[BasicIGCollectionViewController alloc] init];
//    vc_3.cellTitle = @"帽子";
    return @[vc_1, vc_2, vc_3];
}

+ (NSArray *)getArrayTitles {
    return @[@"鞋子", @"衣服", @"帽子"];
}

#pragma mark - YNPageViewControllerDataSource
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    BasicIGCollectionViewController *vc = pageViewController.controllersM[index];
    
    return vc.collectionView;
}
#pragma mark - YNPageViewControllerDelegate
- (void)pageViewController:(YNPageViewController *)pageViewController
            contentOffsetY:(CGFloat)contentOffset
                  progress:(CGFloat)progress {
    NSLog(@"--- contentOffset = %f,    progress = %f", contentOffset, progress);
}


@end
