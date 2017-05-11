//
//  YFStock_Model.m
//  GoldfishSpot
//
//  Created by 李友富 on 2017/4/20.
//  Copyright © 2017年 中泰荣科. All rights reserved.
//

#import "YFStock_KLineModel.h"
#import "MJExtension.h"
#import "YFStock_Header.h"

@interface YFStock_KLineModel()


@end

@implementation YFStock_KLineModel

- (void)initData {
    
    return;
    
    [self preModel];
    
    [self MA_5];
    [self MA_10];
    [self MA_20];
    [self MA_30];
    
    [self MACD_DIF];
    [self MACD_DEA];
    [self MACD_BAR];
    
    [self KDJ_K];
    [self KDJ_D];
    [self KDJ_J];
    
    [self RSI_6];
    [self RSI_12];
    [self RSI_24];
    
    [self BOLL_UPPER];
    [self BOLL_MID];
    [self BOLL_LOWER];
    
    [self ARBR_AR];
    [self ARBR_BR];
    
    [self OBV];
    
    [self WR_1];
    [self WR_2];
    
    [self CCI];
    
    [self DDD];
    [self AMA];
    
    [self BIAS_1];
    [self BIAS_2];
    [self BIAS_3];
    
    [self ROC];
    [self ROC_MA];
    
    [self MTM];
    [self MTM_MA];
    
    [self CR];
    [self CR_MA_1];
    [self CR_MA_2];
    
    [self DMI_PDI];
    [self DMI_MDI];
    [self DMI_ADX];
    [self DMI_ADXR];
    
    [self TRIX];
    [self TRIX_MA];
    
    [self PSY];
    [self PSY_MA];
    
}

//+ (NSDictionary *)mj_replacedKeyFromPropertyName {
//
//    return @{
//             @"MA_5" : @"MA5",
//             @"MA_10" : @"MA10",
//             @"MA_20" : @"MA20",
//             @"MA_30" : @"MA30",
//             };
//}

#pragma mark - Getter
- (YFStock_KLineModel *)preModel {
    
    if (! _preModel) {
        
        _preModel = self.preAllModelArray.lastObject;
    }
    
    return _preModel;
}

- (BOOL)isIncrease {
    
    if (self.openPrice.floatValue  < self.closePrice.floatValue) {
        
        return YES;
    } else if (self.openPrice.floatValue > self.closePrice.floatValue) {
        
        return NO;
    } else {
        
        if (self.openPrice.floatValue >= self.preModel.closePrice.floatValue) {
            
            return YES;
        } else {
            
            return NO;
        }
    }
}

- (NSNumber *)index {
    
    if (! _index) {
        
        _index = [NSNumber numberWithInteger:self.preAllModelArray.count];
    }
    return _index;
}

#pragma mark MA
- (NSNumber *)MA_5 {
    
    if (! _MA_5) {
        
        _MA_5 = [NSNumber numberWithFloat:[self getMAWithN:kStock_MA_5_N]];
    }
    return _MA_5;
}

- (NSNumber *)MA_10 {
    
    if (! _MA_10) {
        
        _MA_10 = [NSNumber numberWithFloat:[self getMAWithN:kStock_MA_10_N]];
    }
    return _MA_10;
}

- (NSNumber *)MA_20 {
    
    if (! _MA_20) {
        
        _MA_20 = [NSNumber numberWithFloat:[self getMAWithN:kStock_MA_20_N]];
        
    }
    return _MA_20;
}

- (NSNumber *)MA_30 {
    
    if (! _MA_30) {
        
        _MA_30 = [NSNumber numberWithFloat:[self getMAWithN:kStock_MA_30_N]];
    }
    return _MA_30;
}

#pragma mark BOLL
- (NSNumber *)BOLL_UPPER {
    
    if (! _BOLL_UPPER) {
        
        _BOLL_UPPER = [NSNumber numberWithFloat:(self.BOLL_MID.floatValue + kStock_BOLL_K * [self getMDWithN:(kStock_BOLL_N - 1)])];
    }
    return _BOLL_UPPER;
}

- (NSNumber *)BOLL_MID {
    
    if (! _BOLL_MID) {
        
        _BOLL_MID = [NSNumber numberWithFloat:([self getMAWithN:(kStock_BOLL_N - 1)])];
    }
    return _BOLL_MID;
}

- (NSNumber *)BOLL_LOWER {
    
    if (! _BOLL_LOWER) {
        
        _BOLL_LOWER = [NSNumber numberWithFloat:(self.BOLL_MID.floatValue - kStock_BOLL_K * [self getMDWithN:(kStock_BOLL_N - 1)])];
    }
    return _BOLL_LOWER;
}

#pragma mark MACD
- (NSNumber *)MACD_DIF {
    
    if (! _MACD_DIF) {
        
        _MACD_DIF = @([self getEMAWithN:kStock_MACD_SHORT] - [self getEMAWithN:kStock_MACD_LONG]);
        
    }
    return _MACD_DIF;
}

- (NSNumber *)MACD_DEA {
    
    if (! _MACD_DEA) {
        
        _MACD_DEA = @((self.MACD_DIF.floatValue * 2 + self.preModel.MACD_DEA.floatValue * (kStock_MACD_MID - 1)) / (kStock_MACD_MID + 1));
    }
    return _MACD_DEA;
}

- (NSNumber *)MACD_BAR {
    
    if (! _MACD_BAR) {
        
        _MACD_BAR = @(2 * (self.MACD_DIF.floatValue - self.MACD_DEA.floatValue));
        
        if (_MACD_BAR.floatValue < 0.5 && _MACD_BAR.floatValue > 0) {
            
            _MACD_BAR = @0.5;
        }
        if (_MACD_BAR.floatValue < 0 && _MACD_BAR.floatValue > -0.5) {
            
            _MACD_BAR = @(-0.5);
        }
    }
    return _MACD_BAR;
}

