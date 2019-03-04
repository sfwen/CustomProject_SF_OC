//
//  BookReadViewController.m
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/12.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "BookReadViewController.h"
#import "ReadConfigure.h"
#import "BookReadViewCell.h"
#import "ReadView.h"
#import "ReadOperation.h"

@interface BookReadViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, weak) ReadView * readView;

/// 记录当前已经加载或正在加载的章节列表 以免重复操作
@property (nonatomic, strong) NSMutableArray * willLoadDataArray;

/// 正在拖动
@property (nonatomic, assign) BOOL isDragging;

/// 顶部状态栏
@property (nonatomic, strong) UILabel * topStatusView;

@end

@implementation BookReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = FlatGreen;
    
    self.isDragging = NO;
    
    self.topStatusView.text = self.readRecordModel.readChapterModel.name;
    
    if ([ReadConfigure shareInstance].effectType == RMEffectType_UpAndDown && self.readRecordModel.readChapterModel != nil) {
        [self.contentArray appendObject:self.readRecordModel.readChapterModel.id];
        [self.willLoadDataArray appendObject:self.readRecordModel.readChapterModel.id];
    }
    
    [self configureReadEffect];
    [self configureReadRecordModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 配置信息
/// 配置阅读效果
- (void)configureReadEffect {
    if ([ReadConfigure shareInstance].effectType != RMEffectType_UpAndDown) {
        self.tableView.scrollEnabled = NO;
        self.tableView.clipsToBounds = NO;
    } else {
        self.tableView.scrollEnabled = YES;
        self.tableView.clipsToBounds = YES;
    }
}

- (void)configureReadRecordModel {
    if ([ReadConfigure shareInstance].effectType == RMEffectType_UpAndDown) {
        self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, self.readRecordModel.page * self.tableView.height);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([ReadConfigure shareInstance].effectType != RMEffectType_UpAndDown) { // 非上下滚动
        return 1;
    } else {
        return self.contentArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([ReadConfigure shareInstance].effectType != RMEffectType_UpAndDown) {
        return 1;
    } else {
        ReadChapterModel * readChapterModel = [ReadChapterModel readChapterModelWithBookID:self.readRecordModel.bookID chapterID:self.contentArray[section] isUpdateFont:YES];
        return readChapterModel.pageCount;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookReadViewCell * cell = [BookReadViewCell cellWithTableView:tableView];
    
    if ([ReadConfigure shareInstance].effectType != RMEffectType_UpAndDown) {
        NSMutableAttributedString * content = [self.readRecordModel.readChapterModel stringAttrWithPage:self.readRecordModel.page];
        cell.content = content;
        self.readView = cell.readView;
    } else {
        ReadChapterModel * readChapterModel = [ReadChapterModel readChapterModelWithBookID:self.readRecordModel.bookID chapterID:self.contentArray[indexPath.section] isUpdateFont:YES];
        NSMutableAttributedString * attr = [readChapterModel stringAttrWithPage:indexPath.row];
        cell.content = attr;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([ReadConfigure shareInstance].effectType == RMEffectType_UpAndDown) {
        // 获得当前模型
        ReadChapterModel * readChapterModel = [ReadChapterModel readChapterModelWithBookID:self.readRecordModel.bookID chapterID:self.contentArray[section] isUpdateFont:YES];
        [self reloadDataArray:readChapterModel];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ScreenHeight - 2 * (kReadBookSpace_25 + kReadBookSpace_10);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isDragging = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.isDragging = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isDragging) {
        [self updateReadRecordModel];
    }
}

- (void)updateReadRecordModel {
    if ([ReadConfigure shareInstance].effectType == RMEffectType_UpAndDown) {
        if (self.tableView.indexPathsForVisibleRows != nil && self.tableView.indexPathsForVisibleRows.count > 0) {
            // 有cell
            // 范围
            CGRect rect = CGRectMake(kReadBookSpace_25, kReadBookSpace_25 + kReadBookSpace_10, ScreenWidth - 2 * kReadBookSpace_15, ScreenHeight - 2 * (kReadBookSpace_25 + kReadBookSpace_10));
            
            // 显示章节Cell IndexPath
            NSIndexPath * indexPath = [self.tableView indexPathsForRowsInRect:CGRectMake(0, self.tableView.contentOffset.y + kReadBookSpace_15, rect.size.width, rect.size.height - kReadBookSpace_15)].firstObject;
            
            // 章节ID
            NSString * chapterID = [NSString stringWithFormat:@"%@", self.contentArray[indexPath.section]];
            
            // 页码
            NSInteger toPage = indexPath.row;
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                if ([self.readRecordModel.readChapterModel.id isEqualToString:chapterID]) {
                    // 修改页码
                    self.readRecordModel.page = toPage;
                } else {
                    // 修改章节
                    [self.readRecordModel modifyWithChapterID:chapterID toPage:toPage isUpdateFont:NO isSave:NO];
                }
                
                // 保存
                [self.readController.readOperation readRecordUpdate:self.readRecordModel isSave:YES];
                
                // 更新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 修改顶部显示
                    self.topStatusView.text = self.readRecordModel.readChapterModel.name;
                });
            });
        }
    }
}

