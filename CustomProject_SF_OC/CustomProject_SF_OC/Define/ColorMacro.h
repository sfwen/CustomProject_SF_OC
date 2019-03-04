//
//  ColorMacro.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/12.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#ifndef ColorMacro_h
#define ColorMacro_h

//颜色
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define HEXCOLORALPHA(rgbValue,r) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(float)(r)]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

///颜色随机
#define randomColor        [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0]


///自定义颜色
#define Color_Block_51      RGBACOLOR(51, 51, 51, 1) // 深黑（标题）
#define Color_Groy_140      RGBACOLOR(140, 140, 140, 1) // 灰色（三级副标题）
#define Color_Groy_Line_217 RGBACOLOR(217, 217, 217, 1) // 商城灰色（分隔线等）

#pragma mark -- 颜色支持

/// 灰色 || 阅读背景颜色支持
#define Color_51_51_51 RGBACOLOR(51, 51, 51, 1)

/// 粉红色
#define Color_253_85_103 RGBACOLOR(253, 85, 103, 1)

/// 阅读上下状态栏颜色 || 小说阅读上下状态栏字体颜色
#define Color_127_136_138 RGBACOLOR(127, 136, 138, 1)

/// 小说阅读颜色
#define Color_145_145_145 RGBACOLOR(145, 145, 145, 1)

/// LeftView文字颜色
#define Color_200_200_200 RGBACOLOR(200, 200, 200, 1)

/// 阅读背景颜色支持
#define Color_238_224_202 RGBACOLOR(238, 224, 202, 1)
#define Color_205_239_205 RGBACOLOR(205, 239, 205, 1)
#define Color_206_233_241 RGBACOLOR(206, 233, 241, 1)
#define Color_251_237_199 RGBACOLOR(251, 237, 199, 1)

/// 菜单背景颜色
#define MenuUIColor [UIColor colorWithComplementaryFlatColorOf:[UIColor blackColor] withAlpha:0.85]

#endif /* ColorMacro_h */
