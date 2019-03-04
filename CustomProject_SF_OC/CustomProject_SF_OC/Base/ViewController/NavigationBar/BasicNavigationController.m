//
//  BasicNavigationController.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/6.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "BasicNavigationController.h"
#import "SFNavigationBar.h"


@interface BasicNavigationController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@property (nonatomic, readonly) SFNavigationBar *navigationBar;
@property (nonatomic, strong) UIVisualEffectView *fromFakeBar;
@property (nonatomic, strong) UIVisualEffectView *toFakeBar;
@property (nonatomic, strong) UIImageView *fromFakeShadow;
@property (nonatomic, strong) UIImageView *toFakeShadow;
@property (nonatomic, strong) UIImageView *fromFakeImageView;
@property (nonatomic, strong) UIImageView *toFakeImageView;
@property (nonatomic, weak) UIViewController *poppingViewController;

@end

@implementation BasicNavigationController

@dynamic navigationBar;

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithNavigationBarClass:[SFNavigationBar class] toolbarClass:nil]) {
        self.viewControllers = @[ rootViewController ];
    }
    return self;
}

- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass {
    NSAssert([navigationBarClass isSubclassOfClass:[SFNavigationBar class]], @"navigationBarClass Must be a subclass of SFNavigationBar");
    return [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass];
}

- (instancetype)init {
    return [super initWithNavigationBarClass:[SFNavigationBar class] toolbarClass:nil];
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setUpNavigationBarAppearance];
    self.interactivePopGestureRecognizer.delegate = self;
    [self.interactivePopGestureRecognizer addTarget:self action:@selector(handlePopGesture:)];
    self.delegate = self;
    [self.navigationBar setTranslucent:YES];
    [self.navigationBar setShadowImage:[UINavigationBar appearance].shadowImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    // 修复一个神奇的 BUG https://github.com/listenzz/HBDNavigationBar/issues/29
    self.topViewController.view.frame = self.topViewController.view.frame;
    
    id<UIViewControllerTransitionCoordinator> coordinator = self.transitionCoordinator;
    if (coordinator) {
        // 解决 ios 11 手势反弹的问题
        UIViewController *from = [coordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
        if (from == self.poppingViewController) {
            [self updateNavigationBarForViewController:from];
        }
    } else {
        // 再修复一个神奇的 BUG: https://github.com/listenzz/HBDNavigationBar/issues/31
        [self updateNavigationBarForViewController:self.topViewController];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count > 1) {
        return self.topViewController.sf_backInteractive && self.topViewController.sf_swipeBackEnabled;
    }
    return NO;
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    if (self.viewControllers.count > 1 && self.topViewController.navigationItem == item ) {
        if (!(self.topViewController.sf_backInteractive && self.topViewController.sf_clickBackEnabled)) {
            [self resetSubviewsInNavBar:self.navigationBar];
            return NO;
        }
    }
    return [super navigationBar:navigationBar shouldPopItem:item];
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.navigationBar.titleTextAttributes = viewController.sf_titleTextAttributes;
    self.navigationBar.barStyle = viewController.sf_barStyle;
    
    id<UIViewControllerTransitionCoordinator> coordinator = self.transitionCoordinator;
    if (coordinator) {
        [self showViewController:viewController withCoordinator:coordinator];
    } else {
        if (!animated && self.childViewControllers.count > 1) {
            UIViewController *lastButOne = self.childViewControllers[self.childViewControllers.count - 2];
            if (shouldShowFake(viewController, lastButOne, viewController)) {
                [self showFakeBarFrom:lastButOne to:viewController];
                return;
            }
        }
        [self updateNavigationBarForViewController:viewController];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!animated) {
        [self updateNavigationBarForViewController:viewController];
        [self clearFake];
    }
    self.poppingViewController = nil;
}


- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    self.poppingViewController = self.topViewController;
    UIViewController *vc = [super popViewControllerAnimated:animated];
    // vc != self.topViewController
    // 修复：ios 11 以上，当前后两个页面的 barStyle 不一样时，点击返回按钮返回，前一个页面的标题颜色响应迟缓或不响应
    self.navigationBar.barStyle = self.topViewController.sf_barStyle;
    self.navigationBar.titleTextAttributes = self.topViewController.sf_titleTextAttributes;
    return vc;
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.poppingViewController = self.topViewController;
    NSArray *array = [super popToViewController:viewController animated:animated];
    self.navigationBar.barStyle = self.topViewController.sf_barStyle;
    self.navigationBar.titleTextAttributes = self.topViewController.sf_titleTextAttributes;
    return array;
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    self.poppingViewController = self.topViewController;
    NSArray *array = [super popToRootViewControllerAnimated:animated];
    self.navigationBar.barStyle = self.topViewController.sf_barStyle;
    self.navigationBar.titleTextAttributes = self.topViewController.sf_titleTextAttributes;
    return array;
}


