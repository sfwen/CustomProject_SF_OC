//
//  ArticleDetailViewController.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/14.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "PAWebView.h"
//#import "wkjs"

@interface ArticleDetailViewController () 

@property (nonatomic, strong) PAWebView * webView;

@end

@implementation ArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Base Method
- (void)loadData {
    NSString * requestUrl = [NSString stringWithFormat:kArticleDetailBasicURL@"?isad=%@&sort=%@&columns=%@&vertype=%@&article_id=%@&app-ver=%@", @(0), @(0), @(self.columnID), kRevisionControlName, @(self.articleID), AppVersion];
    [self.webView loadRequestURL:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0]];
}

#pragma mark - Custom Method
- (void)addMessageHandleName {
//    weakSelf(self)
    [self.webView addScriptMessageHandlerWithName:@[@"timefor"] observeValue:^(WKUserContentController *userContentController, WKScriptMessage *message) {
        NSLog(@"%@", message.name);
        NSLog(@"%@", message.body);
    }];
}

- (PAWebView *)webView {
    if (!_webView) {
        _webView = [[PAWebView alloc] init];
        _webView.webView.frame = self.view.bounds;
        _webView.openCache = YES;
        //添加与JS交互事件
        [self addMessageHandleName];
        //二维码识别后返回的二维码数据
        [_webView notificationInfoFromQRCode:^(NSString *info) {
            
        }];
        [self addChildViewController:_webView];
        [self.view addSubview:_webView.view];
    }
    return _webView;
}

@end
