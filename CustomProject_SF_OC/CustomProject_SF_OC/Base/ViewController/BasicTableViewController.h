//
//  BasicTableViewController.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/6.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "BasicViewController.h"
#import "BasicCell.h"
#import "QueryPara.h"

typedef NS_ENUM(NSInteger, PullUpRefreshType) {
    PullUpRefreshType_Auto = 0,//默认 自动
    PullUpRefreshType_Block,
};

@interface BasicTableViewController : BasicViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) QueryPara *queryPara;

/**
 是否开启下拉刷新 默认为YES 开启
 */
@property (nonatomic, assign) BOOL openPullDownRefresh;
/**
 是否开启上拉刷新 默认为YES 开启
 */
@property (nonatomic, assign) BOOL openPullUpRefresh;

@property (nonatomic, assign) PullUpRefreshType pullUpRefreshType;

/** 数据处理 */
- (void)handleRequestResult:(NSArray *)data cache:(BOOL)cache;

- (NSString *)getReuseIdentifier;

@end