- (void)reloadDataArray:(ReadChapterModel *)readChapterModel {
    /*
     网络小说操作提示:
     
     再下面判断中 检查是否章节存在 不存在则请求回来之后再加入到列表
     
     提示: 这里都是预加载数据 所以网络请求可以不使用 HUD 阻挡
     */
    
    // 上一章ID
    NSString * lastChapterID = readChapterModel.lastChapterID;
    
    // 下一章ID
    NSString * nextChapterID = readChapterModel.nextChapterID;
    
    // 加载上一章
    if (lastChapterID != nil && ![self.willLoadDataArray containsObject:lastChapterID]) {
//        NSLog(@"%@", )
        [self.willLoadDataArray appendObject:lastChapterID];
        
        // 异步处理
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 是否存在上一章ID
            if (![self.contentArray containsObject:lastChapterID]) {
                // 获取上一章模型
                ReadChapterModel * lastReadChapterModel =  [ReadChapterModel readChapterModelWithBookID:readChapterModel.bookID chapterID:lastChapterID isUpdateFont:YES];
                
                // 回到主线程更新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.contentArray insertObject:lastReadChapterModel.id atIndex:0];
                    [self.tableView reloadData];
                    self.tableView.contentOffset = CGPointMake(0, self.tableView.contentOffset.y + lastReadChapterModel.pageCount * self.tableView.height);
                    
                });
            }
            
        });
    }
    
    // 加载下一章
    if (nextChapterID != nil && ![self.willLoadDataArray containsObject:nextChapterID]) {
        [self.willLoadDataArray appendObject:nextChapterID];
        
        // 异步处理
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 是否存在上一章ID
            if (![self.contentArray containsObject:nextChapterID]) {
                // 获取上一章模型
                ReadChapterModel * nextReadChapterModel =  [ReadChapterModel readChapterModelWithBookID:readChapterModel.bookID chapterID:nextChapterID isUpdateFont:YES];
                
                // 回到主线程更新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.contentArray appendObject:nextReadChapterModel.id];
                    [self.tableView reloadData];
                    
                });
            }
            
        });
    }
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)willLoadDataArray {
    if (!_willLoadDataArray) {
        _willLoadDataArray = [[NSMutableArray alloc] init];
    }
    return _willLoadDataArray;
}

- (UILabel *)topStatusView {
    if (!_topStatusView) {
        _topStatusView = [[UILabel alloc] init];
        _topStatusView.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _topStatusView.textColor = Color_127_136_138;
        _topStatusView.font = APPFONT(kReadBookFont_12);
        _topStatusView.frame = CGRectMake(kReadBookSpace_15, 0, self.view.width - 2 * kReadBookSpace_15, kReadBookSpace_25);
        _topStatusView.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:_topStatusView];
    }
    return _topStatusView;
}

@end
