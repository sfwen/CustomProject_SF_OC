//
//  AppToolMacro.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/7.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#ifndef AppToolMacro_h
#define AppToolMacro_h

#ifdef DEBUG
#define NSLog(...) printf("[%s] %s [第%d行]:\n %s\n\n\n", __TIME__ ,__PRETTY_FUNCTION__ ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
#define PPLog(...)
#endif

//屏幕尺寸
#define ScreenWidth CGRectGetWidth([[UIScreen mainScreen] bounds])
#define ScreenHeight CGRectGetHeight([[UIScreen mainScreen] bounds])
#define navBarHeight     44.0f

///电池条高度
#define statusBarHeight  [[UIApplication sharedApplication] statusBarFrame].size.height

///导航栏高度
#define navViewHeight        (statusBarHeight+navBarHeight)

///tabBar高度
//#define tabBarHeight         ((isNeatBang == YES) ? (49.0f+34.0f) : 49.0f)
//
/////tabBar安全区域
//#define tabbarSafetyZone         ((isNeatBang == YES) ? 34.0f : 0.0f)
//
/////导航栏安全区域
//#define navBarSafetyZone         ((isNeatBang == YES) ? 44.0f : 0.0f)


//字体
//#define ICONFONT(S) [UIFont fontWithName:@"iconfont" size:S]  [UIFont systemFontOfSize:(fontSize)]  [UIFont boldSystemFontOfSize:(S)]
//#define BoldFONT(S) [UIFont fontWithName:@"Helvetica-Bold" size:S] [UIFont fontWithName:@"PingFangSC-Regular"size:20]; 
#define APPFONT(fontSize) [UIFont fontWithName:@"PingFangSC-Regular"size:(fontSize)]
#define APPBOLDFONT(S) [UIFont boldSystemFontOfSize:(S)]

//计算文字宽高
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define TextSize(_text, _font) [_text length] > 0 ? [_text sizeWithAttributes:@{NSFontAttributeName:_font}] : CGSizeZero;
#else
#define TextSize(_text, _font) [_text length] > 0 ? [_text sizeWithFont:_font] : CGSizeZero;
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define TextSize_MutiLine(_text, _font, _maxSize) [_text length] > 0 ? [_text boundingRectWithSize:_maxSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:_font} context:nil].size : CGSizeZero;
#else
#define TextSize_MutiLine(_text, _font, _maxSize) [_text length] > 0 ? [_text sizeWithFont:_font constrainedToSize:_maxSize lineBreakMode:NSLineBreakByWordWrapping] : CGSizeZero;
#endif

//隐藏键盘
#define HIDE_KEYBOARD() [[[UIApplication sharedApplication] keyWindow] endEditing:YES]

///block self
#define weakSelf(type)      __weak typeof(type) weak##type = type;
#define strongSelf(type)    __strong typeof(type) type = weak##type;

//G－C－D
///在子线程上运行的GCD
#define GCD_SubThread(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)

///在主线程上运行的GCD
#define GCD_MainThread(block) dispatch_async(dispatch_get_main_queue(),block)

///只运行一次的GCD
#define GCD_OnceThread(block) static dispatch_once_t onceToken; dispatch_once(&onceToken, block);

///获取app包路径
#define kBundlePath     [[NSBundle mainBundle] bundlePath];

///获取app资源目录路径
#define appResourcePath         [[NSBundle mainBundle] resourcePath];

///获取app包的readme.txt文件
#define readmePath         [[NSBundle mainBundle] pathForResource:@"readme" ofType:@"txt"];

///app名字
#define AppName          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]

#define appStoreName     [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]

///应用标识
#define AppIdentifier    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];

///应用商店版本号
#define AppStoreVersion   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

///应用构建版本号
#define AppVersion        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]


///获取当前语言
#define currentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

///判断是竖屏还是横屏
#define UIDeviceOrientationIsPortrait(orientation)  ((orientation) == UIDeviceOrientationPortrait || (orientation) == UIDeviceOrientationPortraitUpsideDown)//竖屏

#define UIDeviceOrientationIsLandscape(orientation) ((orientation) == UIDeviceOrientationLandscapeLeft || (orientation) == UIDeviceOrientationLandscapeRight)//横屏


#endif /* AppToolMacro_h */
