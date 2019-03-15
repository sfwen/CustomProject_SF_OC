//
//  AttributeViewController.m
//  CustomProject_SF_OC
//
//  Created by Land on 2019/2/27.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "AttributeViewController.h"
#import "UIImage+Category.h"
#import <SDWebImage/UIImage+GIF.h>
#import <Ono/Ono.h>
#import "HTMLModel.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
#import "AttributeSectionController.h"

@interface AttributeViewController ()

@property (nonatomic, strong) YYTextView * textView;

@property (nonatomic, strong) ONOXMLDocument * document;
@property (nonatomic, strong) NSMutableAttributedString * attributedString;

@end

@implementation AttributeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.openPullUpRefresh = NO;
    self.openPullDownRefresh = NO;
    [self loadHtml];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    self.textView.attributedText = self.attributedString;
}


- (void)addImageToAttributedTextWithURL:(NSString *)imageURLStr abs:(NSMutableAttributedString *)abs {
    NSDictionary * dict = [NSDictionary getURLParametersWithURL:imageURLStr];
    CGFloat w = [dict[@"w"] integerValue];
    CGFloat h = [dict[@"h"] integerValue];
    
    NSURL * imgURL = [[NSURL alloc] initWithString:imageURLStr];
    
    //YYAnimatedImageView
    UIImageView * imageView = [[YYAnimatedImageView alloc] init];
    
    if ([imageURLStr isGifImage]) {
        imageView = [[FLAnimatedImageView alloc] init];
        FLAnimatedImage * image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:imgURL]];
        imageView.frame = CGRectMake(8, 8, self.textView.width - 16, self.textView.width / image.size.width * image.size.height);
        ((FLAnimatedImageView *)imageView).animatedImage = image;
    } else {
        if (w == 0) {
            // 优化 计算网络图片的大小Size
            // 1. 先查看SDWebImage有没有缓存这张图片，如果有则不用下载网络图片，直接获取到图片的大小
            // 2. 如果没有则会下载完整的图片NSData来计算大小
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            __block UIImage *img;
            [manager diskImageExistsForURL:imgURL completion:^(BOOL isInCache) {
                if (isInCache) {
                    img = [[manager imageCache] imageFromDiskCacheForKey:imgURL.absoluteString];
                    NSLog(@"SD--获取网络图片的大小--Size : %@", NSStringFromCGSize(img.size));
                } else {
                    NSData *data = [NSData dataWithContentsOfURL:imgURL];
                    img = [UIImage imageWithData:data];
                    NSLog(@"NSData--获取网络图片的大小--Size : %@",     NSStringFromCGSize(img.size));
                }
                imageView.frame = CGRectMake(8, 0, self.textView.width - 16, self.textView.width / img.size.width * img.size.height);
                imageView.image = img;
            }];
        } else {
            imageView.frame = CGRectMake(8, 0, self.textView.width - 16, self.textView.width / w * h);
            [imageView sd_setImageWithURL:imgURL placeholderImage:[UIImage imageWithColor:FlatGray]];
        }
    }
    
    imageView.userInteractionEnabled = YES;
    [imageView tapUpWithBlock:^(UIView *v) {
        NSLog(@"%@", imageURLStr);
    }];
    
    NSMutableAttributedString * attachText = [NSMutableAttributedString attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.size alignToFont:APPFONT(17) alignment:YYTextVerticalAlignmentCenter];
    [abs appendAttributedString:attachText];
}