#pragma mark KDJ
- (NSNumber *)KDJ_K {
    
    if (! _KDJ_K) {
        
        _KDJ_K = [NSNumber numberWithFloat:(2.0 / 3.0 * self.preModel.KDJ_K.floatValue + 1.0 / 3.0 * [self getRSVWithN:kStock_KDJ_N])];
    }
    return _KDJ_K;
}

- (NSNumber *)KDJ_D {
    
    if (! _KDJ_D) {
        
        _KDJ_D = [NSNumber numberWithFloat:(2.0 / 3.0 * self.preModel.KDJ_D.floatValue + 1.0 / 3.0 * self.KDJ_K.floatValue)];
    }
    return _KDJ_D;
}

- (NSNumber *)KDJ_J {
    
    if (! _KDJ_J) {
        
        _KDJ_J = [NSNumber numberWithFloat:(3 * self.KDJ_K.floatValue - 2 * self.KDJ_D.floatValue)];
    }
    return _KDJ_J;
}

#pragma mark RSI
- (NSNumber *)RSI_6 {
    
    if (! _RSI_6) {
        
        CGFloat RSI = [self getRSIWithN:kStock_RSI_6_N];
        _RSI_6 = [NSNumber numberWithFloat:RSI];
    }
    return _RSI_6;
}

- (NSNumber *)RSI_12 {
    
    if (! _RSI_12) {
        
        CGFloat RSI = [self getRSIWithN:kStock_RSI_12_N];
        _RSI_12 = [NSNumber numberWithFloat:RSI];
    }
    return _RSI_12;
}

- (NSNumber *)RSI_24 {
    
    if (! _RSI_24) {
        
        CGFloat RSI = [self getRSIWithN:kStock_RSI_24_N];
        _RSI_24 = [NSNumber numberWithFloat:RSI];
    }
    return _RSI_24;
}

#pragma mark ARBR
- (NSNumber *)ARBR_AR {
    
    if (! _ARBR_AR) {
        
        _ARBR_AR = @([self getARWithN:kStock_ARBR_N]);
        
        if (self.index.integerValue < kStock_ARBR_N) {
            
            if (self.allModelArray.count > kStock_ARBR_N) {
                
                _ARBR_AR = [self.allModelArray[kStock_ARBR_N] ARBR_AR];
            } else {
                
                _ARBR_AR = @0;
            }
        }
    }
    return _ARBR_AR;
}

- (NSNumber *)ARBR_BR {
    
    if (! _ARBR_BR) {
        
        _ARBR_BR = @([self getBRWithN:kStock_ARBR_N]);
        
        if (self.index.integerValue < kStock_ARBR_N) {
            
            if (self.allModelArray.count > kStock_ARBR_N) {
                
                _ARBR_BR = [self.allModelArray[kStock_ARBR_N] ARBR_BR];
            } else {
                
                _ARBR_BR = @0;
            }
        }
    }
    return _ARBR_BR;
}

#pragma mark OBV
- (NSNumber *)OBV {
    
    if (! _OBV) {
        
        _OBV = @([self getOBVWithN:12]);
    }
    return _OBV;
}

#pragma mark WR
- (NSNumber *)WR_1 {
    
    if (! _WR_1) {
        
        CGFloat value = 100 * ([self getMaxHighPriceWithN:kStock_WR_1_N] - self.closePrice.floatValue) / ([self getMaxHighPriceWithN:kStock_WR_1_N] - [self getMinLowPriceWithN:kStock_WR_1_N]);
        _WR_1 = [NSNumber numberWithFloat:value];
    }
    return _WR_1;
}

- (NSNumber *)WR_2 {
    
    if (! _WR_2) {
        
        CGFloat value = 100 * ([self getMaxHighPriceWithN:kStock_WR_2_N] - self.closePrice.floatValue) / ([self getMaxHighPriceWithN:kStock_WR_2_N] - [self getMinLowPriceWithN:kStock_WR_2_N]);
        _WR_2 = [NSNumber numberWithFloat:value];
    }
    return _WR_2;
}

#pragma mark EMV
- (NSNumber *)EMV {
    
    if (! _EMV) {
        
        _EMV = @([self getEMVWithN:kStock_EMV_N]);
    }
    return _EMV;
}

- (NSNumber *)EMV_MA {
    
    if (! _EMV_MA) {
        
        _EMV_MA = @([self getEMV_MAWithN:kStock_EMV_MA_N]);
    }
    return _EMV_MA;
}

#pragma mark DMA
- (NSNumber *)DDD {
    
    if (! _DDD) {
        
        CGFloat DDD = [self getMAWithN:kStock_DMA_SHORT] - [self getMAWithN:kStock_DMA_LONG];
        _DDD = @(DDD);
    }
    return _DDD;
}

- (NSNumber *)AMA {
    
    if (! _AMA) {
        
        CGFloat DDD_MA = [self getDDD_MAWithN:kStock_DMA_SHORT];
        _AMA = @(DDD_MA);
    }
    return _AMA;
}

#pragma mark CCI
- (NSNumber *)CCI {
    
    if (! _CCI) {
        
        CGFloat TYP = [self getTYP];
        CGFloat MA_TYP_N = [self getTYP_MAWithN:kStock_CCI_N];
        CGFloat AVEDEV = [self getAVEDEVWithN:kStock_CCI_N];
        CGFloat CCI = (TYP - MA_TYP_N)/ AVEDEV / 0.015;
        
        if (self.index.integerValue < kStock_CCI_N) {
            
//            CCI = [[self.allModelArray[kStock_CCI_N] CCI] floatValue];
            CCI = 0;
        }
        
        _CCI = [NSNumber numberWithFloat:CCI];
    }
    return _CCI;
}

