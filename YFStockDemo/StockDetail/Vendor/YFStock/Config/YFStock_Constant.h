//
//  YFStock_Constant.h
//  YFStockDemo
//
//  Created by 李友富 on 2017/3/30.
//  Copyright © 2017年 李友富. All rights reserved.
//

#ifndef YFStock_Constant_h
#define YFStock_Constant_h

#pragma mark - 尺寸 **********  **********

#define kStockKLineAboveViewTopBottomPadding 12
#define kStockKLineBelowViewTopBottomPadding 5

#define kStockTopBarHeight 35 // 顶部分类条的高度
#define kStockMainViewTopGap 0 // 主要视图距离顶部分类条的距离

#define kStockTimeViewHeight 15 // 中间时间条的高度 15
#define kStockBottomBarHeight kStockTopBarHeight // MACD、KDJ筛选条高度

// KLine视图scrollView的上线左右间距
#define kStockKLineScrollViewLeftGap 0
#define kStockKLineScrollViewTopGap 7
#define kStockKLineScrollViewRightGap 0
#define kStockKLineScrollViewBottomGap 7
#define kStockKLineScrollViewInsideTopBottomPadding 18 // 内部间距

#define kStockKLineScaleBound 0.2 // 缩放K线的比例界限

// K线的最大、最小宽度
#define kStockKlineMinWidth 3
#define kStockKlineMaxWidth 35
#define kStockKlineDefaultWidth 5

// K线的最大最小间距
#define kStockKlineMinGap 1
#define kStockKlineMaxGap 10

// K线的最大最小行数
#define kStockKLineMaxRowCount 4
#define kStockKLineMinRowCount 1


#define kStockKLineViewKlineMinY (8 + kStockKLineScrollViewInsideTopBottomPadding) // K线视图中上部K显示图距离视图上下最小间距

#define kStockKLineKlineMinThick 0.5 // 蜡烛图最小的厚度

#define kStockMALineWidth 1.0 // MA线宽

#define kStockShadowLineWidth 1.0 // 竖线线宽

#define kStockPartLineHeight (1 / [UIScreen mainScreen].scale) // 分割线高度 (1 / [UIScreen mainScreen].scale)

#define kStockVolumeLineViewVolumeLineMinY 10 // volumeLine距离顶部的最小高度


#pragma mark - 颜色 **********  **********

// 主题背景色
#define kStockThemeColor kWhiteColor

// topBar背景色
#define kStockTopBarBgColor kCustomRGBColor(241, 241, 241, 1.0)

// 涨跌颜色
#define kStockIncreaseColor kCustomRGBColor(216, 27, 23, 1.0) // 涨
#define kStockDecreaseColor kCustomRGBColor(26, 181, 70, 1.0) // 跌

// MA线条颜色
#define kStockMA5LineColor kCustomRGBColor(241, 142, 0, 1.0)
#define kStockMA10LineColor kCustomRGBColor(244, 82, 60, 1.0)
#define kStockMA20LineColor kCustomRGBColor(0, 94, 221, 1.0)
#define kStockMA30LineColor kCustomRGBColor(148, 34, 97, 1.0) 

// BOLL线条颜色
#define kStockBOOLUpperLineColor kStockMA5LineColor
#define kStockBOOLMidLineColor kStockMA10LineColor
#define kStockBOOLLowerLineColor kStockMA20LineColor

// MACD颜色
#define kStockDIFFLineColor kCustomRGBColor(241, 142, 0, 1.0)
#define kStockDEALineColor kCustomRGBColor(236, 50, 248, 1.0)


#define kStockKlinePartLineColor kCustomRGBColor(235, 237, 241, 1.0) // K线分割线颜色

// 顶部工具条正常字体颜色跟选中字体颜色
#define kStockTopBarNormalFontColor kCustomRGBColor(22, 22, 22, 0.7f)
#define kStockTopBarSelectedFontColor kCustomRGBColor(245, 184, 0, 1.0f)


#pragma mark - 参数
#define kStock_EMA_PreviousDayScale 3.45

#define kStock_MA_5_N 5
#define kStock_MA_10_N 10
#define kStock_MA_20_N 20
#define kStock_MA_30_N 30

#define kStock_BOLL_K 2
#define kStock_BOLL_N 20

#define kStock_MACD_SHORT 12
#define kStock_MACD_LONG 26
#define kStock_MACD_MID 9

#define kStock_KDJ_N 9

#define kStock_RSI_6_N 6
#define kStock_RSI_12_N 12
#define kStock_RSI_24_N 24

#define kStock_ARBR_N 26

#define kStock_WR_1_N 10
#define kStock_WR_2_N 6

#define kStock_EMV_N 14
#define kStock_EMV_MA_N 9

#define kStock_CCI_N 14

#define kStock_DMA_SHORT 10
#define kStock_DMA_LONG 50

#define kStock_BIAS_1_N 6
#define kStock_BIAS_2_N 12
#define kStock_BIAS_3_N 24