- (void)handlePopGesture:(UIScreenEdgePanGestureRecognizer *)recognizer {
    id<UIViewControllerTransitionCoordinator> coordinator = self.transitionCoordinator;
    UIViewController *from = [coordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *to = [coordinator viewControllerForKey:UITransitionContextToViewControllerKey];
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        self.navigationBar.tintColor = blendColor(from.sf_tintColor, to.sf_tintColor, coordinator.percentComplete);
    }
}

- (void)resetSubviewsInNavBar:(UINavigationBar *)navBar {
    if (@available(iOS 11, *)) {
    } else {
        // Workaround for >= iOS7.1. Thanks to @boliva - http://stackoverflow.com/posts/comments/34452906
        [navBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
            if (subview.alpha < 1.0) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.0;
                }];
            }
        }];
    }
}

- (void)resetButtonLabelInNavBar:(UINavigationBar *)navBar {
    if (@available(iOS 12.0, *)) {
        for (UIView *view in navBar.subviews) {
            NSString *viewName = [[[view classForCoder] description] stringByReplacingOccurrencesOfString:@"_" withString:@""];
            if ([viewName isEqualToString:@"UINavigationBarContentView"]) {
                [self resetButtonLabelInView:view];
                break;
            }
        }
    }
}

- (void)resetButtonLabelInView:(UIView *)view {
    NSString *viewName = [[[view classForCoder] description] stringByReplacingOccurrencesOfString:@"_" withString:@""];
    if ([viewName isEqualToString:@"UIButtonLabel"]) {
        view.alpha = 1.0;
    } else if (view.subviews.count > 0) {
        for (UIView *sub in view.subviews) {
            [self resetButtonLabelInView:sub];
        }
    }
}

- (void)printSubViews:(UIView *)view prefix:(NSString *)prefix {
    NSString *viewName = [[[view classForCoder] description] stringByReplacingOccurrencesOfString:@"_" withString:@""];
    NSLog(@"%@%@", prefix, viewName);
    if (view.subviews.count > 0) {
        for (UIView *sub in view.subviews) {
            [self printSubViews:sub prefix:[NSString stringWithFormat:@"--%@", prefix]];
        }
    }
}

- (void)updateNavigationBarForViewController:(UIViewController *)vc {
    [self updateNavigationBarAlphaForViewController:vc];
    [self updateNavigationBarColorOrImageForViewController:vc];
    [self updateNavigationBarShadowImageIAlphaForViewController:vc];
    [self updateNavigationBarAnimatedForViewController:vc];
}

- (void)updateNavigationBarAnimatedForViewController:(UIViewController *)vc {
    [UIView setAnimationsEnabled:NO];
    self.navigationBar.barStyle = vc.sf_barStyle;
    self.navigationBar.titleTextAttributes = vc.sf_titleTextAttributes;
    self.navigationBar.tintColor = vc.sf_tintColor;
    [UIView setAnimationsEnabled:YES];
}

- (void)updateNavigationBarAlphaForViewController:(UIViewController *)vc {
    if (vc.sf_computedBarImage) {
        self.navigationBar.fakeView.alpha = 0;
        self.navigationBar.backgroundImageView.alpha = vc.sf_barAlpha;
    } else {
        self.navigationBar.fakeView.alpha = vc.sf_barAlpha;
        self.navigationBar.backgroundImageView.alpha = 0;
    }
    self.navigationBar.shadowImageView.alpha = vc.sf_computedBarShadowAlpha;
}

