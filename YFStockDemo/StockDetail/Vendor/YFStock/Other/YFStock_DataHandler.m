//
//  YFStock_DataHandler.m
//  YFStockDemo
//
//  Created by 李友富 on 2017/3/31.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import "YFStock_DataHandler.h"

@implementation YFStock_DataHandler

#pragma mark - 初始化
+ (instancetype)dataHandler {
    
    return [self new];
}

#pragma mark - TimeLine
- (NSArray<YFStock_TimeLineModel *> *)handleAllTimeLineOriginDataArray:(NSArray *)timeLineOriginDataArray topBarIndex:(YFStockTopBarIndex)topBarIndex {
    
    return [YFStock_TimeLineModel mj_objectArrayWithKeyValuesArray:timeLineOriginDataArray];
}

- (void)handleTimeLineModelDatasWithDrawTimeLineModelArray:(NSArray *)drawTimeLineModelArray timeLineViewHeight:(CGFloat)timeLineViewHeight {
    
    self.maxTimeLineValue = [[[drawTimeLineModelArray valueForKeyPath:@"bidPrice1"] valueForKeyPath:@"@max.floatValue"] floatValue];
    self.minTimeLineValue = [[[drawTimeLineModelArray valueForKeyPath:@"bidPrice1"] valueForKeyPath:@"@min.floatValue"] floatValue];
    self.avgTimeLineValue = [[[drawTimeLineModelArray valueForKeyPath:@"bidPrice1"] valueForKeyPath:@"@avg.floatValue"] floatValue];
    
    CGFloat timeLineMinY = kStockKLineViewKlineMinY;
    CGFloat timeLineMaxY = timeLineViewHeight - 2 * kStockKLineViewKlineMinY;
    CGFloat timeLineUnitValue = (self.maxTimeLineValue - self.minTimeLineValue) / (timeLineMaxY - timeLineMinY); // 原始值 / 坐标值
    if (timeLineUnitValue == 0) timeLineUnitValue = 0.01f;
    
    NSMutableArray *tempArray = [NSMutableArray new];
    
    __block CGFloat pointStartX = 0;
    [drawTimeLineModelArray enumerateObjectsUsingBlock:^(YFStock_TimeLineModel *timeLineModel, NSUInteger idx, BOOL * _Nonnull stop) {
       
        CGFloat y = timeLineMaxY - (timeLineModel.bidPrice1 - self.minTimeLineValue) / timeLineUnitValue;
        CGPoint pricePositionPoint = CGPointMake(pointStartX, y);
        timeLineModel.pricePositionPoint = pricePositionPoint;
        [tempArray addObject:timeLineModel];
        
        pointStartX += ([YFStock_Variable timeLineWidth] + [YFStock_Variable timeLineGap]);
    }];
    
    self.drawTimeLineModels = tempArray;
    
    self.avgTimeLinePositionY = timeLineMaxY - (self.avgTimeLineValue - self.minTimeLineValue) / timeLineUnitValue;
}

- (NSInteger)timeLineTradingMinutesWithStockType:(NSString *)stockType {
    
    NSInteger totalMinutes = 0;
    
    NSString *openTimeListPath = [[NSBundle mainBundle] pathForResource:@"OpenTimeList" ofType:@"plist"];
    NSDictionary *openTimeListDic = [NSDictionary dictionaryWithContentsOfFile:openTimeListPath];

    NSDictionary *openTimeInfoDic = openTimeListDic[stockType];

    CGFloat tradingHours = [openTimeInfoDic[@"tradingTime"] floatValue];
    
    totalMinutes = 60 * tradingHours;
    
    return totalMinutes;
}

#pragma mark - KLine
#pragma mark 处理原始数据
// 处理原始K线数据转为K线模型数组
- (NSMutableArray <YFStock_KLineModel *> *)handleAllKLineOriginDataArray:(NSArray *)KLineOriginDataArray topBarIndex:(YFStockTopBarIndex)topBarIndex {
    
    NSMutableArray *allKLineModelArray = [NSMutableArray new];

    for (int i = 0; i < KLineOriginDataArray.count; i ++) {
        
        NSDictionary *dic = KLineOriginDataArray[i];
        
        YFStock_KLineModel *KLineModel = [YFStock_KLineModel mj_objectWithKeyValues:dic];
        
        KLineModel.preAllModelArray = [allKLineModelArray copy]; // 必须copy，不然还会跟着改变
        
        if (i > 0) {
            
            [self handleTimeShowActionWithKLineModel:KLineModel topBarIndex:topBarIndex];
        }
        
        [allKLineModelArray addObject:KLineModel];
    }
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        for (int i = 0; i < allKLineModelArray.count; i ++) {
            
            YFStock_KLineModel *model = allKLineModelArray[i];
            
            model.allModelArray = [NSArray arrayWithArray:allKLineModelArray];
            
            [model initData];
            
            [allKLineModelArray replaceObjectAtIndex:i withObject:model];
        }
//    });

    return allKLineModelArray;

}

#pragma mark 处理时间显示事件
- (void)handleTimeShowActionWithKLineModel:(YFStock_KLineModel *)KLineModel topBarIndex:(YFStockTopBarIndex)topBarIndex {
    
    switch (topBarIndex) {
        case YFStockTopBarIndex_DayK:
        {
            NSInteger currentModelMonth = [[[KLineModel.dataTime substringFromIndex:5] substringToIndex:2] integerValue];
            NSInteger preModelMonth = [[[KLineModel.preModel.dataTime substringFromIndex:5] substringToIndex:2] integerValue];
            if (currentModelMonth != preModelMonth) {
                
                KLineModel.isShowTime = YES;
                KLineModel.showTimeStr = [KLineModel.dataTime substringToIndex:7];
            } else {
                
                KLineModel.isShowTime = NO;
            }
        }
            break;
        case YFStockTopBarIndex_WeekK:
        {
            NSInteger currentModelMonth = [[[KLineModel.dataTime substringFromIndex:5] substringToIndex:2] integerValue];
            NSInteger preModelMonth = [[[KLineModel.preModel.dataTime substringFromIndex:5] substringToIndex:2] integerValue];
            if ((currentModelMonth == 3 || currentModelMonth == 9 ) &&
                (currentModelMonth != preModelMonth)) { // 3月、9月？？？
                
                KLineModel.isShowTime = YES;
                KLineModel.showTimeStr = [KLineModel.dataTime substringToIndex:7];
            } else {
                
                KLineModel.isShowTime = NO;
            }
        }
            break;
        case YFStockTopBarIndex_MonthK:
        {
            NSInteger currentModelMonth = [[[KLineModel.dataTime substringFromIndex:5] substringToIndex:2] integerValue];
            NSInteger preModelMonth = [[[KLineModel.preModel.dataTime substringFromIndex:5] substringToIndex:2] integerValue];
            if ((currentModelMonth == 3 ) &&
                (currentModelMonth != preModelMonth)) { // 3月、9月？？？
                
                KLineModel.isShowTime = YES;
                KLineModel.showTimeStr = [KLineModel.dataTime substringToIndex:7];
            } else {
                
                KLineModel.isShowTime = NO;
            }
        }
            break;
        default:
        {
            KLineModel.isShowTime = NO;
        }
            break;
    }
}