#define kStock_ROC_N 12
#define kStock_ROC_MA_N 6

#define kStock_MTM_N 12
#define kStock_MTM_MA_N 6

#define kStock_CR_N 26
#define kStock_CR_MA_1_N 10
#define kStock_CR_MA_2_N 20

#define kStock_DMI_PDIMDI_N 14
#define kStock_DMI_ADX_ADXR_N 6

#define kStock_VR_N 26
#define kStock_VR_MA_N 6

#define kStock_TRIX_N 12
#define kStock_TRIX_MA_N 9

#define kStock_PSY_N 12
#define kStock_PSY_MA_N 6

#define kStock_DPO_N 20
#define kStock_DPO_MA_N 6

#define kStock_ASI_N 6
#define kStock_ASI_MA_N 6


#pragma mark - 枚举 **********  **********

// 线的类型
typedef NS_ENUM(NSInteger, YFStockLineType) {
    
    YFStockLineTypeKLine,
    YFStockLineTypeTimeLine
};

// 股票线类型
typedef NS_ENUM(NSInteger, YFStockTopBarIndex) {
    
    YFStockTopBarIndex_MinuteHour,
    YFStockTopBarIndex_DayK,
    YFStockTopBarIndex_WeekK,
    YFStockTopBarIndex_MonthK,
    YFStockTopBarIndex_5Minute,
    YFStockTopBarIndex_30Minute,
    YFStockTopBarIndex_60Minute,
    YFStockTopBarIndex_YearK
};

// bottomBar类型
typedef NS_ENUM(NSInteger, YFStockBottomBarIndex) {
    
    YFStockBottomBarIndex_MACD,
    YFStockBottomBarIndex_KDJ,
    YFStockBottomBarIndex_RSI,
    YFStockBottomBarIndex_ARBR,
    YFStockBottomBarIndex_OBV,
    YFStockBottomBarIndex_WR,
    YFStockBottomBarIndex_EMV,
    YFStockBottomBarIndex_DMA,
    YFStockBottomBarIndex_CCI,
    YFStockBottomBarIndex_BIAS,
    YFStockBottomBarIndex_ROC,
    YFStockBottomBarIndex_MTM,
    YFStockBottomBarIndex_CR,
    YFStockBottomBarIndex_DMI,
    YFStockBottomBarIndex_VR,
    YFStockBottomBarIndex_TRXI,
    YFStockBottomBarIndex_PSY,
    YFStockBottomBarIndex_DPO,
    YFStockBottomBarIndex_ASI,
    YFStockBottomBarIndex_SAR
};

// MA/BOLL类型
typedef NS_ENUM(NSInteger, YFStockKLineLineType) {
    
    YFStockKLineLineType_MA,
    YFStockKLineLineType_BOLL
};


#pragma mark - Other **********  **********

// 常用颜色
#define kWhiteColor     [UIColor whiteColor]
#define kBlackColor     [UIColor blackColor]
#define kBlueColor      [UIColor blueColor]
#define kBrownColor     [UIColor brownColor]
#define kClearColor     [UIColor clearColor]
#define kDarkGrayColor  [UIColor darkGrayColor]
#define kYellowColor    [UIColor yellowColor]
#define kRedColor       [UIColor redColor]
#define kOrangeColor    [UIColor orangeColor]
#define kPurpleColor    [UIColor purpleColor]
#define kLightGrayColor [UIColor lightGrayColor]
#define kGreenColor     [UIColor greenColor]
#define kGrayColor      [UIColor grayColor]
#define kMagentaColor   [UIColor magentaColor]

#define kCustomRGBColor(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a)] // 自定义颜色rgb颜色
#define kCustom0xColor(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 blue:((float)(rgbValue & 0x0000FF))/255.0 alpha:alphaValue] // 自定义16进制颜色

/* 字体 */
#define kFont_20 [UIFont systemFontOfSize:20]
#define kFont_19 [UIFont systemFontOfSize:19]
#define kFont_18 [UIFont systemFontOfSize:18]
#define kFont_17 [UIFont systemFontOfSize:17]
#define kFont_16 [UIFont systemFontOfSize:16]
#define kFont_15 [UIFont systemFontOfSize:15]
#define kFont_14 [UIFont systemFontOfSize:14]
#define kFont_13 [UIFont systemFontOfSize:13]
#define kFont_12 [UIFont systemFontOfSize:12]
#define kFont_11 [UIFont systemFontOfSize:11]
#define kFont_10 [UIFont systemFontOfSize:10]
#define kFont_9 [UIFont systemFontOfSize:9]
#define kFont_8 [UIFont systemFontOfSize:8]

// 重写NSLog打印函数
#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...)
#endif

// 弱引用
#define kWeakSelf(ClassName) __weak typeof(ClassName *)weakSelf = self

// 屏幕宽度、高度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width // 屏幕宽度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height // 屏幕高度

#endif /* YFStock_Constant_h */
