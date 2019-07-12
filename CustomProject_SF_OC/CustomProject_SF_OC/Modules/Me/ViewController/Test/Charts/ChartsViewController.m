//
//  ChartsViewController.m
//  CustomProject_SF_OC
//
//  Created by Land on 2019/6/15.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "ChartsViewController.h"
#import <AAChartKit/AAChartKit.h>

@interface ChartsViewController () <AAChartViewEventDelegate>

@property (nonatomic, strong) AAChartView  *aaChartView;
@property (nonatomic, strong) AAChartModel *aaChartModel;

@end

@implementation ChartsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"图表";
    [self.aaChartView aa_drawChartWithChartModel:self.aaChartModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (AAChartView *)aaChartView {
    if (!_aaChartView) {
        _aaChartView = [[AAChartView alloc] init];
//        _aaChartView.frame = CGRectMake(0, 0, ScreenWidth, self.view.height - 60);
        _aaChartView.delegate = self;
        _aaChartView.scrollEnabled = YES;
        _aaChartView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_aaChartView];
        [_aaChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-100);
        }];
        
        //设置 AAChartView 的背景色是否为透明
        _aaChartView.isClearBackgroundColor = YES;
    }
    return _aaChartView;
}

- (AAChartModel *)aaChartModel {
    if (!_aaChartModel) {
        _aaChartModel = AAChartModel.new;
        _aaChartModel.chartTypeSet(AAChartTypeColumn)//图表类型
        .titleSet(@"图表主标题")//图表主标题
        .subtitleSet(@"图表副标题")//图表副标题
        .yAxisLineWidthSet(@1)//Y轴轴线线宽为0即是隐藏Y轴轴线
        .colorsThemeSet(@[@"#fe117c",@"#ffc069",@"#06caf4",@"#7dffc0"])//设置主体颜色数组
        .yAxisTitleSet(@"金额")//设置 Y 轴标题
        .tooltipValueSuffixSet(@"元")//设置浮动提示框单位后缀
        .backgroundColorSet(@"#4b2b7f")//背景颜色
        .yAxisGridLineWidthSet(@0.5)//y轴横向分割线宽度为0(即是隐藏分割线)
        .touchEventEnabledSet(true)//支持用户点击事件
        .seriesSet(@[
                     AASeriesElement.new
                     .nameSet(@"2017")
                     .dataSet(@[@1.0, @20.0, @3.0, @4.0, @5.0, @6.0, @7.0, @8.0, @9.0, @10.0, @11.0, @12.0, @1.0, @200., @3.0, @4.0, @5.0, @6.0, @-37.0, @8.0, @9.0, @10.0, @11.0, @12.0]),
                     AASeriesElement.new
                     .nameSet(@"2018")
                     .dataSet(@[@0.2, @0.8, @5.7, @11.3, @17.0, @22.0, @24.8, @24.1, @20.1, @14.1, @8.6, @2.5, @0.2, @0.8, @5.7, @11.3, @17.0, @22.0, @24.8, @24.1, @20.1, @14.1, @8.6, @2.5]),
                     AASeriesElement.new
                     .nameSet(@"2019")
                     .dataSet(@[@0.9, @0.6, @3.5, @8.4, @13.5, @17.0, @18.6, @17.9, @14.3, @9.0, @3.9, @1.0, @0.9, @0.6, @3.5, @8.4, @13.5, @17.0, @18.6, @17.9, @14.3, @9.0, @3.9, @1.0]),
                     AASeriesElement.new
                     .nameSet(@"2020")
                     .dataSet(@[@3.9, @4.2, @5.7, @8.5, @11.9, @15.2, @17.0, @16.6, @14.2, @10.3, @6.6, @4.8, @3.9, @4.2, @5.7, @8.5, @11.9, @15.2, @17.0, @16.6, @14.2, @10.3, @6.6, @4.8]),
                     ]
                   )
        .categoriesSet(@[@"q", @"w", @"e", @"r", @"t", @"y", @"u", @"i", @"o", @"p", @"a", @"s", @"d", @"f", @"g", @"h", @"j", @"k", @"l", @"z", @"x", @"c", @"v", @"b"])//设置 X 轴坐标文字内容
        .animationTypeSet(AAChartAnimationBounce)//图形的渲染动画为弹性动画
        .animationDurationSet(@(1200))//图形渲染动画时长为1200毫秒
        .yAxisTitleSet(@"字母")
        .zoomTypeSet(AAChartZoomTypeXY)//缩放
        ;
    }
    return _aaChartModel;
}

@end
