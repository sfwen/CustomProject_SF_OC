//
//  BookReadDetailViewController.m
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/10.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "BookReadDetailViewController.h"
#import "BookReadViewController.h"
#import "ReadMenu.h"
#import "ReadBGController.h"
#import "ReadOperation.h"

/// 用于区分正反面的值(固定)
static int TempNumber = 1;

@interface BookReadDetailViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController * pageViewController;
/** 当前显示的阅读控制器 */
@property (nonatomic, strong) BookReadViewController * currentReadViewController;

@end

@implementation BookReadDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatPageController:[self.readOperation getCurrentReadViewController:YES isSave:YES]];
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

- (void)creatPageController:(BasicViewController *)displayController {
    // 清理
    if (self.pageViewController != nil) {
        [self.pageViewController.view removeFromSuperview];
        [self.pageViewController removeFromParentViewController];
        self.pageViewController = nil;
    }
    
    // 创建
    if ([ReadMenu sharedManager].effectType == RMEffectType_Simulation) { // 仿真
        /*
        仅在style为UIPageViewControllerTransitionStylePageCurl时有效;
        对应的值为NSNumber对象, 包含的数值也是一个枚举:
        typedef NS_ENUM(NSInteger, UIPageViewControllerSpineLocation) {
            UIPageViewControllerSpineLocationNone = 0, // Returned if 'spineLocation' is queried when 'transitionStyle' is not 'UIPageViewControllerTransitionStylePageCurl'.
            // 单页显示, 从上往下翻页
            UIPageViewControllerSpineLocationMin = 1,  // Requires one view controller.
            // 双页显示
            UIPageViewControllerSpineLocationMid = 2,  // Requires two view controllers.
            // 单页显示, 从下往上翻
            UIPageViewControllerSpineLocationMax = 3   // Requires one view controller.
        };   // Only pertains to 'UIPageViewControllerTransitionStylePageCurl'.
         */
        
        NSDictionary * options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
        self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        
        self.pageViewController.delegate = self;
        self.pageViewController.dataSource = self;
        
        // 为了翻页背面的颜色使用
        self.pageViewController.doubleSided = YES;
        
        [self.view insertSubview:self.pageViewController.view atIndex:0];
        [self addChildViewController:self.pageViewController];
        
        [self.pageViewController setViewControllers:displayController != nil ? @[displayController] : nil direction:(UIPageViewControllerNavigationDirectionForward) animated:NO completion:nil];
    } else { // 无效果 覆盖 上下
        
    }
    self.currentReadViewController = (BookReadViewController *)displayController;
}

- (ReadBGController *)readBGController:(UIView *)targetView {
    ReadBGController * vc = [[ReadBGController alloc] init];
    vc.targetView = targetView ? targetView : [self.readOperation getCurrentReadViewController:NO isSave:NO].view;
    return vc;
}

#pragma mark - UIPageViewControllerDataSource
/// 获取上一页
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    TempNumber -= 1;
    if (abs(TempNumber) % 2 == 0) { // 背面
        return [self readBGController:nil];
    } else { // 内容
        return [self.readOperation getAboveReadViewController];
    }
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    TempNumber += 1;
    if (abs(TempNumber) % 2 == 0) {
        return [self readBGController:nil];
    } else {
        return [self.readOperation getBelowReadViewController];
    }
}

#pragma mark - UIPageViewControllerDelegate
/// 准备切换
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    // 更新阅读记录
    [self.readOperation readRecordUpdateWithReadViewController:(BookReadViewController *)pageViewController.viewControllers.firstObject isSave:NO];
}

/// 切换结果
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        // 记录
        self.currentReadViewController = pageViewController.viewControllers.firstObject;
        
        // 更新阅读记录
        [self.readOperation readRecordUpdateWithReadViewController:self.currentReadViewController isSave:YES];
        
        // 更新进度条
    } else {
        // 记录
        self.currentReadViewController = (BookReadViewController *)(previousViewControllers.firstObject);
        
        // 更新阅读记录
        [self.readOperation readRecordUpdateWithReadViewController:self.currentReadViewController isSave:YES];
    }
}

- (ReadOperation *)readOperation {
    if (!_readOperation) {
        _readOperation = [[ReadOperation alloc] initWithVc:self];
    }
    return _readOperation;
}

@end