#pragma mark 处理最大值、最小值和位置
// 处理需要绘制的K线模型数组(主要是处理position)
- (void)handleKLineModelDatasWithDrawKlineModelArray:(NSArray *)drawKLineModelArray pointStartX:(CGFloat)pointStartX KLineViewHeight:(CGFloat)KLineViewHeight volumeViewHeight:(CGFloat)volumeViewHeight bottomBarIndex:(YFStockBottomBarIndex)bottomBarIndex {
    
    [self getMaxValueMinValueWithDrawKlineModelArray:drawKLineModelArray bottomBarIndex:bottomBarIndex];

//    [self getPositionWithDrawKlineModelArray:drawKLineModelArray pointStartX:pointStartX KLineViewHeight:KLineViewHeight volumeViewHeight:volumeViewHeight bottomBarIndex:bottomBarIndex];
}

#pragma mark 处理最大最小值
- (void)getMaxValueMinValueWithDrawKlineModelArray:(NSArray *)drawKLineModelArray bottomBarIndex:(YFStockBottomBarIndex)bottomBarIndex {
    
    // K线
    [self handle_KLine_Max_Min_ValueWithDrawKLineModelArray:drawKLineModelArray];
    
    switch (bottomBarIndex) {
        case YFStockBottomBarIndex_MACD:
        {
            // MACD
            [self handle_MACD_Max_Min_ValueWithDrawKLineModelArray:drawKLineModelArray];
        }
            break;
        case YFStockBottomBarIndex_KDJ:
        {
            // KDJ
            [self handle_KDJ_Max_Min_ValueWithDrawKLineModelArray:drawKLineModelArray];
        }
            break;
        case YFStockBottomBarIndex_RSI:
        {
            // RSI
            [self handle_RSI_Max_Min_ValueWithDrawKLineModelArray:drawKLineModelArray];
        }
            break;
        case YFStockBottomBarIndex_ARBR:
        {
            // ARBR
            [self handle_ARBR_Max_Min_ValueWithDrawKLineModelArray:drawKLineModelArray];
        }
            break;
        case YFStockBottomBarIndex_OBV:
        {
            // OBV
            [self handle_OBV_Max_Min_ValueWithDrawKLineModelArray:drawKLineModelArray];
            
            // volume线
            [self handle_Volume_Max_Min_ValueWithDrawKLineModelArray:drawKLineModelArray];
        }
            break;
        case YFStockBottomBarIndex_WR:
        {
            // WR
            [self handle_WR_Max_Min_ValueWithDrawKLineModelArray:drawKLineModelArray];
        }
            break;
        case YFStockBottomBarIndex_EMV:
        {
            // EMV
            [self handle_EMV_Max_Min_ValueWithDrawKLineModelArray:drawKLineModelArray];
        }
            break;
        case YFStockBottomBarIndex_DMA:
        {
            // DMA
            [self handle_DMA_Max_Min_ValueWithDrawKLineModelArray:drawKLineModelArray];
        }
            break;
        case YFStockBottomBarIndex_CCI:
        {
            // CCI
            [self handle_CCI_Max_Min_ValueWithDrawKLineModelArray:drawKLineModelArray];
        }
            break;
        case YFStockBottomBarIndex_BIAS:
        {
            // BIAS
            [self handle_BIAS_Max_Min_ValueWithDrawKLineModelArray:drawKLineModelArray];
        }
            break;
        case YFStockBottomBarIndex_ROC:
        {
            // ROC
            [self handle_ROC_Max_Min_ValueWithDrawKLineModelArray:drawKLineModelArray];
        }
            break;
        case YFStockBottomBarIndex_MTM:
        {
            // MTM
            [self handle_MTM_Max_Min_ValueWithDrawKLineModelArray:drawKLineModelArray];
        }
            break;
        case YFStockBottomBarIndex_CR:
        {
            // CR
            [self handle_CR_Max_Min_ValueWithDrawKLineModelArray:drawKLineModelArray];
        }
            break;
        case YFStockBottomBarIndex_DMI:
        {
            // DMI
            [self handle_DMI_Max_Min_ValueWithDrawKLineModelArray:drawKLineModelArray];
        }
            break;
        case YFStockBottomBarIndex_VR:
        {
            // DMI
            [self handle_VR_Max_Min_ValueWithDrawKLineModelArray:drawKLineModelArray];
        }
            break;
            
        case YFStockBottomBarIndex_TRXI:
        {
            // TRIX
            [self handle_TRIX_Max_Min_ValueWithDrawKLineModelArray:drawKLineModelArray];
        }
            break;
        case YFStockBottomBarIndex_PSY:
        {
            // PSY
            [self handle_PSY_Max_Min_ValueWithDrawKLineModelArray:drawKLineModelArray];
        }
            break;
        case YFStockBottomBarIndex_DPO:
        {
            // DPO
            [self handle_DPO_Max_Min_ValueWithDrawKLineModelArray:drawKLineModelArray];
        }
            break;
        case YFStockBottomBarIndex_ASI:
        {
            // ASI
            [self handle_ASI_Max_Min_ValueWithDrawKLineModelArray:drawKLineModelArray];
        }
            break;
            
        default:
            break;
    }
}