#pragma mark BIAS
- (NSNumber *)BIAS_1 {
    
    if (! _BIAS_1) {
        
        CGFloat BIAS = (self.closePrice.floatValue - [self getMAWithN:kStock_BIAS_1_N]) / [self getMAWithN:kStock_BIAS_1_N] * 100.0f;
        _BIAS_1 = [NSNumber numberWithFloat:BIAS];
    }
    return _BIAS_1;
}

- (NSNumber *)BIAS_2 {
    
    if (! _BIAS_2) {
        
        CGFloat BIAS = (self.closePrice.floatValue - [self getMAWithN:kStock_BIAS_2_N]) / [self getMAWithN:kStock_BIAS_2_N] * 100.0f;
        _BIAS_2 = [NSNumber numberWithFloat:BIAS];
    }
    return _BIAS_2;
}

- (NSNumber *)BIAS_3 {
    
    if (! _BIAS_3) {
        
        CGFloat BIAS = (self.closePrice.floatValue - [self getMAWithN:kStock_BIAS_3_N]) / [self getMAWithN:kStock_BIAS_3_N] * 100.0f;
        _BIAS_3 = [NSNumber numberWithFloat:BIAS];
    }
    return _BIAS_3;
}

#pragma mark ROC
- (NSNumber *)ROC {
    
    if (! _ROC) {
        
        CGFloat previousNDayClosePrice = [self getPreviousClosePriceWithN:kStock_ROC_N];
        CGFloat ROC;
        if (previousNDayClosePrice == 0) {
            
            ROC = 0;
        } else {
            
            ROC = (self.closePrice.floatValue - previousNDayClosePrice) / previousNDayClosePrice * 100;
        }
        _ROC = [NSNumber numberWithFloat:ROC];
    }
    return _ROC;
}

- (NSNumber *)ROC_MA {
    
    if (! _ROC_MA) {
        
        CGFloat ROC_MA = [self getROC_MAWithN:kStock_ROC_MA_N];
        _ROC_MA = [NSNumber numberWithFloat:ROC_MA];
    }
    
    return _ROC_MA;
}

#pragma mark MTM
- (NSNumber *)MTM {
    
    if (! _MTM) {
        
        CGFloat MTM = self.closePrice.floatValue - [self getPreviousClosePriceWithN:kStock_MTM_N];
        if ([self getPreviousClosePriceWithN:kStock_MTM_N] == 0) {
            
            MTM = 0;
        }
        _MTM = [NSNumber numberWithFloat:MTM];
    }
    
    return _MTM;
}

- (NSNumber *)MTM_MA {
    
    if (! _MTM_MA) {
        
        _MTM_MA = [NSNumber numberWithFloat:[self getMTM_MAWithN:kStock_MTM_MA_N]];
    }
    return _MTM_MA;
}

#pragma mark CR
- (NSNumber *)CR {
    
    if (! _CR) {
        
        CGFloat CR = [self getP_1WithN:kStock_CR_N] / [self getP_2WithN:kStock_CR_N] * 100;
        
        if (self.index.integerValue < kStock_CR_N) {
            
//            CR = [[self.allModelArray[kStock_CR_N] CR] floatValue];
            CR = 0;
        }
        
        _CR = [NSNumber numberWithFloat:CR];
    }
    return _CR;
}

- (NSNumber *)CR_MA_1 {
    
    if (! _CR_MA_1) {
        
        _CR_MA_1 = [NSNumber numberWithFloat:[self getCR_MAWithN:kStock_CR_MA_1_N]];
    }
    return _CR_MA_1;
}

- (NSNumber *)CR_MA_2 {
    
    if (! _CR_MA_2) {
        
        _CR_MA_2 = [NSNumber numberWithFloat:[self getCR_MAWithN:kStock_CR_MA_2_N]];
    }
    return _CR_MA_2;
}

#pragma mark DMI
- (NSNumber *)DMI_PDI {
    
    if (! _DMI_PDI) {
        
        _DMI_PDI = @([self getPDIWithN:kStock_DMI_PDIMDI_N]);
    }
    return _DMI_PDI;
}

- (NSNumber *)DMI_MDI {
    
    if (! _DMI_MDI) {
        
        _DMI_MDI = @([self getMDIWithN:kStock_DMI_PDIMDI_N]);
    }
    return _DMI_MDI;
}

- (NSNumber *)DMI_ADX {
    
    if (! _DMI_ADX) {
        
        _DMI_ADX = @([self getADXWithN:kStock_DMI_ADX_ADXR_N]);
    }
    return _DMI_ADX;
}

- (NSNumber *)DMI_ADXR {
    
    if (! _DMI_ADXR) {
        
        _DMI_ADXR = @([self getADXRWithN:kStock_DMI_ADX_ADXR_N]);
    }
    return _DMI_ADXR;
}

#pragma mark VR
- (NSNumber *)VR {
    
    if (! _VR) {
        
        _VR = @([self getVRWithN:kStock_VR_N]);
    }
    return _VR;
}

- (NSNumber *)VR_MA {
    
    if (! _VR_MA) {
        
        _VR_MA = @([self getVR_MAWithN:kStock_VR_MA_N]);
    }
    return _VR_MA;
}

#pragma mark TRIX
- (NSNumber *)TRIX {
    
    if (! _TRIX) {
        
        CGFloat todayTR = [self getTRWithN:kStock_TRIX_N];
        CGFloat yesterdayTR = [self.preModel getTRWithN:kStock_TRIX_N];
        
        _TRIX = [NSNumber numberWithFloat:(todayTR - yesterdayTR) / yesterdayTR * 100];
        
        if (isinf(_TRIX.floatValue)) {
            
            _TRIX = @0;
        }
        
        if (self.index.integerValue < kStock_TRIX_N) {
            
//            _TRIX = [self.allModelArray[kStock_TRIX_N] TRIX];
            _TRIX = @0;
        }
    }
    return _TRIX;
}