- (void)loadHtml {
    //取得欲读取档案的位置与文件名
//    NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
//    NSString * filePath = [resourcePath stringByAppendingPathComponent:@"Test4.html"];
//    // encoding:NSUTF8StringEncoding error:nil 这一段一定要加，不然中文字会乱码
//    NSString * htmlstring = [[NSString alloc] initWithContentsOfFile:filePath  encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"----htmlstring---- \n%@", htmlstring);
    NSArray * arr = @[@"https://mbd.baidu.com/newspage/data/landingsuper?context=%7B%22nid%22%3A%22news_10023524220900122582%22%7D&n_type=0&p_from=1",
      @"https://baijiahao.baidu.com/s?id=1626871243738273434&wfr=spider&for=pc",
                      @"https://baijiahao.baidu.com/s?id=1626874063245875643&wfr=spider&for=pc",
                      @"https://mbd.baidu.com/newspage/data/landingsuper?context=%7B%22nid%22%3A%22news_9897352572827066204%22%7D&n_type=0&p_from=1",
                      @"https://mbd.baidu.com/newspage/data/landingsuper?context=%7B%22nid%22%3A%22news_9320942501017799100%22%7D&n_type=0&p_from=1"];
    NSString *myURLString = arr[4];
    NSURL *myURL = [NSURL URLWithString:myURLString];
    
    NSError *error = nil;
    NSString *htmlstring = [NSString stringWithContentsOfURL:myURL encoding: NSUTF8StringEncoding error:&error];
    
//    if (error != nil) {
//        NSLog(@"Error : %@", error);
//    } else {
//        NSLog(@"HTML : %@", htmlstring);
//    }
    
    self.document = [ONOXMLDocument HTMLDocumentWithString:htmlstring encoding:NSUTF8StringEncoding error:nil];
    HTMLModel *model = [[HTMLModel alloc] init];
    [self.contentArray removeAllObjects];
    
    __block NSString *xpath = @"";
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        // 并行执行的线程一
        NSLog(@"执行线程一");
        xpath = @"/html/head/title";
        [self.document enumerateElementsWithXPath:xpath usingBlock:^(ONOXMLElement * _Nonnull element, NSUInteger idx, BOOL * _Nonnull stop) {
            //获取title
            if ([element.tag isEqualToString:@"title"]) {
                model.title = element.stringValue;
                self.title = element.stringValue;
                * stop = YES;
            }
        }];
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        // 并行执行的线程二
        NSLog(@"执行线程二");
        xpath = @"//*[@id='article']/div[3]";
        [self.document enumerateElementsWithXPath:xpath usingBlock:^(ONOXMLElement * _Nonnull element, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![element.tag isEqualToString:@"article-content"]) {
                * stop = YES;
            }
            
            for (ONOXMLElement *celement in element.children) {
                HTMLItemModel * itemModel = [[HTMLItemModel alloc] init];
                if ([celement.tag isEqualToString:@"p"]) {
                    itemModel.dataType = ItemDataType_Text;
                    itemModel.content = [NSString stringWithFormat:@"%@", celement.stringValue];
                } else if ([celement.tag isEqualToString:@"img"]) {
                    NSString * imgStr = celement[@"src"];
                    if (imgStr.length > 0) {
                        [itemModel.imagesArray addObject:[self createImageModel:imgStr]];
                    }
                } else if ([celement.tag isEqualToString:@"div"]) {
                    for (ONOXMLElement * ccelement in celement.children) {
                        if ([ccelement.tag isEqualToString:@"img"]) {
                            NSString * imgStr = ccelement[@"src"];
                            if (imgStr.length > 0) {
                                [itemModel.imagesArray addObject:[self createImageModel:imgStr]];
                            }
                        } else if ([ccelement.tag isEqualToString:@"video"]) {
                            NSLog(@"视频");
                            NSLog(@"封面：%@", ccelement[@"poster"]);
                            NSLog(@"地址：%@", ccelement[@"src"]);
                            VideoModel * videoModel = [[VideoModel alloc] init];
                            
                            NSString * imgStr = ccelement[@"poster"];
                            videoModel.imageModel = [self createImageModel:imgStr];
                            videoModel.url = ccelement[@"src"];
                            
                            [itemModel.imagesArray addObject:videoModel];
                        }
                    }
                }
                
                [model.contentArray addObject:itemModel];
                [self.contentArray addObject:itemModel];
            }
        }];
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(0,0), ^{
        // 汇总结果
        NSLog(@"汇总结果");
        //更新数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.adapter performUpdatesAnimated:YES completion:nil];
        });
        
    });
    
    //添加 阅读原文
