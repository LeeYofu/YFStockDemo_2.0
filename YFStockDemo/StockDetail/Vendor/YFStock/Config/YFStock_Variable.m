//
//  YFStock_Variable.m
//  YFStockDemo
//
//  Created by 李友富 on 2017/3/30.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import "YFStock_Variable.h"
#import "YFStock_Constant.h"

static CGFloat YFStockKLineVolumeViewHeightRadio = 0.25; // KLine视图跟VolumeLine视图的屏占比
static CGFloat YFStockKlineLineWidth = kStockKlineDefaultWidth; // 默认的K线线宽
static CGFloat YFStockKlineLineCap = 2; // 默认的K线之间的间距
static NSInteger YFStockKlineRowCount = 4; // K线的分区数目/行数
static BOOL YFStockIsFullScreen = NO; // 是否是全屏状态，默认为NO
static NSInteger YFStockSelectedIndex = 0; // 选中的下标
static NSInteger YFStockBottomBarSelectedIndex = 0;
static NSInteger YFStockNormalScreenLastedSelectedIndex = 0; // 非全屏最后一次选中的下标
static CGFloat YFStockNormalScreenLastedKLineWidth = 0; // 非全屏状态下最后展示的K线宽
static CGFloat YFStockTimeLineLineWidth = 1;
static CGFloat YFStockTimeLineLineGap = 0.2;

@interface YFStock_Variable()

@end

@implementation YFStock_Variable

#pragma mark - getter
+ (CGFloat)KlineVolumeViewHeightRadio {
    
    return YFStockKLineVolumeViewHeightRadio;
}

+ (CGFloat)KLineWidth {
    
    return YFStockKlineLineWidth;
}

+ (CGFloat)defaultKLineWidth {
    
    return kStockKlineDefaultWidth;
}

+ (CGFloat)KLineGap {
    
    return YFStockKlineLineCap;
}

+ (NSInteger)KLineRowCount {
    
    return YFStockKlineRowCount;
}

+ (NSInteger)selectedIndex {
    
    return YFStockSelectedIndex;
}

+ (CGFloat)timeLineWidth {
    
    return YFStockTimeLineLineWidth;
}

+ (CGFloat)timeLineGap {
    
    return YFStockTimeLineLineGap;
}

+ (BOOL)isFullScreen {
    
    return YFStockIsFullScreen;
}

+ (NSInteger)bottomBarSelectedIndex {
    
    return YFStockBottomBarSelectedIndex;
}

#pragma mark - setter
+ (void)setKLineWidth:(CGFloat)KLineWidth {
    
    if (KLineWidth > kStockKlineMaxWidth) {
        
        KLineWidth = kStockKlineMaxWidth;
    }
    if (KLineWidth < kStockKlineMinWidth) {
        
        KLineWidth = kStockKlineMinWidth;
    }
    
    YFStockKlineLineWidth = KLineWidth;
}

+ (void)setKLineGap:(CGFloat)KLineGap {
    
    if (KLineGap > kStockKlineMaxGap) {
        
        KLineGap = kStockKlineMaxGap;
    }
    if (KLineGap < kStockKlineMinGap) {
        
        KLineGap = kStockKlineMinGap;
    }
    
    YFStockKlineLineCap = KLineGap;
}

+ (void)setKlineRowCount:(CGFloat)KLineRowCount {
    
    if (KLineRowCount > kStockKLineMaxRowCount) {
        
        KLineRowCount = kStockKLineMaxRowCount;
    }
    if (KLineRowCount < kStockKLineMinRowCount) {
        
        KLineRowCount = kStockKLineMinRowCount;
    }
    
    YFStockKlineRowCount = KLineRowCount;
}

+ (void)setIsFullScreen:(BOOL)isFullScreen {
    
    YFStockIsFullScreen = isFullScreen;
    
    if (isFullScreen) {
        
        // 保留住全屏之前的最后数据（线宽、下标）
        YFStockNormalScreenLastedKLineWidth = YFStockKlineLineWidth;
        YFStockNormalScreenLastedSelectedIndex = YFStockSelectedIndex;
        
        // 改变线宽为全屏默认线宽、下标不变
        YFStockKlineLineWidth = kStockKlineDefaultWidth;
    } else { // 由全屏状态退出
        
        // 改变线宽为上次非全屏的最后宽度、下标为上次非全屏时的最后下标
        YFStockKlineLineWidth = YFStockNormalScreenLastedKLineWidth;
        YFStockSelectedIndex = YFStockNormalScreenLastedSelectedIndex;
    }
}

+ (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    YFStockSelectedIndex = selectedIndex;
}

+ (void)setBottomBarSelectedIndex:(NSInteger)bottomBarSelectedIndex {
    
    YFStockBottomBarSelectedIndex = bottomBarSelectedIndex;
}

+ (void)setTimeLineWidth:(CGFloat)timeLineWidth {
    
    YFStockTimeLineLineWidth = timeLineWidth;
}

@end