- (NSNumber *)TRIX_MA {
    
    if (! _TRIX_MA) {
        
        CGFloat TRIX_MA = [self getTRIX_MAWithN:kStock_TRIX_MA_N];
        _TRIX_MA = [NSNumber numberWithFloat:TRIX_MA];
    }
    return _TRIX_MA;
}

#pragma mark PSY
- (NSNumber *)PSY {
    
    if (! _PSY) {
        
        NSInteger increaseDays = [self getNumberOfIncreaseDaysWithN:kStock_PSY_N];
        _PSY = [NSNumber numberWithFloat:(increaseDays * 1.0 / (kStock_PSY_N * 1.0) * 100.0)];
    }
    return _PSY;
}

- (NSNumber *)PSY_MA {
    
    if (! _PSY_MA) {
        
        _PSY_MA = [NSNumber numberWithFloat:[self getPSY_MAWithN:kStock_PSY_MA_N]];
    }
    return _PSY_MA;
}

#pragma mark DPO
- (NSNumber *)DPO {
    
    if (! _DPO) {
        
        CGFloat DPO = self.closePrice.floatValue - [self getPreviousMAForDPOWithN:kStock_DPO_N];
        _DPO = @(DPO);
        
        if (self.index.integerValue < kStock_DPO_N) {
            
//            _DPO = [self.allModelArray[kStock_DPO_N] DPO];
            _DPO = @0;
        }
    }
    return _DPO;
}

- (NSNumber *)DPO_MA {
    
    if (! _DPO_MA) {
        
        _DPO_MA = @([self getDPO_MAWithN:kStock_DPO_MA_N]);
    }
    return _DPO_MA;
}

#pragma mark ASI
- (NSNumber *)ASI {
    
    if (! _ASI) {
        
        _ASI = @([self getSIWithN:kStock_ASI_N] + self.preModel.ASI.floatValue);
        
        if (self.index.integerValue < kStock_ASI_N) {
            
//            _ASI = [self.allModelArray[kStock_ASI_N] ASI];
            _ASI = @0;
        }
    }
    return _ASI;
}

- (NSNumber *)ASI_MA {
    
    if (! _ASI_MA) {
        
        _ASI_MA = @([self getASI_MAWithN:kStock_ASI_MA_N]);
    }
    return _ASI_MA;
}



#pragma mark - 计算相关
#pragma mark MA/EMA
// MA
- (CGFloat)getMAWithN:(NSInteger)N {
    
    CGFloat MA = 0;
    
    NSMutableArray *tempArray = [self getPreviousArrayContainsSelfWithN:N];
    
    MA = [[[tempArray valueForKeyPath:@"closePrice"] valueForKeyPath:@"@avg.floatValue"] floatValue];
    
//    if (self.index.integerValue < N - 1) {
//
//        MA = 0;
//    }
    
    return MA;
}

// EMA
- (CGFloat)getEMAWithN:(NSInteger)N {
    
    CGFloat EMA = 0;
    
    NSMutableArray *tempArray = [self getPreviousArrayContainsSelfWithN:kStock_EMA_PreviousDayScale * N];
    
    CGFloat lastEMA = 0;

    for (int i = 0; i < tempArray.count; i ++) {
        
        YFStock_KLineModel *currentModel = tempArray[i];
        if (i == 0) { // 这里有个人为规定，规定把首日收盘价当成是首日EMA
            
            EMA = currentModel.closePrice.floatValue;
        } else {
            
            EMA = (currentModel.closePrice.floatValue * 2 + lastEMA * (N - 1)) / (N + 1);
        }
        
        lastEMA = EMA;
    }
    
    return EMA;
}

#pragma mark KDJ
// RSV
- (CGFloat)getRSVWithN:(NSInteger)N {
    
    CGFloat RSV = 0;
    
    if([self getMaxHighPriceWithN:N] == [self getMinLowPriceWithN:N]) {
        
        RSV = 100;
    } else {
        
        RSV = (self.closePrice.floatValue - [self getMinLowPriceWithN:N]) * 100 / ([self getMaxHighPriceWithN:N] - [self getMinLowPriceWithN:N]);
    }
    
    return RSV;
}

// 获取N周期内收盘价最小值和最大值
- (CGFloat)getMaxHighPriceWithN:(NSInteger)N {
    
    CGFloat value = 0;
    
    if (self.preAllModelArray.count >= (N - 1)) {
        
        NSArray *tempKLineModelArray = [self.preAllModelArray subarrayWithRange:NSMakeRange(self.preAllModelArray.count - (N - 1), (N - 1))];
        CGFloat maxPrice =  [[[tempKLineModelArray valueForKeyPath:@"highPrice"] valueForKeyPath:@"@max.floatValue"] floatValue];
        
        value = maxPrice > self.highPrice.floatValue ? maxPrice : self.highPrice.floatValue;
        
    } else {
        
        value = 0;
    }
    
    return value;
}

- (CGFloat)getMinLowPriceWithN:(NSInteger)N {
    
    CGFloat value = MAXFLOAT;
    
    if (self.preAllModelArray.count >= (N - 1)) {
        
        NSArray *tempKLineModelArray = [self.preAllModelArray subarrayWithRange:NSMakeRange(self.preAllModelArray.count - (N - 1), (N - 1))];
        CGFloat minPrice =  [[[tempKLineModelArray valueForKeyPath:@"lowPrice"] valueForKeyPath:@"@min.floatValue"] floatValue];
        
        value = minPrice < self.lowPrice.floatValue ? minPrice : self.lowPrice.floatValue;
        
    } else {
        
        value = MAXFLOAT;
    }
    
    return value;
}