- (void)updateNavigationBarColorOrImageForViewController:(UIViewController *)vc {
    self.navigationBar.barTintColor = vc.sf_computedBarTintColor;
    self.navigationBar.backgroundImageView.image = vc.sf_computedBarImage;
}

- (void)updateNavigationBarShadowImageIAlphaForViewController:(UIViewController *)vc {
    self.navigationBar.shadowImageView.alpha = vc.sf_computedBarShadowAlpha;
}

- (void)showViewController:(UIViewController * _Nonnull)viewController withCoordinator: (id<UIViewControllerTransitionCoordinator>)coordinator{
    UIViewController *from = [coordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *to = [coordinator viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // 修复一个系统 BUG https://github.com/listenzz/HBDNavigationBar/issues/35
    [self resetButtonLabelInNavBar:self.navigationBar];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
        BOOL shouldFake = shouldShowFake(viewController, from, to);
        if (shouldFake) {
            [self showViewControllerAlongsideTransition:viewController from:from to:to interactive:context.interactive];
        } else {
            [self showViewControllerAlongsideTransition:viewController interactive:context.interactive];
        }
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
        if (context.isCancelled) {
            [self updateNavigationBarForViewController:from];
        } else {
            // 当 present 时 to 不等于 viewController
            [self updateNavigationBarForViewController:viewController];
        }
        if (to == viewController) {
            [self clearFake];
        }
    }];
    
    if (coordinator.interactive) {
        if (@available(iOS 10.0, *)) {
            [coordinator notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                if (context.isCancelled) {
                    [self updateNavigationBarAnimatedForViewController:from];
                } else {
                    [self updateNavigationBarAnimatedForViewController:viewController];
                }
            }];
        } else {
            [coordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                if (context.isCancelled) {
                    [self updateNavigationBarAnimatedForViewController:from];
                } else {
                    [self updateNavigationBarAnimatedForViewController:viewController];
                }
            }];
        }
    }
}

- (void)showViewControllerAlongsideTransition:(UIViewController * _Nonnull)viewController interactive:(BOOL)interactive {
    self.navigationBar.titleTextAttributes = viewController.sf_titleTextAttributes;
    self.navigationBar.barStyle = viewController.sf_barStyle;
    if (!interactive) {
        self.navigationBar.tintColor = viewController.sf_tintColor;
    }
    
    [self updateNavigationBarAlphaForViewController:viewController];
    [self updateNavigationBarColorOrImageForViewController:viewController];
    [self updateNavigationBarShadowImageIAlphaForViewController:viewController];
}

- (void)showViewControllerAlongsideTransition:(UIViewController *)viewController from:(UIViewController *)from to:(UIViewController * _Nonnull)to interactive:(BOOL)interactive {
    // 标题样式，按钮颜色，barStyle
    self.navigationBar.titleTextAttributes = viewController.sf_titleTextAttributes;
    self.navigationBar.barStyle = viewController.sf_barStyle;
    if (!interactive) {
        self.navigationBar.tintColor = viewController.sf_tintColor;
    }
    // 背景透明度，背景颜色，阴影透明度
    [self showFakeBarFrom:from to:to];
}

- (void)showFakeBarFrom:(UIViewController *)from to:(UIViewController * _Nonnull)to {
    [UIView setAnimationsEnabled:NO];
    self.navigationBar.fakeView.alpha = 0;
    self.navigationBar.shadowImageView.alpha = 0;
    self.navigationBar.backgroundImageView.alpha = 0;
    [self showFakeBarFrom:from];
    [self showFakeBarTo:to];
    [UIView setAnimationsEnabled:YES];
}