- (void)handle_KLine_Max_Min_ValueWithDrawKLineModelArray:(NSArray <YFStock_KLineModel *> *)drawKLineModelArray {
    
    CGFloat max =  [[[drawKLineModelArray valueForKeyPath:@"highPrice"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat MA5max =  [[[drawKLineModelArray valueForKeyPath:@"MA_5"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat MA10max =  [[[drawKLineModelArray valueForKeyPath:@"MA_10"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat MA20max =  [[[drawKLineModelArray valueForKeyPath:@"MA_20"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat MA30max =  [[[drawKLineModelArray valueForKeyPath:@"MA_30"] valueForKeyPath:@"@max.floatValue"] floatValue];
    
    // 取 highPrice、所有MA值的最大值为K线的最大值
    max = MAX(MAX(MAX(MAX(MA5max, MA10max), MA20max), MA30max), max);
    
    __block CGFloat min = [[[drawKLineModelArray valueForKeyPath:@"lowPrice"] valueForKeyPath:@"@min.floatValue"] floatValue];
    
    // 取 lowPrice、所有【有效】MA值的最小值为K线的最小值
    [drawKLineModelArray enumerateObjectsUsingBlock:^(YFStock_KLineModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat MA5 = obj.MA_5.floatValue;
        CGFloat MA10 = obj.MA_10.floatValue;
        CGFloat MA20 = obj.MA_20.floatValue;
        CGFloat MA30 = obj.MA_30.floatValue;
        
        if (MA5 > 0 && MA5 < min) {
            
            min = MA5;
        }
        if (MA10 > 0 && MA10 < min) {
            
            min = MA10;
        }
        if (MA20 > 0 && MA20 < min) {
            
            min = MA20;
        }
        if (MA30 > 0 && MA30 < min) {
            
            min = MA30;
        }
    }];
    
    //    CGFloat BOLL_UPPERmax =  [[[drawKLineModelArray valueForKeyPath:@"BOLL_UPPER"] valueForKeyPath:@"@max.floatValue"] floatValue];
    //    CGFloat BOLL_MIDmax =  [[[drawKLineModelArray valueForKeyPath:@"BOLL_MID"] valueForKeyPath:@"@max.floatValue"] floatValue];
    //    CGFloat BOLL_LOWERmax =  [[[drawKLineModelArray valueForKeyPath:@"BOLL_LOWER"] valueForKeyPath:@"@max.floatValue"] floatValue];
    //
    //    CGFloat BOLL_UPPERmin =  [[[drawKLineModelArray valueForKeyPath:@"BOLL_UPPER"] valueForKeyPath:@"@min.floatValue"] floatValue];
    //    CGFloat BOLL_MIDmin =  [[[drawKLineModelArray valueForKeyPath:@"BOLL_MID"] valueForKeyPath:@"@min.floatValue"] floatValue];
    //    CGFloat BOLL_LOWERmin =  [[[drawKLineModelArray valueForKeyPath:@"BOLL_LOWER"] valueForKeyPath:@"@min.floatValue"] floatValue];
    //
    //    max = MAX(max, MAX(BOLL_UPPERmax, MAX(BOLL_MIDmax, BOLL_LOWERmax)));
    //    min = MIN(min, MIN(BOLL_UPPERmin, MIN(BOLL_MIDmin, BOLL_LOWERmin)));
    
//    if (self.maxKLineValue != max || self.minKLineValue != min) {
//        
//        self.maxKLineValue = max;
//        self.minKLineValue = min;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"KLineAboveMaxMinValueChanged" object:@[ @(self.maxKLineValue), @(self.minKLineValue) ]];
//    }
    
    self.maxKLineValue = max;
    self.minKLineValue = min;
}

- (void)handle_Volume_Max_Min_ValueWithDrawKLineModelArray:(NSArray <YFStock_KLineModel *> *)drawKLineModelArray {
    
    self.minVolumeLineValue =  0;
    self.maxVolumeLineValue =  [[[drawKLineModelArray valueForKeyPath:@"volume"] valueForKeyPath:@"@max.floatValue"] floatValue];
}

- (void)handle_MACD_Max_Min_ValueWithDrawKLineModelArray:(NSArray <YFStock_KLineModel *> *)drawKLineModelArray {
    
    CGFloat maxDIFF = [[[drawKLineModelArray valueForKeyPath:@"MACD_DIF"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat maxDEA = [[[drawKLineModelArray valueForKeyPath:@"MACD_DEA"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat maxMACD = [[[drawKLineModelArray valueForKeyPath:@"MACD_BAR"] valueForKeyPath:@"@max.floatValue"] floatValue];
    
    CGFloat minDIFF = [[[drawKLineModelArray valueForKeyPath:@"MACD_DIF"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat minDEA = [[[drawKLineModelArray valueForKeyPath:@"MACD_DEA"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat minMACD = [[[drawKLineModelArray valueForKeyPath:@"MACD_BAR"] valueForKeyPath:@"@min.floatValue"] floatValue];
    
    self.MACDMaxValue = MAX(MAX(maxDIFF, maxDEA), maxMACD);
    self.MACDMinValue = MIN(MIN(minDIFF, minDEA), minMACD);
    
    self.MACDMaxValue = ABS(self.MACDMaxValue) > ABS(self.MACDMinValue) ? ABS(self.MACDMaxValue) : ABS(self.MACDMinValue);
    self.MACDMinValue = -self.MACDMaxValue;
}

- (void)handle_KDJ_Max_Min_ValueWithDrawKLineModelArray:(NSArray <YFStock_KLineModel *> *)drawKLineModelArray {
    
    CGFloat maxK = [[[drawKLineModelArray valueForKeyPath:@"KDJ_K"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat maxD = [[[drawKLineModelArray valueForKeyPath:@"KDJ_D"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat maxJ = [[[drawKLineModelArray valueForKeyPath:@"KDJ_J"] valueForKeyPath:@"@max.floatValue"] floatValue];
    
    CGFloat minK = [[[drawKLineModelArray valueForKeyPath:@"KDJ_K"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat minD = [[[drawKLineModelArray valueForKeyPath:@"KDJ_D"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat minJ = [[[drawKLineModelArray valueForKeyPath:@"KDJ_J"] valueForKeyPath:@"@min.floatValue"] floatValue];
    
    self.KDJMaxValue = MAX(MAX(maxK, maxD), maxJ);
    self.KDJMinValue = MIN(MIN(minK, minD), minJ);
}

- (void)handle_RSI_Max_Min_ValueWithDrawKLineModelArray:(NSArray <YFStock_KLineModel *> *)drawKLineModelArray {
    
    CGFloat maxRSI_6 = [[[drawKLineModelArray valueForKeyPath:@"RSI_6"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat maxRSI_12 = [[[drawKLineModelArray valueForKeyPath:@"RSI_12"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat maxRSI_24 = [[[drawKLineModelArray valueForKeyPath:@"RSI_24"] valueForKeyPath:@"@max.floatValue"] floatValue];
    
    CGFloat minRSI_6 = [[[drawKLineModelArray valueForKeyPath:@"RSI_6"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat minRSI_12 = [[[drawKLineModelArray valueForKeyPath:@"RSI_12"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat minRSI_24 = [[[drawKLineModelArray valueForKeyPath:@"RSI_24"] valueForKeyPath:@"@min.floatValue"] floatValue];
    
    self.RSIMaxValue = MAX(MAX(maxRSI_6, maxRSI_12), maxRSI_24);
    self.RSIMinValue = MIN(MIN(minRSI_6, minRSI_12), minRSI_24);
}

- (void)handle_ARBR_Max_Min_ValueWithDrawKLineModelArray:(NSArray <YFStock_KLineModel *> *)drawKLineModelArray {
    
    CGFloat maxAR = [[[drawKLineModelArray valueForKeyPath:@"ARBR_AR"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat maxBR = [[[drawKLineModelArray valueForKeyPath:@"ARBR_BR"] valueForKeyPath:@"@max.floatValue"] floatValue];
    
    CGFloat minAR = [[[drawKLineModelArray valueForKeyPath:@"ARBR_AR"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat minBR = [[[drawKLineModelArray valueForKeyPath:@"ARBR_BR"] valueForKeyPath:@"@min.floatValue"] floatValue];
    
    self.ARBRMaxValue = MAX(maxAR, maxBR);
    self.ARBRMinValue = MIN(minAR, minBR);
}

- (void)handle_OBV_Max_Min_ValueWithDrawKLineModelArray:(NSArray <YFStock_KLineModel *> *)drawKLineModelArray {
    
    CGFloat maxOBV = [[[drawKLineModelArray valueForKeyPath:@"OBV"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat minOBV = [[[drawKLineModelArray valueForKeyPath:@"OBV"] valueForKeyPath:@"@min.floatValue"] floatValue];
    
    self.OBVMaxValue = maxOBV;
    self.OBVMinValue = minOBV;
}

- (void)handle_WR_Max_Min_ValueWithDrawKLineModelArray:(NSArray <YFStock_KLineModel *> *)drawKLineModelArray {
    
    CGFloat maxWR_1 = [[[drawKLineModelArray valueForKeyPath:@"WR_1"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat maxWR_2 = [[[drawKLineModelArray valueForKeyPath:@"WR_2"] valueForKeyPath:@"@max.floatValue"] floatValue];
    
    CGFloat minWR_1 = [[[drawKLineModelArray valueForKeyPath:@"WR_1"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat minWR_2 = [[[drawKLineModelArray valueForKeyPath:@"WR_2"] valueForKeyPath:@"@min.floatValue"] floatValue];
    
    self.WRMaxValue = MAX(maxWR_1, maxWR_2);
    self.WRMinValue = MIN(minWR_1, minWR_2);
}

- (void)handle_EMV_Max_Min_ValueWithDrawKLineModelArray:(NSArray <YFStock_KLineModel *> *)drawKLineModelArray {
    
    CGFloat maxEMV = [[[drawKLineModelArray valueForKeyPath:@"EMV"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat maxEMV_MA = [[[drawKLineModelArray valueForKeyPath:@"EMV_MA"] valueForKeyPath:@"@max.floatValue"] floatValue];
    
    CGFloat minEMV = [[[drawKLineModelArray valueForKeyPath:@"EMV"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat minEMV_MA = [[[drawKLineModelArray valueForKeyPath:@"EMV_MA"] valueForKeyPath:@"@min.floatValue"] floatValue];
    
    self.EMVMaxValue = MAX(maxEMV, maxEMV_MA);
    self.EMVMinValue = MIN(minEMV, minEMV_MA);
}

- (void)handle_DMA_Max_Min_ValueWithDrawKLineModelArray:(NSArray <YFStock_KLineModel *> *)drawKLineModelArray {
    
    CGFloat maxDDD = [[[drawKLineModelArray valueForKeyPath:@"DDD"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat maxAMA = [[[drawKLineModelArray valueForKeyPath:@"AMA"] valueForKeyPath:@"@max.floatValue"] floatValue];
    
    CGFloat minDDD = [[[drawKLineModelArray valueForKeyPath:@"DDD"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat minAMA= [[[drawKLineModelArray valueForKeyPath:@"AMA"] valueForKeyPath:@"@min.floatValue"] floatValue];
    
    self.DMAMaxValue = MAX(maxDDD, maxAMA);
    self.DMAMinValue = MIN(minDDD, minAMA);
}

- (void)handle_CCI_Max_Min_ValueWithDrawKLineModelArray:(NSArray <YFStock_KLineModel *> *)drawKLineModelArray {
    
    CGFloat maxCCI = [[[drawKLineModelArray valueForKeyPath:@"CCI"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat minCCI = [[[drawKLineModelArray valueForKeyPath:@"CCI"] valueForKeyPath:@"@min.floatValue"] floatValue];
    
    self.CCIMaxValue = maxCCI;
    self.CCIMinValue = minCCI;
}

- (void)handle_BIAS_Max_Min_ValueWithDrawKLineModelArray:(NSArray <YFStock_KLineModel *> *)drawKLineModelArray {
    
    CGFloat maxBIAS1 = [[[drawKLineModelArray valueForKeyPath:@"BIAS_1"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat maxBIAS2 = [[[drawKLineModelArray valueForKeyPath:@"BIAS_2"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat maxBIAS3 = [[[drawKLineModelArray valueForKeyPath:@"BIAS_3"] valueForKeyPath:@"@max.floatValue"] floatValue];
    
    CGFloat minBIAS1 = [[[drawKLineModelArray valueForKeyPath:@"BIAS_1"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat minBIAS2 = [[[drawKLineModelArray valueForKeyPath:@"BIAS_2"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat minBIAS3 = [[[drawKLineModelArray valueForKeyPath:@"BIAS_3"] valueForKeyPath:@"@min.floatValue"] floatValue];
    
    self.BIASMaxValue = MAX(maxBIAS1, MAX(maxBIAS2, maxBIAS3));
    self.BIASMinValue = MIN(minBIAS1, MIN(minBIAS2, minBIAS3));
}

- (void)handle_ROC_Max_Min_ValueWithDrawKLineModelArray:(NSArray <YFStock_KLineModel *> *)drawKLineModelArray {
    
    CGFloat maxROC = [[[drawKLineModelArray valueForKeyPath:@"ROC"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat maxROC_MA = [[[drawKLineModelArray valueForKeyPath:@"ROC_MA"] valueForKeyPath:@"@max.floatValue"] floatValue];
    
    CGFloat minROC = [[[drawKLineModelArray valueForKeyPath:@"ROC"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat minROC_MA = [[[drawKLineModelArray valueForKeyPath:@"ROC_MA"] valueForKeyPath:@"@min.floatValue"] floatValue];
    
    self.ROCMaxValue = MAX(maxROC, maxROC_MA);
    self.ROCMinValue = MIN(minROC, minROC_MA);
}

- (void)handle_MTM_Max_Min_ValueWithDrawKLineModelArray:(NSArray <YFStock_KLineModel *> *)drawKLineModelArray {
    
    CGFloat maxMTM = [[[drawKLineModelArray valueForKeyPath:@"MTM"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat maxMTM_MA = [[[drawKLineModelArray valueForKeyPath:@"MTM_MA"] valueForKeyPath:@"@max.floatValue"] floatValue];
    
    CGFloat minMTM = [[[drawKLineModelArray valueForKeyPath:@"MTM"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat minMTM_MA = [[[drawKLineModelArray valueForKeyPath:@"MTM_MA"] valueForKeyPath:@"@min.floatValue"] floatValue];
    
    self.MTMMaxValue = MAX(maxMTM, maxMTM_MA);
    self.MTMMinValue = MIN(minMTM, minMTM_MA);
}

- (void)handle_CR_Max_Min_ValueWithDrawKLineModelArray:(NSArray <YFStock_KLineModel *> *)drawKLineModelArray {
    
    CGFloat maxCR = [[[drawKLineModelArray valueForKeyPath:@"CR"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat maxCR_MA_1 = [[[drawKLineModelArray valueForKeyPath:@"CR_MA_1"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat maxCR_MA_2 = [[[drawKLineModelArray valueForKeyPath:@"CR_MA_2"] valueForKeyPath:@"@max.floatValue"] floatValue];

    CGFloat minCR = [[[drawKLineModelArray valueForKeyPath:@"CR"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat minCR_MA_1 = [[[drawKLineModelArray valueForKeyPath:@"CR_MA_1"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat minCR_MA_2 = [[[drawKLineModelArray valueForKeyPath:@"CR_MA_2"] valueForKeyPath:@"@min.floatValue"] floatValue];

    self.CRMaxValue = MAX(maxCR, MAX(maxCR_MA_1, maxCR_MA_2));
    self.CRMinValue = MIN(minCR, MIN(minCR_MA_1, minCR_MA_2));
}

- (void)handle_DMI_Max_Min_ValueWithDrawKLineModelArray:(NSArray <YFStock_KLineModel *> *)drawKLineModelArray {
    
    CGFloat maxDMI_PDI = [[[drawKLineModelArray valueForKeyPath:@"DMI_PDI"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat maxDMI_MDI = [[[drawKLineModelArray valueForKeyPath:@"DMI_MDI"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat maxDMI_ADX = [[[drawKLineModelArray valueForKeyPath:@"DMI_ADX"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat maxDMI_ADXR = [[[drawKLineModelArray valueForKeyPath:@"DMI_ADXR"] valueForKeyPath:@"@max.floatValue"] floatValue];

    CGFloat minDMI_PDI = [[[drawKLineModelArray valueForKeyPath:@"DMI_PDI"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat minDMI_MDI = [[[drawKLineModelArray valueForKeyPath:@"DMI_MDI"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat minDMI_ADX = [[[drawKLineModelArray valueForKeyPath:@"DMI_ADX"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat minDMI_ADXR = [[[drawKLineModelArray valueForKeyPath:@"DMI_ADXR"] valueForKeyPath:@"@min.floatValue"] floatValue];
    
    self.DMIMaxValue = MAX(maxDMI_PDI, MAX(maxDMI_MDI, MAX(maxDMI_ADX, maxDMI_ADXR)));
    self.DMIMinValue = MIN(minDMI_PDI, MIN(minDMI_MDI, MIN(minDMI_ADX, minDMI_ADXR)));

}

- (void)handle_VR_Max_Min_ValueWithDrawKLineModelArray:(NSArray <YFStock_KLineModel *> *)drawKLineModelArray {
    
    CGFloat maxVR = [[[drawKLineModelArray valueForKeyPath:@"VR"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat maxVR_MA = [[[drawKLineModelArray valueForKeyPath:@"VR_MA"] valueForKeyPath:@"@max.floatValue"] floatValue];
    
    CGFloat minVR = [[[drawKLineModelArray valueForKeyPath:@"VR"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat minVR_MA = [[[drawKLineModelArray valueForKeyPath:@"VR_MA"] valueForKeyPath:@"@min.floatValue"] floatValue];
    
    self.VRMaxValue = MAX(maxVR, maxVR_MA);
    self.VRMinValue = MIN(minVR, minVR_MA);
}

- (void)handle_TRIX_Max_Min_ValueWithDrawKLineModelArray:(NSArray <YFStock_KLineModel *> *)drawKLineModelArray {
    
    CGFloat maxTRIX = [[[drawKLineModelArray valueForKeyPath:@"TRIX"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat maxTRIX_MA = [[[drawKLineModelArray valueForKeyPath:@"TRIX_MA"] valueForKeyPath:@"@max.floatValue"] floatValue];
    
    CGFloat minTRIX = [[[drawKLineModelArray valueForKeyPath:@"TRIX"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat minTRIX_MA = [[[drawKLineModelArray valueForKeyPath:@"TRIX_MA"] valueForKeyPath:@"@min.floatValue"] floatValue];
    
    self.TRIXMaxValue = MAX(maxTRIX, maxTRIX_MA);
    self.TRIXMinValue = MIN(minTRIX, minTRIX_MA);
}

- (void)handle_PSY_Max_Min_ValueWithDrawKLineModelArray:(NSArray <YFStock_KLineModel *> *)drawKLineModelArray {
    
    CGFloat maxPSY = [[[drawKLineModelArray valueForKeyPath:@"PSY"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat maxPSY_MA = [[[drawKLineModelArray valueForKeyPath:@"PSY_MA"] valueForKeyPath:@"@max.floatValue"] floatValue];
    
    CGFloat minPSY = [[[drawKLineModelArray valueForKeyPath:@"PSY"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat minPSY_MA = [[[drawKLineModelArray valueForKeyPath:@"PSY_MA"] valueForKeyPath:@"@min.floatValue"] floatValue];
    
    self.PSYMaxValue = MAX(maxPSY, maxPSY_MA);
    self.PSYMinValue = MIN(minPSY, minPSY_MA);
}

- (void)handle_DPO_Max_Min_ValueWithDrawKLineModelArray:(NSArray <YFStock_KLineModel *> *)drawKLineModelArray {
    
    CGFloat maxDPO = [[[drawKLineModelArray valueForKeyPath:@"DPO"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat maxDPO_MA = [[[drawKLineModelArray valueForKeyPath:@"DPO_MA"] valueForKeyPath:@"@max.floatValue"] floatValue];
    
    CGFloat minDPO = [[[drawKLineModelArray valueForKeyPath:@"DPO"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat minDPO_MA = [[[drawKLineModelArray valueForKeyPath:@"DPO_MA"] valueForKeyPath:@"@min.floatValue"] floatValue];
    
    self.DPOMaxValue = MAX(maxDPO, maxDPO_MA);
    self.DPOMinValue = MIN(minDPO, minDPO_MA);
}

- (void)handle_ASI_Max_Min_ValueWithDrawKLineModelArray:(NSArray <YFStock_KLineModel *> *)drawKLineModelArray {
    
    CGFloat maxASI = [[[drawKLineModelArray valueForKeyPath:@"ASI"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat maxASI_MA = [[[drawKLineModelArray valueForKeyPath:@"ASI_MA"] valueForKeyPath:@"@max.floatValue"] floatValue];
    
    CGFloat minASI = [[[drawKLineModelArray valueForKeyPath:@"ASI"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat minASI_MA = [[[drawKLineModelArray valueForKeyPath:@"ASI_MA"] valueForKeyPath:@"@min.floatValue"] floatValue];
    
    self.ASIMaxValue = MAX(maxASI, maxASI_MA);
    self.ASIMinValue = MIN(minASI, minASI_MA);
    
}

//#pragma mark - 处理位置
//// 获取 K线 的以及 volume线 的坐标转换 macd kdj 等
//- (void)getPositionWithDrawKlineModelArray:(NSArray *)drawKLineModelArray pointStartX:(CGFloat)pointStartX KLineViewHeight:(CGFloat)KLineViewHeight volumeViewHeight:(CGFloat)volumeViewHeight bottomBarIndex:(YFStockBottomBarIndex)bottomBarIndex {
//    
//    
//    NSMutableArray *tempDrawKLineModels = [NSMutableArray new];
//    
//    // MinY MaxY
//    CGFloat KLineMinY = kStockKLineViewKlineMinY;
//    CGFloat KLineMaxY = KLineViewHeight - 1 * kStockKLineViewKlineMinY;
//    
//    CGFloat volumeLineMinY = kStockVolumeLineViewVolumeLineMinY;
//    CGFloat volumeLineMaxY = volumeViewHeight; // 到底部
//    
//    CGFloat bottomNormalMinY = kStockVolumeLineViewVolumeLineMinY;
//    CGFloat bottomNormalMaxY = volumeViewHeight - 2 * kStockVolumeLineViewVolumeLineMinY;
//    
//    // k line
//    CGFloat KLineUnitValue = (self.maxKLineValue - self.minKLineValue) / (KLineMaxY - KLineMinY);
//    if (KLineUnitValue == 0) KLineUnitValue = 0.01f;
//    
//    // volume line
//    CGFloat volumeLineUnitValue = (self.maxVolumeLineValue - self.minVolumeLineValue) / (volumeLineMaxY - volumeLineMinY);
//    if (volumeLineUnitValue == 0) volumeLineUnitValue = 0.01f;
//    
//    // MACD line
//    CGFloat MACDLineUnitValue = (self.MACDMaxValue - self.MACDMinValue) / (bottomNormalMinY - bottomNormalMaxY);
//    if (MACDLineUnitValue == 0) MACDLineUnitValue = 0.01f;
//    
//    // KDJ line
//    CGFloat KDJLineUnitValue = (self.KDJMaxValue - self.KDJMinValue) / (bottomNormalMaxY - bottomNormalMinY);
//    if (KDJLineUnitValue == 0) KDJLineUnitValue = 0.01f;
//    
//    // RSI
//    CGFloat RSILineUnitValue = (self.RSIMaxValue - self.RSIMinValue) / (bottomNormalMaxY - bottomNormalMinY);
//    if (RSILineUnitValue == 0) RSILineUnitValue = 0.01f;
//    
//    // ARBR
//    CGFloat ARBRLineUnitValue = (self.ARBRMaxValue - self.ARBRMinValue) / (bottomNormalMaxY - bottomNormalMinY);
//    if (ARBRLineUnitValue == 0) ARBRLineUnitValue = 0.01f;
//    
//    // OBV
//    CGFloat OBVLineUnitValue = (self.OBVMaxValue - self.OBVMinValue) / (bottomNormalMaxY - bottomNormalMinY);
//    if (OBVLineUnitValue == 0) OBVLineUnitValue = 0.01f;
//    
//    // WR
//    CGFloat WRLineUnitValue = (self.WRMaxValue - self.WRMinValue) / (bottomNormalMaxY - bottomNormalMinY);
//    if (WRLineUnitValue == 0) WRLineUnitValue = 0.01f;
//    
//    // EMV
//    CGFloat EMVLineUnitValue = (self.EMVMaxValue - self.EMVMinValue) / (bottomNormalMaxY - bottomNormalMinY);
//    if (EMVLineUnitValue == 0) EMVLineUnitValue = 0.01f;
//    
//    // DMA
//    CGFloat DMALineUnitValue = (self.DMAMaxValue - self.DMAMinValue) / (bottomNormalMaxY - bottomNormalMinY);
//    if (DMALineUnitValue == 0) DMALineUnitValue = 0.01f;
//    
//    // CCI
//    CGFloat CCILineUnitValue = (self.CCIMaxValue - self.CCIMinValue) / (bottomNormalMaxY - bottomNormalMinY);
//    if (CCILineUnitValue == 0) CCILineUnitValue = 0.01f;
//    
//    // BIAS
//    CGFloat BIASLineUnitValue = (self.BIASMaxValue - self.BIASMinValue) / (bottomNormalMaxY - bottomNormalMinY);
//    if (BIASLineUnitValue == 0) BIASLineUnitValue = 0.01f;
//    
//    // ROC
//    CGFloat ROCLineUnitValue = (self.ROCMaxValue - self.ROCMinValue) / (bottomNormalMaxY - bottomNormalMinY);
//    if (ROCLineUnitValue == 0) ROCLineUnitValue = 0.01f;
//    
//    // MTM
//    CGFloat MTMLineUnitValue = (self.MTMMaxValue - self.MTMMinValue) / (bottomNormalMaxY - bottomNormalMinY);
//    if (MTMLineUnitValue == 0) MTMLineUnitValue = 0.01f;
//    
//    // CR
//    CGFloat CRLineUnitValue = (self.CRMaxValue - self.CRMinValue) / (bottomNormalMaxY - bottomNormalMinY);
//    if (CRLineUnitValue == 0) CRLineUnitValue = 0.01f;
//    
//    // DMI
//    CGFloat DMILineUnitValue = (self.DMIMaxValue - self.DMIMinValue) / (bottomNormalMaxY - bottomNormalMinY);
//    if (DMILineUnitValue == 0) DMILineUnitValue = 0.01f;
//    
//    // VR
//    CGFloat VRLineUnitValue = (self.VRMaxValue - self.VRMinValue) / (bottomNormalMaxY - bottomNormalMinY);
//    if (VRLineUnitValue == 0) VRLineUnitValue = 0.01f;
//    
//    // TRIX
//    CGFloat TRIXLineUnitValue = (self.TRIXMaxValue - self.TRIXMinValue) / (bottomNormalMaxY - bottomNormalMinY);
//    if (TRIXLineUnitValue == 0) TRIXLineUnitValue = 0.01f;
//    
//    // PSY
//    CGFloat PSYLineUnitValue = (self.PSYMaxValue - self.PSYMinValue) / (bottomNormalMaxY - bottomNormalMinY);
//    if (PSYLineUnitValue == 0) PSYLineUnitValue = 0.01f;
//    
//    // DPO
//    CGFloat DPOLineUnitValue = (self.DPOMaxValue - self.DPOMinValue) / (bottomNormalMaxY - bottomNormalMinY);
//    if (DPOLineUnitValue == 0) DPOLineUnitValue = 0.01f;
//
//    // ASI
//    CGFloat ASILineUnitValue = (self.ASIMaxValue - self.ASIMinValue) / (bottomNormalMaxY - bottomNormalMinY);
//    if (ASILineUnitValue == 0) ASILineUnitValue = 0.01f;
//    
//    // 便利
//    [drawKLineModelArray enumerateObjectsUsingBlock:^(YFStock_KLineModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//#pragma mark - K线
//        CGFloat xPosition = pointStartX + idx * ([YFStock_Variable KLineWidth] + [YFStock_Variable KLineGap]);
//        
//        CGPoint highPoint = CGPointMake(xPosition, ABS(KLineMaxY - (model.highPrice.floatValue - self.minKLineValue) / KLineUnitValue));
//        CGPoint lowPoint = CGPointMake(xPosition, ABS(KLineMaxY - (model.lowPrice.floatValue - self.minKLineValue) / KLineUnitValue));
//        CGPoint openPoint = CGPointMake(xPosition, ABS(KLineMaxY - (model.openPrice.floatValue - self.minKLineValue) / KLineUnitValue));
//        CGFloat closePointY = ABS(KLineMaxY - (model.closePrice.floatValue - self.minKLineValue) / KLineUnitValue);
//        
//        //格式化openPoint和closePointY
//        if(ABS(closePointY - openPoint.y) < kStockKLineKlineMinThick) { // open 跟 close 的 y 非常相近
//            
//            if(openPoint.y > closePointY) { // 小者不变，大者更大
//                
//                openPoint.y = closePointY + kStockKLineKlineMinThick;
//                
//            } else if(openPoint.y < closePointY) {
//                
//                closePointY = openPoint.y + kStockKLineKlineMinThick;
//            } else { // openPointY == closePointY
//                
//                if(idx > 0) {
//
//                    if(model.openPrice > model.preModel.closePrice) {
//
//                        openPoint.y = closePointY + kStockKLineKlineMinThick;
//                    } else {
//
//                        closePointY = openPoint.y + kStockKLineKlineMinThick;
//                    }
//                } else if(idx + 1 < drawKLineModelArray.count) {
//                    
//                    // idx == 0 即第一个时
////                    id<YYLineDataModelProtocol> subKLineModel = drawKLineModels[idx+1];
////                    if(model.Close.floatValue < subKLineModel.Open.floatValue) {
////                        openPoint.y = closePointY + YYStockLineMinThick;
////                    } else {
////                        closePointY = openPoint.y + kStockKLineKlineMinThick;
////                    }
//                } else {
//                    
//                    openPoint.y = closePointY - kStockKLineKlineMinThick;
//                }
//            }
//        }
//        
//        CGPoint closePoint = CGPointMake(xPosition, closePointY);
//        
//        model.openPricePositionPoint = openPoint;
//        model.closePricePositionPoint = closePoint;
//        model.highPricePositionPoint = highPoint;
//        model.lowPricePositionPoint = lowPoint;
//        
//#pragma mark - volume线
//        CGFloat yPosition = ABS(volumeLineMaxY - (model.volume.integerValue - self.minVolumeLineValue) / volumeLineUnitValue); // start 的 y
//        CGPoint startPoint = CGPointMake(xPosition, (ABS(yPosition - volumeLineMaxY) > 0 && ABS(yPosition - volumeLineMaxY) < 0.5) ? volumeLineMaxY - 0.5 : yPosition);
//        CGPoint endPoint = CGPointMake(xPosition, volumeLineMaxY);
//
//        model.volumeStartPositionPoint = startPoint; // 上↑
//        model.volumeEndPositionPoint = endPoint; // 下↓
//        
//#pragma mark - MA线
//        model.MA_5PositionPoint = CGPointMake(xPosition, ABS(KLineMaxY - (model.MA_5.floatValue - self.minKLineValue) / KLineUnitValue));
//        model.MA_10PositionPoint = CGPointMake(xPosition, ABS(KLineMaxY - (model.MA_10.floatValue - self.minKLineValue) / KLineUnitValue));
//        model.MA_20PositionPoint = CGPointMake(xPosition, ABS(KLineMaxY - (model.MA_20.floatValue - self.minKLineValue) / KLineUnitValue));
//        model.MA_30PositionPoint = CGPointMake(xPosition, ABS(KLineMaxY - (model.MA_30.floatValue - self.minKLineValue) / KLineUnitValue));
//
//#pragma mark - MACD
//        model.MACD_DIFPositionPoint = CGPointMake(xPosition, model.MACD_DIF.floatValue / MACDLineUnitValue + volumeViewHeight * 0.5);
//        model.MACD_DEAPositionPoint = CGPointMake(xPosition, model.MACD_DEA.floatValue / MACDLineUnitValue + volumeViewHeight * 0.5);
//        model.MACD_BARStartPositionPoint = CGPointMake(xPosition, volumeViewHeight * 0.5);
//        model.MACD_BAREndPositionPoint = CGPointMake(xPosition, model.MACD_BAR.floatValue / MACDLineUnitValue + volumeViewHeight * 0.5);
//        
//#pragma mark - KDJ
//        model.KDJ_KPositionPoint = CGPointMake(xPosition, bottomNormalMaxY - (model.KDJ_K.floatValue - self.KDJMinValue) / KDJLineUnitValue);
//        model.KDJ_DPositionPoint = CGPointMake(xPosition, bottomNormalMaxY - (model.KDJ_D.floatValue - self.KDJMinValue) / KDJLineUnitValue);
//        model.KDJ_JPositionPoint = CGPointMake(xPosition, bottomNormalMaxY - (model.KDJ_J.floatValue - self.KDJMinValue) / KDJLineUnitValue);
//        
//#pragma mark - RSI
//        model.RSI_6PositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.RSI_6.floatValue - self.RSIMinValue) / RSILineUnitValue));
//        model.RSI_12PositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.RSI_12.floatValue - self.RSIMinValue) / RSILineUnitValue));
//        model.RSI_24PositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.RSI_24.floatValue - self.RSIMinValue) / RSILineUnitValue));
//        
//#pragma mark - BOLL
//        model.BOLL_UpperPositionPoint = CGPointMake(xPosition, ABS(KLineMaxY - (model.BOLL_UPPER.floatValue - self.minKLineValue) / KLineUnitValue));
//        model.BOLL_MidPositionPoint = CGPointMake(xPosition, ABS(KLineMaxY - (model.BOLL_MID.floatValue - self.minKLineValue) / KLineUnitValue));
//        model.BOLL_LowerPositionPoint = CGPointMake(xPosition, ABS(KLineMaxY - (model.BOLL_LOWER.floatValue - self.minKLineValue) / KLineUnitValue));
//        
//#pragma mark - ARBR
//        model.ARBR_ARPositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.ARBR_AR.floatValue - self.ARBRMinValue) / ARBRLineUnitValue));
//        model.ARBR_BRPositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.ARBR_BR.floatValue - self.ARBRMinValue) / ARBRLineUnitValue));
//        
//#pragma mark - OBV
//        model.OBVPositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.OBV.floatValue - self.OBVMinValue) / OBVLineUnitValue));
//
//#pragma mark - WR
//        model.WR_1PositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.WR_1.floatValue - self.WRMinValue) / WRLineUnitValue));
//        model.WR_2PositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.WR_2.floatValue - self.WRMinValue) / WRLineUnitValue));
//        
//#pragma mark - EMV
//        model.EMVPositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.EMV.floatValue - self.EMVMinValue) / EMVLineUnitValue));
//        model.EMV_MAPositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.EMV_MA.floatValue - self.EMVMinValue) / EMVLineUnitValue));
//
//#pragma mark - DMA
//        model.DDDPositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.DDD.floatValue - self.DMAMinValue) / DMALineUnitValue));
//        model.AMAPositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.AMA.floatValue - self.DMAMinValue) / DMALineUnitValue));
//
//#pragma mark - CCI
//        model.CCIPositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.CCI.floatValue - self.CCIMinValue) / CCILineUnitValue));
//        
//#pragma mark - BIAS
//        model.BIAS_1PositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.BIAS_1.floatValue - self.BIASMinValue) / BIASLineUnitValue));
//        model.BIAS_2PositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.BIAS_2.floatValue - self.BIASMinValue) / BIASLineUnitValue));
//        model.BIAS_3PositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.BIAS_3.floatValue - self.BIASMinValue) / BIASLineUnitValue));
//
//#pragma mark - ROC
//        model.ROCPositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.ROC.floatValue - self.ROCMinValue) / ROCLineUnitValue));
//        model.ROC_MAPositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.ROC_MA.floatValue - self.ROCMinValue) / ROCLineUnitValue));
//        
//#pragma mark - MTM
//        model.MTMPositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.MTM.floatValue - self.MTMMinValue) / MTMLineUnitValue));
//        model.MTM_MAPositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.MTM_MA.floatValue - self.MTMMinValue) / MTMLineUnitValue));
//
//#pragma mark - CR
//        model.CRPositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.CR.floatValue - self.CRMinValue) / CRLineUnitValue));
//        model.CR_MA_1PositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.CR_MA_1.floatValue - self.CRMinValue) / CRLineUnitValue));
//        model.CR_MA_2PositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.CR_MA_2.floatValue - self.CRMinValue) / CRLineUnitValue));
//
//#pragma mark - DMI
//        model.DMI_PDIPositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.DMI_PDI.floatValue - self.DMIMinValue) / DMILineUnitValue));
//        model.DMI_MDIPositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.DMI_MDI.floatValue - self.DMIMinValue) / DMILineUnitValue));
//        model.DMI_ADXPositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.DMI_ADX.floatValue - self.DMIMinValue) / DMILineUnitValue));
//        model.DMI_ADXRPositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.DMI_ADXR.floatValue - self.DMIMinValue) / DMILineUnitValue));
//        
//#pragma mark - VR
//        model.VRPositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.VR.floatValue - self.VRMinValue) / VRLineUnitValue));
//        model.VR_MAPositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.VR_MA.floatValue - self.VRMinValue) / VRLineUnitValue));
//
//
//#pragma mark - TRIX
//        model.TRIXPositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.TRIX.floatValue - self.TRIXMinValue) / TRIXLineUnitValue));
//        model.TRIX_MAPositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.TRIX_MA.floatValue - self.TRIXMinValue) / TRIXLineUnitValue));
//
//#pragma mark - PSY
//        model.PSYPositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.PSY.floatValue - self.PSYMinValue) / PSYLineUnitValue));
//        model.PSY_MAPositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.PSY_MA.floatValue - self.PSYMinValue) / PSYLineUnitValue));
//
//#pragma mark - DPO
//        model.DPOPositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.DPO.floatValue - self.DPOMinValue) / DPOLineUnitValue));
//        model.DPO_MAPositionPoint = CGPointMake(xPosition, ABS(bottomNormalMaxY - (model.DPO_MA.floatValue - self.DPOMinValue) / DPOLineUnitValue));
//        
//#pragma mark - ASI
//        model.ASIPositionPoint = CGPointMake(xPosition, (bottomNormalMaxY - (model.ASI.floatValue - self.ASIMinValue) / ASILineUnitValue));
//        model.ASI_MAPositionPoint = CGPointMake(xPosition, (bottomNormalMaxY - (model.ASI_MA.floatValue - self.ASIMinValue) / ASILineUnitValue));
//
//        
//        [tempDrawKLineModels addObject:model];
//    }];
//    
//    self.drawKLineModels = tempDrawKLineModels;
//}

#pragma mark - lazy loading
- (NSArray<YFStock_KLineModel *> *)drawKLineModels {
    
    if (_drawKLineModels == nil) {
        
        _drawKLineModels = [NSArray new];
    }
    return _drawKLineModels;
}


@end