#pragma mark RSI
// RSI
- (CGFloat)getRSIWithN:(NSInteger)N {
    
    CGFloat RSI = 0;
    
    CGFloat increaseValue = [self getIncreaseAvgWithN:N];
    CGFloat decreaseValue = [self getDecreaseAvgWithN:N];
    
    if (decreaseValue == 0) {
        
        decreaseValue = MAXFLOAT;
    }
    
    CGFloat RS = increaseValue / decreaseValue;
    
    RSI = 100 * RS / (1 + RS);
    
    if (self.index.integerValue < N) {
        
        RSI = 100;
    }
    
    return RSI;
}

- (CGFloat)getIncreaseAvgWithN:(NSInteger)N {
    
    CGFloat increaseAvg = 0;
    
    CGFloat minusValue = self.closePrice.floatValue - self.preModel.closePrice.floatValue;
    CGFloat increaseValue = minusValue < 0 ? 0 : minusValue; // 当日下跌，记涨幅数为0
    
    increaseAvg = ((N - 1) * [self.preModel getIncreaseAvgWithN:N] + increaseValue) / N;
    
    return increaseAvg;
}

- (CGFloat)getDecreaseAvgWithN:(NSInteger)N {
    
    CGFloat decreaseAvg = 0;
    
    CGFloat minusValue = self.closePrice.floatValue - self.preModel.closePrice.floatValue;
    CGFloat decreaseValue = minusValue > 0 ? 0 : ABS(minusValue); // 当日上涨，记跌幅数为0
    
    decreaseAvg = ((N - 1) * [self.preModel getDecreaseAvgWithN:N] + decreaseValue) / N;
    
    return decreaseAvg;
}

#pragma mark BOLL
- (CGFloat)getMDWithN:(NSInteger)N {
    
    CGFloat MD = 0;
    
    NSMutableArray *tempArray = [self getPreviousArrayContainsSelfWithN:N];
    
    CGFloat sum = 0;
    for (YFStock_KLineModel *model in tempArray) {
        
        CGFloat a = model.closePrice.floatValue - [self getMAWithN:N];
        a *= a;
        
        sum += a;
    }
    
    sum /= (N * 1.0);
    
    MD = sqrt(sum);
    
    return MD;
}

#pragma mark ARBR
- (CGFloat)getARWithN:(NSInteger)N {
    
    CGFloat AR = 0;
    
    NSMutableArray *tempArray = [self getPreviousArrayContainsSelfWithN:N];
    
    CGFloat sum_HMinusO = 0;
    CGFloat sum_OMinusL = 0;
    for (YFStock_KLineModel *model in tempArray) {
        
        CGFloat HMinusO = model.highPrice.floatValue - model.openPrice.floatValue;
        CGFloat OMinusL = model.openPrice.floatValue - model.lowPrice.floatValue;
        
        sum_HMinusO += HMinusO;
        sum_OMinusL += OMinusL;
    }
    
    AR = (sum_HMinusO / sum_OMinusL) * 100;
    
    return AR;
}

- (CGFloat)getBRWithN:(NSInteger)N {
    
    CGFloat BR = 0;
    
    NSMutableArray *tempArray = [self getPreviousArrayContainsSelfWithN:N];
    
    CGFloat sum_HMinusPC = 0;
    CGFloat sum_PCMinusL = 0;
    for (YFStock_KLineModel *model in tempArray) {
        
        CGFloat HMinusPC = model.highPrice.floatValue - model.preModel.closePrice.floatValue;
        CGFloat PCMinusL = model.preModel.closePrice.floatValue - model.lowPrice.floatValue;
        
        sum_HMinusPC += HMinusPC;
        sum_PCMinusL += PCMinusL;
    }
    
    BR = (sum_HMinusPC / sum_PCMinusL) * 100;
    
    return BR;
}

- (CGFloat)getOBVWithN:(NSInteger)N {
    
    CGFloat OBV = 0;
    
    NSArray *tempArray = [self getPreviousArrayContainsSelfWithN:N];
    NSInteger lastOBV = 0;
    for (int i = 0; i < tempArray.count; i ++) {
        
        YFStock_KLineModel *model = tempArray[i];
        if (i == 0) {
            
            OBV = model.volume.integerValue;
        } else {
            
            if (model.closePrice.floatValue >= model.preModel.closePrice.floatValue) {
                
                OBV = lastOBV + model.volume.integerValue;
            } else {
                
                OBV = lastOBV - model.volume.integerValue;
            }
        }
        
        lastOBV = OBV;
    }
    
    return OBV;
}

#pragma mark CCI
- (CGFloat)getTYP {
    
    CGFloat TYP = 0;
    
    TYP = (self.highPrice.floatValue + self.lowPrice.floatValue + self.closePrice.floatValue) / 3.0;
    
    return TYP;
}

- (CGFloat)getTYP_MAWithN:(NSInteger)N {
    
    CGFloat MA = 0;
    
    NSMutableArray *tempArray = [self getPreviousArrayContainsSelfWithN:N];
    
    CGFloat sumTYP = 0;
    for (YFStock_KLineModel *model in tempArray) {
        
        sumTYP += [model getTYP];
    }
    
    //    if (self.index.integerValue <= N - 1 - 1) {
    //
    //        MA = 0;
    //    }
    
    MA = sumTYP / (N * 1.0);
    
    return MA;
}

- (CGFloat)getAVEDEVWithN:(NSInteger)N {
    
    CGFloat AVEDEV = 0;
    
    NSMutableArray *tempArray = [self getPreviousArrayContainsSelfWithN:N];
    
    CGFloat sum = 0;
    for (YFStock_KLineModel *model in tempArray) {
        
        sum += ABS([model getTYP] - [model getTYP_MAWithN:N]);
    }
    
    AVEDEV = sum / (N * 1.0);
    
    return AVEDEV;
}

