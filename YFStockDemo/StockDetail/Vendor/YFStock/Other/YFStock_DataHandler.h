//
//  YFStock_DataHandler.h
//  YFStockDemo
//
//  Created by 李友富 on 2017/3/31.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YFStock_Header.h"
#import "YFStock_KLineModel.h"
#import "YFStock_TimeLineModel.h"

@interface YFStock_DataHandler : NSObject

#pragma mark - property
// TimeLine
@property (nonatomic, assign) CGFloat maxTimeLineValue;
@property (nonatomic, assign) CGFloat minTimeLineValue;
@property (nonatomic, assign) CGFloat avgTimeLineValue;
@property (nonatomic, assign) CGFloat avgTimeLinePositionY;
@property (nonatomic, strong) NSArray <YFStock_TimeLineModel *> *drawTimeLineModels;

// KLine
@property (nonatomic, assign) CGFloat maxKLineValue; // 都是实际原始值，不是坐标值
@property (nonatomic, assign) CGFloat minKLineValue;
@property (nonatomic, assign) CGFloat maxVolumeLineValue;
@property (nonatomic, assign) CGFloat minVolumeLineValue;
@property (nonatomic, strong) NSArray <YFStock_KLineModel *> *drawKLineModels;

// MACD
@property (nonatomic, assign) CGFloat MACDMaxValue;
@property (nonatomic, assign) CGFloat MACDMinValue;

// KDJ
@property (nonatomic, assign) CGFloat KDJMaxValue;
@property (nonatomic, assign) CGFloat KDJMinValue;

// RSI
@property (nonatomic, assign) CGFloat RSIMaxValue;
@property (nonatomic, assign) CGFloat RSIMinValue;

// ARBR
@property (nonatomic, assign) CGFloat ARBRMaxValue;
@property (nonatomic, assign) CGFloat ARBRMinValue;

// OBV
@property (nonatomic, assign) CGFloat OBVMaxValue;
@property (nonatomic, assign) CGFloat OBVMinValue;

// WR
@property (nonatomic, assign) CGFloat WRMaxValue;
@property (nonatomic, assign) CGFloat WRMinValue;

// EMV
@property (nonatomic, assign) CGFloat EMVMaxValue;
@property (nonatomic, assign) CGFloat EMVMinValue;

// DMA
@property (nonatomic, assign) CGFloat DMAMaxValue;
@property (nonatomic, assign) CGFloat DMAMinValue;

// CCI
@property (nonatomic, assign) CGFloat CCIMaxValue;
@property (nonatomic, assign) CGFloat CCIMinValue;

// BIAS
@property (nonatomic, assign) CGFloat BIASMaxValue;
@property (nonatomic, assign) CGFloat BIASMinValue;

// ROC
@property (nonatomic, assign) CGFloat ROCMaxValue;
@property (nonatomic, assign) CGFloat ROCMinValue;

// MTM
@property (nonatomic, assign) CGFloat MTMMaxValue;
@property (nonatomic, assign) CGFloat MTMMinValue;

// CR
@property (nonatomic, assign) CGFloat CRMaxValue;
@property (nonatomic, assign) CGFloat CRMinValue;

// DMI
@property (nonatomic, assign) CGFloat DMIMaxValue;
@property (nonatomic, assign) CGFloat DMIMinValue;

// VR
@property (nonatomic, assign) CGFloat VRMaxValue;
@property (nonatomic, assign) CGFloat VRMinValue;

// TRIX
@property (nonatomic, assign) CGFloat TRIXMaxValue;
@property (nonatomic, assign) CGFloat TRIXMinValue;

// PSY
@property (nonatomic, assign) CGFloat PSYMaxValue;
@property (nonatomic, assign) CGFloat PSYMinValue;

// DPO
@property (nonatomic, assign) CGFloat DPOMaxValue;
@property (nonatomic, assign) CGFloat DPOMinValue;

// ASI
@property (nonatomic, assign) CGFloat ASIMaxValue;
@property (nonatomic, assign) CGFloat ASIMinValue;



#pragma mark - method
// 初始化
+ (instancetype)dataHandler;

// K线
// 处理原始K线相关数据，处理成为K线模型数组
- (NSArray <YFStock_KLineModel *> *)handleAllKLineOriginDataArray:(NSArray *)KLineOriginDataArray topBarIndex:(YFStockTopBarIndex)topBarIndex;
// k线模型数据处理(当前绘制部分 drawKLineModels)
- (void)handleKLineModelDatasWithDrawKlineModelArray:(NSArray *)drawKLineModelArray pointStartX:(CGFloat)pointStartX KLineViewHeight:(CGFloat)KLineViewHeight volumeViewHeight:(CGFloat)volumeViewHeight bottomBarIndex:(YFStockBottomBarIndex)bottomBarIndex;
- (NSMutableAttributedString *)getKLineAboveViewLeftLabelTextWithKLineModel:(YFStock_KLineModel *)KLineModel type:(NSInteger)type;
- (NSMutableAttributedString *)getKLineBelowViewLeftLabelTextWithKLineModel:(YFStock_KLineModel *)KLineModel type:(YFStockBottomBarIndex)type;

// 分时线
// 处理原始分时线相关数据，处理成为分时线模型数组
- (NSArray <YFStock_TimeLineModel *> *)handleAllTimeLineOriginDataArray:(NSArray *)timeLineOriginDataArray topBarIndex:(YFStockTopBarIndex)topBarIndex;
// 分时线模型数据处理（当前绘制部分，实际是所有，因为无缩放功能）
- (void)handleTimeLineModelDatasWithDrawTimeLineModelArray:(NSArray *)drawTimeLineModelArray timeLineViewHeight:(CGFloat)timeLineViewHeight;
// 获取分时分钟总数
- (NSInteger)timeLineTradingMinutesWithStockType:(NSString *)stockType;

@end