- (void)showFakeBarFrom:(UIViewController *)from {
    self.fromFakeImageView.image = from.sf_computedBarImage;
    self.fromFakeImageView.alpha = from.sf_barAlpha;
    self.fromFakeImageView.frame = [self fakeBarFrameForViewController:from];
    [from.view addSubview:self.fromFakeImageView];
    
    self.fromFakeBar.subviews.lastObject.backgroundColor = from.sf_computedBarTintColor;
    self.fromFakeBar.alpha = from.sf_barAlpha == 0 || from.sf_computedBarImage ? 0.01:from.sf_barAlpha;
    if (from.sf_barAlpha == 0 || from.sf_computedBarImage) {
        self.fromFakeBar.subviews.lastObject.alpha = 0.01;
    }
    self.fromFakeBar.frame = [self fakeBarFrameForViewController:from];
    [from.view addSubview:self.fromFakeBar];
    
    self.fromFakeShadow.alpha = from.sf_computedBarShadowAlpha;
    self.fromFakeShadow.frame = [self fakeShadowFrameWithBarFrame:self.fromFakeBar.frame];
    [from.view addSubview:self.fromFakeShadow];
}

- (void)showFakeBarTo:(UIViewController * _Nonnull)to {
    self.toFakeImageView.image = to.sf_computedBarImage;
    self.toFakeImageView.alpha = to.sf_barAlpha;
    self.toFakeImageView.frame = [self fakeBarFrameForViewController:to];
    [to.view addSubview:self.toFakeImageView];
    
    self.toFakeBar.subviews.lastObject.backgroundColor = to.sf_computedBarTintColor;
    self.toFakeBar.alpha = to.sf_computedBarImage ? 0 : to.sf_barAlpha;
    self.toFakeBar.frame = [self fakeBarFrameForViewController:to];
    [to.view addSubview:self.toFakeBar];
    
    self.toFakeShadow.alpha = to.sf_computedBarShadowAlpha;
    self.toFakeShadow.frame = [self fakeShadowFrameWithBarFrame:self.toFakeBar.frame];
    [to.view addSubview:self.toFakeShadow];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    } else {
        viewController.hidesBottomBarWhenPushed = NO;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIVisualEffectView *)fromFakeBar {
    if (!_fromFakeBar) {
        _fromFakeBar = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    }
    return _fromFakeBar;
}

- (UIVisualEffectView *)toFakeBar {
    if (!_toFakeBar) {
        _toFakeBar = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    }
    return _toFakeBar;
}

- (UIImageView *)fromFakeImageView {
    if (!_fromFakeImageView) {
        _fromFakeImageView = [[UIImageView alloc] init];
    }
    return _fromFakeImageView;
}

- (UIImageView *)toFakeImageView {
    if (!_toFakeImageView) {
        _toFakeImageView = [[UIImageView alloc] init];
    }
    return _toFakeImageView;
}

- (UIImageView *)fromFakeShadow {
    if (!_fromFakeShadow) {
        _fromFakeShadow = [[UIImageView alloc] initWithImage:self.navigationBar.shadowImageView.image];
        _fromFakeShadow.backgroundColor = self.navigationBar.shadowImageView.backgroundColor;
    }
    return _fromFakeShadow;
}

- (UIImageView *)toFakeShadow {
    if (!_toFakeShadow) {
        _toFakeShadow = [[UIImageView alloc] initWithImage:self.navigationBar.shadowImageView.image];
        _toFakeShadow.backgroundColor = self.navigationBar.shadowImageView.backgroundColor;
    }
    return _toFakeShadow;
}

- (void)clearFake {
    [_fromFakeBar removeFromSuperview];
    [_toFakeBar removeFromSuperview];
    [_fromFakeShadow removeFromSuperview];
    [_toFakeShadow removeFromSuperview];
    [_fromFakeImageView removeFromSuperview];
    [_toFakeImageView removeFromSuperview];
    _fromFakeBar = nil;
    _toFakeBar = nil;
    _fromFakeShadow = nil;
    _toFakeShadow = nil;
    _fromFakeImageView = nil;
    _toFakeImageView = nil;
}

