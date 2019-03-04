//
//  PushHelper.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/27.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "PushHelper.h"
#import "ArticleDetailViewController.h"
#import "GoodsDetailViewController.h"

#import "BookReadDetailViewController.h"
#import "ReadParser.h"

@interface PushHelper ()

//@property (nonatomic, strong) UINavigationController * navigationController;

@end

@implementation PushHelper

+ (void)toArticleDetailWithColumnID:(NSInteger)columnID articleID:(NSInteger)articleID {
    ArticleDetailViewController * vc = [[ArticleDetailViewController alloc] init];
    vc.columnID = columnID;
    vc.articleID = articleID;
    [[self currentNC] pushViewController:vc animated:YES];
}

+ (void)toGoodsDetailWtihID:(NSString *)goodsID {
//    GoodsDetailViewController * vc = [[GoodsDetailViewController alloc] init];
    GoodsDetailViewController * vc = [GoodsDetailViewController suspendTopPausePageVC];
    [[self currentNC] pushViewController:vc animated:YES];
}

+ (void)toBookDetail {
    NSURL * url = [[NSBundle mainBundle] URLForResource:@"求魔" withExtension:@"txt"];
    ReadModel * model = [ReadParser mainThreadParserLocalURL:url];
    
    BookReadDetailViewController * vc = [[BookReadDetailViewController alloc] init];
    vc.readModel = model;
    [[self currentNC] pushViewController:vc animated:YES];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
//    });
}

+ (UINavigationController *)currentNC {
    if (![[UIApplication sharedApplication].windows.lastObject isKindOfClass:[UIWindow class]]) {
        NSAssert(0, @"未获取到导航控制器");
        return nil;
    }
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self getCurrentNCFrom:rootViewController];
}

//递归
+ (UINavigationController *)getCurrentNCFrom:(UIViewController *)vc {
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UINavigationController *nc = ((UITabBarController *)vc).selectedViewController;
        return [self getCurrentNCFrom:nc];
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        if (((UINavigationController *)vc).presentedViewController) {
            return [self getCurrentNCFrom:((UINavigationController *)vc).presentedViewController];
        }
        return [self getCurrentNCFrom:((UINavigationController *)vc).topViewController];
    } else if ([vc isKindOfClass:[UIViewController class]]) {
        if (vc.presentedViewController) {
            return [self getCurrentNCFrom:vc.presentedViewController];
        } else {
            return vc.navigationController;
        }
    } else {
        NSAssert(0, @"未获取到导航控制器");
        return nil;
    }
}

@end