#pragma mark EMV
- (CGFloat)getEMVWithN:(NSInteger)N {
    
    CGFloat EMV = 0;
    
    NSArray *tempArray = [self getPreviousArrayContainsSelfWithN:N];
    for (YFStock_KLineModel * model in tempArray) {
        
        CGFloat A = (model.highPrice.floatValue + model.lowPrice.floatValue) * 0.5;
        CGFloat B = (model.preModel.highPrice.floatValue + model.preModel.lowPrice.floatValue) * 0.5;
        CGFloat C = (model.highPrice.floatValue - model.lowPrice.floatValue);
        CGFloat EM = (A - B) * C / (model.volume.integerValue * 1.0);
        EMV += EM;
    }
    
    return EMV;
}

- (CGFloat)getEMV_MAWithN:(NSInteger)N {
    
    CGFloat MA = 0;
    
    NSMutableArray *tempArray = [self getPreviousArrayContainsSelfWithN:N];
    
    CGFloat sumEMV = 0;
    for (YFStock_KLineModel *model in tempArray) {
        
        sumEMV += model.EMV.floatValue;
    }
    
    MA = sumEMV / (tempArray.count * 1.0);
    
    return MA;
}

#pragma mark DMA
- (CGFloat)getDDD_MAWithN:(NSInteger)N {
    
    CGFloat MA = 0;
    
    NSMutableArray *tempArray = [self getPreviousArrayContainsSelfWithN:N];
    
    CGFloat sumDDD = 0;
    for (YFStock_KLineModel *model in tempArray) {
        
        sumDDD += model.DDD.floatValue;
    }
    
    MA = sumDDD / (N * 1.0);
    
    return MA;
}

#pragma mark ROC
// 获取N天前的收盘价
- (CGFloat)getPreviousClosePriceWithN:(NSInteger)N {
    
    CGFloat closePrice = 0;
    
    NSInteger index = self.preAllModelArray.count - 1 - (N - 1);
    if (index < 0) {
        
        index = 0;
    }
    
    if (self.preAllModelArray.count) {
        
        YFStock_KLineModel *model = self.preAllModelArray[index];
        
        closePrice = model.closePrice.floatValue;
    }
    
    return closePrice;
}

- (CGFloat)getROC_MAWithN:(NSInteger)N {
    
    CGFloat ROC_MA = 0;
    
    CGFloat sum = 0;
    NSMutableArray *tempArray = [self getPreviousArrayContainsSelfWithN:N];
    
    for (YFStock_KLineModel *model in tempArray) {
        
        sum += model.ROC.floatValue;
    }
    
    ROC_MA = sum / (N * 1.0);
    
    return ROC_MA;
}

#pragma mark MTM
- (CGFloat)getMTM_MAWithN:(NSInteger)N {
    
    CGFloat MTM_MA = 0;
    
    CGFloat sum = 0;
    NSMutableArray *tempArray = [self getPreviousArrayContainsSelfWithN:N];
    
    for (YFStock_KLineModel *model in tempArray) {
        
        sum += model.MTM.floatValue;
    }
    
    MTM_MA = sum / (N * 1.0);
    
    return MTM_MA;
}

#pragma mark CR
- (CGFloat)getMiddlePrice {
    
    CGFloat middlePrice = 0;
    
    /*
     四种计算方法
     1、M=（2C+H+L）÷4
     2、M=（C+H+L+O）÷4
     3、M=（C+H+L）÷3
     4、M=（H+L）÷2
     */
    
    middlePrice = (2 * self.closePrice.floatValue + self.highPrice.floatValue + self.lowPrice.floatValue) / 4.0;
//    middlePrice = (self.closePrice.floatValue + self.highPrice.floatValue + self.lowPrice.floatValue + self.openPrice.floatValue) / 4.0;
//    middlePrice = (self.closePrice.floatValue + self.highPrice.floatValue + self.lowPrice.floatValue) / 3.0;
//    middlePrice = (self.highPrice.floatValue + self.lowPrice.floatValue) / 2.0;
    
    return middlePrice;
}

- (CGFloat)getP_1WithN:(NSInteger)N {
    
    CGFloat P = 0;
    
    NSMutableArray *tempArray = [self getPreviousArrayContainsSelfWithN:N];
    
    for (YFStock_KLineModel *model in tempArray) {
        
        P += (model.highPrice.floatValue - [model.preModel getMiddlePrice]);
    }
    
    return P;
}

- (CGFloat)getP_2WithN:(NSInteger)N {
    
    CGFloat P = 0;
    
    NSMutableArray *tempArray = [self getPreviousArrayContainsSelfWithN:N];
    
    for (YFStock_KLineModel *model in tempArray) {
        
        P += ([model.preModel getMiddlePrice] - model.lowPrice.floatValue);
    }
    
    return P;
}

- (CGFloat)getCR_MAWithN:(NSInteger)N {
    
    CGFloat CR_MA = 0;
    
    CGFloat sum = 0;
    NSMutableArray *tempArray = [self getPreviousArrayContainsSelfWithN:N];
    
    for (YFStock_KLineModel *model in tempArray) {
        
        sum += model.CR.floatValue;
    }
    
    CR_MA = sum / (N * 1.0);
    
    return CR_MA;
}

#pragma mark DMI
- (CGFloat)getTR {
    
    CGFloat TR = 0;
    
    CGFloat A = ABS(self.highPrice.floatValue - self.lowPrice.floatValue);
    CGFloat B = ABS(self.highPrice.floatValue - self.preModel.closePrice.floatValue);
    CGFloat C = ABS(self.lowPrice.floatValue - self.preModel.closePrice.floatValue);
    
    TR = MAX(A, MAX(B, C));
    
    return TR;
}

