//
//  YFStock_Variable.h
//  YFStockDemo
//
//  Created by 李友富 on 2017/3/30.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YFStock_Variable : NSObject

// getter
+ (CGFloat)KlineVolumeViewHeightRadio;
+ (CGFloat)KLineWidth;
+ (CGFloat)KLineGap;
+ (NSInteger)KLineRowCount;
+ (CGFloat)defaultKLineWidth;
+ (NSInteger)selectedIndex;
+ (CGFloat)timeLineWidth;
+ (CGFloat)timeLineGap;
+ (BOOL)isFullScreen;

// setter
+ (void)setKLineWidth:(CGFloat)KLineWidth;
//+ (void)setKLineGap:(CGFloat)KLineGap;
+ (void)setKlineRowCount:(CGFloat)KLineRowCount;
+ (void)setIsFullScreen:(BOOL)isFullScreen;
+ (void)setSelectedIndex:(NSInteger)selectedIndex;
+ (void)setTimeLineWidth:(CGFloat)timeLineWidth;

@end