//    NSMutableAttributedString * operAbs = [[NSMutableAttributedString alloc] initWithString:@"阅读原文"];
//    operAbs.color = FlatRed;
//    operAbs.font = APPFONT(12);
//    operAbs.strikethroughStyle = NSUnderlineStyleSingle | NSUnderlinePatternSolid;
//    [attributedString appendAttributedString:operAbs];

//    self.attributedString = attributedString;
    
//    //获取图片资源
//    NSArray *attachments =  self.textView.textLayout.attachments;
//    for(YYTextAttachment *attachment in attachments)
//    {
//        YYAnimatedImageView *imageView = attachment.content;
//        //        YYImage *image = (YYImage *)imageView.image;
//        //        NSLog(@"获取到图片:%@",image);
//
//        imageView.userInteractionEnabled = YES;
//        imageView.tapAction = ^(UIView *v) {
//            [self tapImageViewAction:@"2"];
//        };
//    }
}

- (ImageModel *)createImageModel:(NSString *)imageURLStr {
    ImageModel * model = [[ImageModel alloc] init];
    model.urlStr = imageURLStr;
    
    NSDictionary * dict = [NSDictionary getURLParametersWithURL:imageURLStr];
    model.w = [dict[@"w"] integerValue];
    model.h = [dict[@"h"] integerValue];
    
    NSURL * imgURL = [[NSURL alloc] initWithString:imageURLStr];
    
    if ([imageURLStr isGifImage]) {
//        imageView = [[FLAnimatedImageView alloc] init];
        FLAnimatedImage * image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:imgURL]];
        model.w = image.size.width;
        model.h = image.size.height;
//        imageView.frame = CGRectMake(8, 8, self.textView.width - 16, self.textView.width / image.size.width * image.size.height);
//        ((FLAnimatedImageView *)imageView).animatedImage = image;
    } else {
        if (model.w == 0) {
            // 优化 计算网络图片的大小Size
            // 1. 先查看SDWebImage有没有缓存这张图片，如果有则不用下载网络图片，直接获取到图片的大小
            // 2. 如果没有则会下载完整的图片NSData来计算大小
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            __block UIImage *img;
            [manager diskImageExistsForURL:imgURL completion:^(BOOL isInCache) {
                if (isInCache) {
                    img = [[manager imageCache] imageFromDiskCacheForKey:imgURL.absoluteString];
                    NSLog(@"SD--获取网络图片的大小--Size : %@", NSStringFromCGSize(img.size));
                } else {
                    NSData *data = [NSData dataWithContentsOfURL:imgURL];
                    img = [UIImage imageWithData:data];
                    NSLog(@"NSData--获取网络图片的大小--Size : %@",     NSStringFromCGSize(img.size));
                }
                model.w = img.size.width;
                model.h = img.size.height;
            }];
        }
    }
    
    return model;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapImageViewAction:(NSString *)sender {
    NSLog(@"%@", sender);
}

#pragma mark -
- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    if ([object isKindOfClass:[HTMLItemModel class]]) {
        return [AttributeSectionController new];
    }
    return nil;
}

/** 空数据页面 */
- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    return view;
}

#pragma mark - 懒加载

- (YYTextView *)textView {
    if (!_textView) {
        _textView = [YYTextView new];
        _textView.frame = self.view.bounds;
        _textView.font = APPFONT(17);
        _textView.textColor = FlatBlack;
        _textView.editable = NO;
        //设置了该属性，系统可以自动检测电话、链接、地址、日历、邮箱。并且可以点击，当点击的时候可以在API中自定义事件
        _textView.dataDetectorTypes = UIDataDetectorTypeAll;
        _textView.placeholderText = @"占位符";
        _textView.placeholderTextColor = FlatGray;
        _textView.textVerticalAlignment = YYTextVerticalAlignmentTop;
        [self.view addSubview:_textView];
    }
    return _textView;
}

@end