- (CGFloat)getMTRWithN:(NSInteger)N {
    
    CGFloat MTR = 0;
    
    NSMutableArray *tempArray = [self getPreviousArrayContainsSelfWithN:kStock_EMA_PreviousDayScale * N];
    
    CGFloat lastMTR = 0;
    
    for (int i = 0; i < tempArray.count; i ++) {
        
        YFStock_KLineModel *currentModel = tempArray[i];
        if (i == 0) {
            
            MTR = [currentModel getTR];
        } else {
            
            MTR = ([currentModel getTR] * 2 + lastMTR * (N - 1)) / (N + 1);
        }
        
        lastMTR = MTR;
    }
    
    return MTR;
}

- (CGFloat)getHD {
    
    CGFloat HD = 0;
    
    HD = self.highPrice.floatValue - self.preModel.highPrice.floatValue;
    
    return HD;
}

- (CGFloat)getLD {
    
    CGFloat LD = 0;
    
    LD = self.preModel.lowPrice.floatValue - self.lowPrice.floatValue;
    
    return LD;
}

- (CGFloat)getDMPWithN:(NSInteger)N {
    
    CGFloat DMP = 0;
    
    NSMutableArray *tempArray = [self getPreviousArrayContainsSelfWithN:kStock_EMA_PreviousDayScale * N];
    
    CGFloat lastDMP = 0;
    
    for (int i = 0; i < tempArray.count; i ++) {
        
        YFStock_KLineModel *currentModel = tempArray[i];
        
        CGFloat HD = [currentModel getHD];
        CGFloat LD = [currentModel getLD];
        if (HD > 0 && HD > LD) {
            
            HD = HD;
        } else {
            
            HD = 0;
        }
        
        if (i == 0) {
            
            DMP = HD;
        } else {
            
            DMP = (HD * 2 + lastDMP * (N - 1)) / (N + 1);
        }
        
        lastDMP = DMP;
    }
    
    return DMP;
}

- (CGFloat)getDMMWithN:(NSInteger)N {
    
    CGFloat DMM = 0;
    
    NSMutableArray *tempArray = [self getPreviousArrayContainsSelfWithN:kStock_EMA_PreviousDayScale * N];
    
    CGFloat lastDMM = 0;
    
    for (int i = 0; i < tempArray.count; i ++) {
        
        YFStock_KLineModel *currentModel = tempArray[i];
        
        CGFloat HD = [currentModel getHD];
        CGFloat LD = [currentModel getLD];
        if (LD > 0 && LD > HD) {
            
            LD = LD;
        } else {
            
            LD = 0;
        }
        
        if (i == 0) {
            
            DMM = LD;
        } else {
            
            DMM = (LD * 2 + lastDMM * (N - 1)) / (N + 1);
        }
        
        lastDMM = DMM;
    }
    
    return DMM;
}

- (CGFloat)getPDIWithN:(NSInteger)N {
    
    CGFloat PDI = 0;
    
    PDI = [self getDMPWithN:N] * 100 / [self getMTRWithN:N];
    
    return PDI;
}

- (CGFloat)getMDIWithN:(NSInteger)N {
    
    CGFloat MDI = 0;
    
    MDI = [self getDMMWithN:N] * 100 / [self getMTRWithN:N];
    
    return MDI;
}


- (CGFloat)getADXWithN:(NSInteger)N {
    
    CGFloat ADX = 0;
    
    NSMutableArray *tempArray = [self getPreviousArrayContainsSelfWithN:kStock_EMA_PreviousDayScale * N];
    
    CGFloat lastADX = 0;
    
    for (int i = 0; i < tempArray.count; i ++) {
        
        YFStock_KLineModel *currentModel = tempArray[i];
        
        CGFloat X = ABS(currentModel.DMI_MDI.floatValue - currentModel.DMI_PDI.floatValue) / (currentModel.DMI_MDI.floatValue + currentModel.DMI_PDI.floatValue) * 100;
        
        if (i == 0) {
            
            ADX = X;
        } else {
            
            ADX = (X * 2 + lastADX * (N - 1)) / (N + 1);
        }
        
        lastADX = ADX;
    }
    
    return ADX;
}

- (CGFloat)getADXRWithN:(NSInteger)N {
    
    CGFloat ADXR = 0;
    
    NSMutableArray *tempArray = [self getPreviousArrayContainsSelfWithN:kStock_EMA_PreviousDayScale * N];
    
    CGFloat lastADXR = 0;
    
    for (int i = 0; i < tempArray.count; i ++) {
        
        YFStock_KLineModel *currentModel = tempArray[i];
        
        CGFloat X = currentModel.DMI_ADX.floatValue;
        
        if (i == 0) {
            
            ADXR = X;
        } else {
            
            ADXR = (X * 2 + lastADXR * (N - 1)) / (N + 1);
        }
        
        lastADXR = ADXR;
    }

    return ADXR;
}

#pragma mark VR
- (CGFloat)getVRWithN:(NSInteger)N {
    
    CGFloat VR = 0;
    
    CGFloat AVS = 0, BVS = 0, CVS = 0;
    
    NSArray *tempArray = [self getPreviousArrayContainsSelfWithN:N];
    for (YFStock_KLineModel *model in tempArray) {
        
        if (model.closePrice.floatValue > model.openPrice.floatValue) { // increase
            
            AVS += model.volume.integerValue;
        } else if (model.closePrice.floatValue < model.openPrice.floatValue) { // decrease
            
            BVS += model.volume.integerValue;
        } else { // equal
            
            CVS += model.volume.integerValue;
        }
    }
    
    VR = (AVS + 0.5 * CVS) / (BVS + 0.5 * CVS);
    
    return VR;
}

- (CGFloat)getVR_MAWithN:(NSInteger)N {
    
    CGFloat MA = 0;
    
    NSMutableArray *tempArray = [self getPreviousArrayContainsSelfWithN:N];
    
    CGFloat sumEMV = 0;
    for (YFStock_KLineModel *model in tempArray) {
        
        sumEMV += model.VR.floatValue;
    }
    
    MA = sumEMV / (tempArray.count * 1.0);
    
    return MA;
}

