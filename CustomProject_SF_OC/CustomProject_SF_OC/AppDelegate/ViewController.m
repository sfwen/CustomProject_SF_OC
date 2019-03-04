//
//  ViewController.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/6.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "ViewController.h"
#import "MeMainViewController.h"
#import "StoreMainViewController.h"
#import "ArticleMainViewController.h"

//static CGFloat const CYLTabBarControllerHeight = 40.f;

@interface ViewController () {
    BOOL _firstApper;
}

@end

@implementation ViewController

- (instancetype)init {
    self = [super init];//[super initWithViewControllers:[self viewControllers] tabBarItemsAttributes:[self tabBarItemsAttributes]];
    if (self) {
        CYLTabBarController * tabBarController = [[CYLTabBarController alloc] initWithViewControllers:[self viewControllers] tabBarItemsAttributes:[self tabBarItemsAttributesForController]];
        //隐藏tabBarController的背景颜色
//        [tabBarController hideTabBadgeBackgroundSeparator];
        //设置选中的颜色
        [tabBarController setTintColor:[UIColor redColor]];
        self = (ViewController *)tabBarController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _firstApper = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    if (!_firstApper) {
        _firstApper = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    [[self cyl_tabBarController] updateSelectionStatusIfNeededForTabBarController:tabBarController shouldSelectViewController:viewController];
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control {
    NSLog(@"点击了");
}

#pragma mark - 初始化数据
- (NSArray *)viewControllers {
    ArticleMainViewController * articleVC = [[ArticleMainViewController alloc] init];
    BasicNavigationController * articleNav = [[BasicNavigationController alloc] initWithRootViewController:articleVC];
    
    StoreMainViewController * storeVC = [[StoreMainViewController alloc] init];
    BasicNavigationController * storeNav = [[BasicNavigationController alloc] initWithRootViewController:storeVC];
    
    MeMainViewController * meVC = [[MeMainViewController alloc] init];
    BasicNavigationController * meNav = [[BasicNavigationController alloc] initWithRootViewController:meVC];
    
    NSArray * viewControllers = @[articleNav, storeNav, meNav];
    return viewControllers;
}

- (NSArray *)tabBarItemsAttributesForController {
    NSDictionary *articleTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"阅读",
                                                 CYLTabBarItemImage : @"t_read_n",  /* NSString and UIImage are supported*/
                                                 CYLTabBarItemSelectedImage : @"t_read_d"  /* NSString and UIImage are supported*/
                                                 };
    
    NSDictionary *storeTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"商城",
                                                  CYLTabBarItemImage : @"t_store_n",
                                                  CYLTabBarItemSelectedImage : @"t_store_d"
                                                  };
    
    NSDictionary *meTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"我",
                                                 CYLTabBarItemImage : @"t_person_n",
                                                 CYLTabBarItemSelectedImage : @"t_person_d"
                                                 };
    
    NSArray *tabBarItemsAttributes = @[
                                       articleTabBarItemsAttributes,
                                       storeTabBarItemsAttributes,
                                       meTabBarItemsAttributes
                                       ];
    return tabBarItemsAttributes;
}


@end
