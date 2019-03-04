//
//  ArticleListViewController.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/11.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "ArticleListViewController.h"
#import "ArticleCell.h"
#import "ArticleInfoModel.h"
#import "ArticleDetailViewController.h"

@interface ArticleListViewController ()

@end

@implementation ArticleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.contentArray.count) {
        ArticleInfoModel * model = [self.contentArray objectAtIndex:indexPath.row];
        return model.cellHeight;
    }
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleInfoModel * model = [self.contentArray objectAtIndex:indexPath.row];
    [PushHelper toArticleDetailWithColumnID:self.columnsId articleID:model.article_id];
//    ArticleDetailViewController * vc = [[ArticleDetailViewController alloc] init];
//    vc.columnID = self.columnsId;
//    vc.articleID = model.article_id;
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Base Method
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


//获取将要旋转的状态
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    NSLog(@"旋转了");
    [self.tableView reloadData];
}

- (NSString *)getReuseIdentifier {
    return @"ArticleCell";
}

@end
