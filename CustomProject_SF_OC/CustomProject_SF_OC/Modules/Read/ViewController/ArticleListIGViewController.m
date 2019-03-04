//
//  ArticleListIGViewController.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/28.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "ArticleListIGViewController.h"
//#import "RightImageArticleSectionController.h"
//#import "BigImageArticleSectionController.h"
#import "ArticleInfoModel.h"
#import "ArticleSectionController.h"

@interface ArticleListIGViewController ()

@end

@implementation ArticleListIGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithDictionary:[self.queryPara toDictionary]];
    [params setObject:@(self.columnsId) forKey:@"columns"];
    
    [NetworkHelper getWithUrl:ArticleColumnsList_API refreshRequest:YES cache:self.queryPara.page == 0 ? YES : NO params:params progressBlock:nil successBlock:^(NSDictionary * response, BOOL cache) {
        self.queryPara.singleStart = [[response objectForKey:@"singleStart"] integerValue];
        self.queryPara.bigStart = [[response objectForKey:@"bigStart"] integerValue];
        
        NSArray <ArticleInfoModel *> * data = [ArticleInfoModel arrayOfModelsFromDictionaries:response[@"clArticle"] error:nil];
        [self handleRequestResult:data cache:cache];
    } failBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark -
- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    if ([object isKindOfClass:[ArticleInfoModel class]]) {
        ArticleSectionController * vc =  [ArticleSectionController new];
        vc.columnsId = self.columnsId;
        return vc;
    }
    
    return nil;
}

/** 空数据页面 */
- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    return view;
}

@end