- (CGRect)fakeBarFrameForViewController:(UIViewController *)vc {
    UIView *back = self.navigationBar.subviews[0];
    CGRect frame = [self.navigationBar convertRect:back.frame toView:vc.view];
    frame.origin.x = vc.view.frame.origin.x;
    //  解决根视图为scrollView的时候，Push不正常
    if ([vc.view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollview = (UIScrollView *)vc.view;
        //  适配iPhoneX iPhoneXR
        NSArray *xrs =@[ @812, @896 ];
        BOOL isIPhoneX = [xrs containsObject:@([UIScreen mainScreen].bounds.size.height)];
        if (scrollview.contentOffset.y == 0) {
            frame.origin.y = -(isIPhoneX ? 88 : 64);
        }
    }
    return frame;
}

- (CGRect)fakeShadowFrameWithBarFrame:(CGRect)frame {
    return CGRectMake(frame.origin.x, frame.size.height + frame.origin.y - 0.5, frame.size.width, 0.5);
}

BOOL shouldShowFake(UIViewController *vc,UIViewController *from, UIViewController *to) {
    if (vc != to ) {
        return NO;
    }
    
    if (from.sf_computedBarImage && to.sf_computedBarImage && isImageEqual(from.sf_computedBarImage, to.sf_computedBarImage)) {
        // 都有图片，并且是同一张图片
        if (ABS(from.sf_barAlpha - to.sf_barAlpha) > 0.1) {
            return YES;
        }
        return NO;
    }
    
    if (!from.sf_computedBarImage && !to.sf_computedBarImage && [from.sf_computedBarTintColor.description isEqual:to.sf_computedBarTintColor.description]) {
        // 都没图片，并且颜色相同
        if (ABS(from.sf_barAlpha - to.sf_barAlpha) > 0.1) {
            return YES;
        }
        return NO;
    }
    
    return YES;
}

BOOL isImageEqual(UIImage *image1, UIImage *image2) {
    if (image1 == image2) {
        return YES;
    }
    if (image1 && image2) {
        NSData *data1 = UIImagePNGRepresentation(image1);
        NSData *data2 = UIImagePNGRepresentation(image2);
        BOOL result = [data1 isEqual:data2];
        return result;
    }
    return NO;
}

UIColor* blendColor(UIColor *from, UIColor *to, float percent) {
    CGFloat fromRed = 0;
    CGFloat fromGreen = 0;
    CGFloat fromBlue = 0;
    CGFloat fromAlpha = 0;
    [from getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
    
    CGFloat toRed = 0;
    CGFloat toGreen = 0;
    CGFloat toBlue = 0;
    CGFloat toAlpha = 0;
    [to getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
    
    CGFloat newRed =  fromRed + (toRed - fromRed) * fminf(1, percent * 4) ;
    CGFloat newGreen = fromGreen + (toGreen - fromGreen) * fminf(1, percent * 4);
    CGFloat newBlue = fromBlue + (toBlue - fromBlue) * fminf(1, percent * 4);
    CGFloat newAlpha = fromAlpha + (toAlpha - fromAlpha) * fminf(1, percent * 4);
    return [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:newAlpha];
}

@end

///** 设置navigationBar样式 */
//- (void)setUpNavigationBarAppearance {
//    UINavigationBar *navigationBarAppearance = self.navigationBar;
//
//    UIImage *backgroundImage = nil;
//    NSDictionary *textAttributes = nil;
//    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
//        backgroundImage = [UIImage imageNamed:@"navigationbar_background_tall"];
//
//        textAttributes = @{
//                           NSFontAttributeName : [UIFont boldSystemFontOfSize:18],
//                           NSForegroundColorAttributeName : [UIColor blackColor],
//                           };
//    } else {
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
//        backgroundImage = [UIImage imageNamed:@"navigationbar_background_tall"];
//        textAttributes = @{
//                           UITextAttributeFont : [UIFont boldSystemFontOfSize:18],
//                           UITextAttributeTextColor : [UIColor blackColor],
//                           UITextAttributeTextShadowColor : [UIColor clearColor],
//                           UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero],
//                           };
//#endif
//    }
//
//    [navigationBarAppearance setBackgroundImage:backgroundImage
//                                  forBarMetrics:UIBarMetricsDefault];
//    [navigationBarAppearance setTitleTextAttributes:textAttributes];
//
//}
//
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if (self.viewControllers.count > 0) {
//        viewController.hidesBottomBarWhenPushed = YES;
//    } else {
//        viewController.hidesBottomBarWhenPushed = NO;
//    }
//    [super pushViewController:viewController animated:animated];
//}
//
//@end

