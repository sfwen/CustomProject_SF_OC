//
//  AppDelegate.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/6.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarConrollerConfig.h"
#import "ServiceModule.h"
#import "ServiceMediator.h"
#import "FPSDisplay.h"

@interface AppDelegate () <UITabBarControllerDelegate, CYLTabBarControllerDelegate>

@property (nonatomic, strong) TabBarConrollerConfig * tabBarConfig;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    JSObjectionInjector * injector = [JSObjection defaultInjector];
    NSObject <ServiceMediatorProtocol> * mediator = [injector getObject:@protocol(ServiceMediatorProtocol)];
    [mediator route];

    TabBarConrollerConfig * tabBarConfig = [[TabBarConrollerConfig alloc] init];
    tabBarConfig.tabBarController.delegate = self;
    self.tabBarConfig = tabBarConfig;
    self.window.rootViewController = tabBarConfig.tabBarController;
    
    [self.window makeKeyAndVisible];
    
    [FPSDisplay shareFPSDisplay];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

/// 程序已经进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"程序已经进入后台-applicationDidEnterBackground");
}

/// 程序进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"程序进入前台 - applicationWillEnterForeground");
}

/// 程序被激活 (挂起)
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"程序被激活 (挂起) - applicationDidBecomeActive");
//    [PushHelper toArticleDetailWithColumnID:135 articleID:244930];
}

/// 程序关闭时调用
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - UITabBarControllerDelegate
//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//    [[self cyl_tabBarController] updateSelectionStatusIfNeededForTabBarController:tabBarController shouldSelectViewController:viewController];
//    return YES;
//}

#pragma mark - CYLTabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control {
    [self.tabBarConfig tabBarController:tabBarController didSelectControl:control];
}

@end