#pragma mark TRIX
- (CGFloat)getTRWithN:(NSInteger)N {
    
    CGFloat AX = 0;
    CGFloat BX = 0;
    CGFloat TR = 0;
    
    CGFloat lastAX = 0;
    CGFloat lastBX = 0;
    CGFloat lastTR = 0;
    NSMutableArray *tempArray = [self getPreviousArrayContainsSelfWithN:kStock_EMA_PreviousDayScale * N];
    
    for (int i = 0; i < tempArray.count; i ++) {
        
        YFStock_KLineModel *currentModel = tempArray[i];
        
        AX = (currentModel.closePrice.floatValue * 2 + lastAX * (N - 1)) / (N + 1);
        BX = (AX * 2 + lastBX * (N - 1)) / (N + 1);
        TR = (BX * 2 + lastTR * (N - 1)) / (N + 1);
        
        lastAX = AX;
        lastBX = BX;
        lastTR = TR;
    }
    
    return TR;
}

- (CGFloat)getTRIX_MAWithN:(NSInteger)N {
    
    CGFloat TRIX_MA = 0;
    
    CGFloat sum = 0;
    NSMutableArray *tempArray = [self getPreviousArrayContainsSelfWithN:N];
    
    for (YFStock_KLineModel *model in tempArray) {
        
        sum += model.TRIX.floatValue;
    }
    
    TRIX_MA = sum / (N * 1.0);
    
    return TRIX_MA;
}

#pragma mark PSY
- (NSInteger)getNumberOfIncreaseDaysWithN:(NSInteger)N {
    
    NSInteger days = 0;
    
    NSInteger sum = 0;
    NSMutableArray *tempArray = [self getPreviousArrayContainsSelfWithN:N];
    for (YFStock_KLineModel *model in tempArray) {
        
        if (model.isIncrease) {
            
            sum += 1;
        }
    }
    
    days = sum;
    
    return days;
}

- (CGFloat)getPSY_MAWithN:(NSInteger)N {
    
    CGFloat PSY_MA = 0;
    
    CGFloat sum = 0;
    NSMutableArray *tempArray = [self getPreviousArrayContainsSelfWithN:N];
    
    for (YFStock_KLineModel *model in tempArray) {
        
        sum += model.PSY.floatValue;
    }
    
    PSY_MA = sum / (N * 1.0);
    
    return PSY_MA;
}

#pragma mark DPO
- (CGFloat)getPreviousMAForDPOWithN:(NSInteger)N {
    
    CGFloat MA = 0;
    
    NSInteger index = self.preAllModelArray.count - 1 - ((N / 2 + 1) - 1);
    if (index < 0) {
        
        index = 0;
    }
    
    if (self.preAllModelArray.count) {
        
        YFStock_KLineModel *model = self.preAllModelArray[index];
        
        MA = [model getMAWithN:N];
    } else {
        
        MA = 99999.0;
    }
    
    return MA;
}

- (CGFloat)getDPO_MAWithN:(NSInteger)N {
    
    CGFloat DPO_MA = 0;
    
    CGFloat sum = 0;
    NSMutableArray *tempArray = [self getPreviousArrayContainsSelfWithN:N];
    
    for (YFStock_KLineModel *model in tempArray) {
        
        sum += model.DPO.floatValue;
    }
    
    DPO_MA = sum / (N * 1.0);
    
    return DPO_MA;
}

#pragma mark ASI
- (CGFloat)getSIWithN:(NSInteger)N {
    
    
    CGFloat R = 0;
    
    CGFloat A = ABS(self.highPrice.floatValue - self.preModel.closePrice.floatValue);
    CGFloat B = ABS(self.lowPrice.floatValue - self.preModel.closePrice.floatValue);
    CGFloat C = ABS(self.highPrice.floatValue - self.preModel.lowPrice.floatValue);
    CGFloat D = ABS(self.preModel.closePrice.floatValue - self.preModel.openPrice.floatValue);
    
    CGFloat maxABC = MAX(A, MAX(B, C));
    
    if (maxABC == A) {
        
        R = A + 0.5 * B + 0.25 *D;
    } else if (maxABC == B) {
        
        R = B + 0.5 * A + 0.25 * D;
    } else {
        
        R = C + 0.25 * D;
    }
    
    CGFloat E = self.closePrice.floatValue - self.preModel.closePrice.floatValue;
    CGFloat F = self.closePrice.floatValue - self.openPrice.floatValue;
    CGFloat G = self.preModel.closePrice.floatValue - self.preModel.openPrice.floatValue;
    
    CGFloat X = E + 0.5 * F + G;
    
    CGFloat K = MAX(A, B);
    
    CGFloat L = 3.0f;
    
    CGFloat SI = 50 * X / R * K / L;
    
    return SI;
}

- (CGFloat)getASI_MAWithN:(NSInteger)N {
    
    CGFloat ASI_MA = 0;
    
    CGFloat sum = 0;
    NSMutableArray *tempArray = [self getPreviousArrayContainsSelfWithN:N];
    
    for (YFStock_KLineModel *model in tempArray) {
        
        sum += model.ASI.floatValue;
    }
    
    ASI_MA = sum / (tempArray.count * 1.0);
    
    return ASI_MA;
}

#pragma mark Other
- (NSMutableArray *)getPreviousArrayContainsSelfWithN:(NSInteger)N {
    
    NSInteger startIndex = self.preAllModelArray.count - (N - 1);
    if (startIndex < 0) {
        
        startIndex = 0;
    }
    if (startIndex > self.preAllModelArray.count - 1) {
        
        startIndex = self.preAllModelArray.count - 1;
    }
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self.preAllModelArray subarrayWithRange:NSMakeRange(startIndex, self.preAllModelArray.count - startIndex)]];
    
    [tempArray addObject:self];
    
    return tempArray;
}

@end
