//
//  BasicTableViewController.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/6.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "BasicTableViewController.h"


@interface BasicTableViewController () 

@end

@implementation BasicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.openPullUpRefresh = YES;
    self.openPullDownRefresh = YES;
    [self registerTableViewCell];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.top.bottom.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BasicCell * cell = [tableView dequeueReusableCellWithIdentifier:[self getReuseIdentifier]];
    if (!cell) {
        cell = [[BasicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self getReuseIdentifier]];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(BasicCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.contentArray.count && self.tableView.animatedStyle != TABTableViewAnimationStart) {
        [cell configCellData:self.contentArray[indexPath.row]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - Base Method
- (NSString *)getReuseIdentifier {
    return @"BasicCell";
}

- (void)registerTableViewCell {
    [self.tableView registerClass:NSClassFromString([self getReuseIdentifier]) forCellReuseIdentifier:[self getReuseIdentifier]];
}

- (void)handleRequestResult:(NSArray *)data cache:(BOOL)cache {
    if (self.queryPara.page == 0) {
        NSLog(@"执行了");
        [self.contentArray removeAllObjects];
        [self.tableView.mj_header setState:MJRefreshStateIdle];
    }
    if (data.count > 0) {
        if (!cache) {
            self.queryPara.page++;
        }
        
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSInteger index = [self.contentArray indexOfObject:obj];
            if ([self.contentArray containsObject:obj]) {
                NSLog(@"存在了");
            }
        }];
        
        [self.contentArray addObjectsFromArray:data];
        if (self.tableView.mj_header.state != MJRefreshStateIdle) {
            [self.tableView.mj_header endRefreshing];
        }
        if (self.tableView.mj_footer.state != MJRefreshStateIdle) {
            [self.tableView.mj_footer endRefreshing];
        }
    } else {
        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
    }
    
    self.tableView.animatedStyle = TABTableViewAnimationEnd;
    [self.tableView reloadData];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        /** 开启动画 */
        _tableView.animatedStyle = TABTableViewAnimationStart;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        /** 去掉分割线 */
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        /** 去除tableview 右侧滚动条 */
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
        
        if (self.openPullDownRefresh) {
            _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                self.queryPara = nil;
                [self loadData];
            }];
        }
        
        if (self.openPullUpRefresh) {
            if (self.pullUpRefreshType == PullUpRefreshType_Auto) {
                _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
                    [self loadData];
                }];
            } else if (self.pullUpRefreshType == PullUpRefreshType_Block) {
                _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
                    [self loadData];
                }];
            }
        }
    }
    return _tableView;
}

- (QueryPara *)queryPara {
    if (!_queryPara) {
        _queryPara = [[QueryPara alloc] init];
    }
    return _queryPara;
}


@end
