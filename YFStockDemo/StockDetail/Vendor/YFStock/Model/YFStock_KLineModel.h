//
//  YFStock_Model.h
//  GoldfishSpot
//
//  Created by 李友富 on 2017/4/20.
//  Copyright © 2017年 中泰荣科. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class YFStock_KLineModel;

@interface YFStock_KLineModel : NSObject

#pragma mark - 后台返回
// 后台返回的字段，这些字段必须要在初始化后赋值！！！！！！(请不要修改以下任何字段，请做字段转换)
@property (nonatomic, strong) NSNumber *openPrice;
@property (nonatomic, strong) NSNumber *closePrice;
@property (nonatomic, strong) NSNumber *highPrice;
@property (nonatomic, strong) NSNumber *lowPrice;
@property (nonatomic, strong) NSNumber *volume;
@property (nonatomic, copy) NSString *dataTime;
@property (nonatomic, copy) NSString *quotationCode;

#pragma mark - 计算
// 自己用算法计算的（如果后台返回相同意义字段，使用后台的覆盖就好，就不会走取值的懒加载方法了）
@property (nonatomic, strong) NSArray *preAllModelArray; // 必须要赋值！！！！！！【需要用 copy，否则数组还是会跟着改变】
@property (nonatomic, strong) NSArray *allModelArray; // 必须要赋值！！！！！！
@property (nonatomic, strong) YFStock_KLineModel *preModel;
@property (nonatomic, strong) NSNumber *index;

// MA相关(5, 10, 20)，可配置参数-（移动平均周期），EMA与之类似
@property (nonatomic, strong) NSNumber *MA_5;
@property (nonatomic, strong) NSNumber *MA_10;
@property (nonatomic, strong) NSNumber *MA_20;
@property (nonatomic, strong) NSNumber *MA_30;

// MACD相关(12, 26, 9)，可配置参数-（短周期，长周期，移动平均周期）
@property (nonatomic, strong) NSNumber *MACD_DIF;
@property (nonatomic, strong) NSNumber *MACD_DEA;
@property (nonatomic, strong) NSNumber *MACD_BAR;

// KDJ(9, 3, 3)，可配置参数-（计算周期，移动平均周期，移动平均周期）
@property (nonatomic, strong) NSNumber *KDJ_K;
@property (nonatomic, strong) NSNumber *KDJ_D;
@property (nonatomic, strong) NSNumber *KDJ_J;

// RSI(6, 12, 24)，可配置参数-（移动平均周期，移动平均周期，移动平均周期）
@property (nonatomic, strong) NSNumber *RSI_6;
@property (nonatomic, strong) NSNumber *RSI_12;
@property (nonatomic, strong) NSNumber *RSI_24;

// BOLL(20, 2)，可配置参数-（计算周期，股票特性参数）
@property (nonatomic, strong) NSNumber *BOLL_UPPER;
@property (nonatomic, strong) NSNumber *BOLL_MID;
@property (nonatomic, strong) NSNumber *BOLL_LOWER;

// ARBR(26)，可配置参数-（计算周期）
@property (nonatomic, strong) NSNumber *ARBR_AR;
@property (nonatomic, strong) NSNumber *ARBR_BR;

// OBV(12)，不可配置参数
@property (nonatomic, strong) NSNumber *OBV;

// WR(10, 6)，可配置参数-（计算周期，计算周期）
@property (nonatomic, strong) NSNumber *WR_1;
@property (nonatomic, strong) NSNumber *WR_2;

// EMV(14,9),可配置参数-周期
@property (nonatomic, strong) NSNumber *EMV;
@property (nonatomic, strong) NSNumber *EMV_MA;

// DMA(10, 50)，可配置参数-（短周期，长周期）
@property (nonatomic, strong) NSNumber *DDD;
@property (nonatomic, strong) NSNumber *AMA;

// CCI(14)，可配置参数-（计算周期）
@property (nonatomic, strong) NSNumber *CCI;

// BIAS(6, 12, 24)，可配置参数（周期）
@property (nonatomic, strong) NSNumber *BIAS_1;
@property (nonatomic, strong) NSNumber *BIAS_2;
@property (nonatomic, strong) NSNumber *BIAS_3;

// ROC(12, 6),可配置参数（周期）
@property (nonatomic, strong) NSNumber *ROC;
@property (nonatomic, strong) NSNumber *ROC_MA;

// MTM(12, 6),可配置参数（周期）
@property (nonatomic, strong) NSNumber *MTM;
@property (nonatomic, strong) NSNumber *MTM_MA;

// CR(26, 10, 20),可配置参数（周期）
@property (nonatomic, strong) NSNumber *CR;
@property (nonatomic, strong) NSNumber *CR_MA_1;
@property (nonatomic, strong) NSNumber *CR_MA_2;

// DMI(14, 6),可配置参数（周期）
@property (nonatomic, strong) NSNumber *DMI_PDI;
@property (nonatomic, strong) NSNumber *DMI_MDI;
@property (nonatomic, strong) NSNumber *DMI_ADX;
@property (nonatomic, strong) NSNumber *DMI_ADXR;

// VR(26,6),可配置参数（周期）
@property (nonatomic, strong) NSNumber *VR;
@property (nonatomic, strong) NSNumber *VR_MA;

// TRIX(12, 9)，可配置参数(周期)
@property (nonatomic, strong) NSNumber *TRIX;
@property (nonatomic, strong) NSNumber *TRIX_MA;

// PSY(12, 6),可配置参数（周期）
@property (nonatomic, strong) NSNumber *PSY;
@property (nonatomic, strong) NSNumber *PSY_MA;

// DPO(20, 6),可配置参数(周期)
@property (nonatomic, strong) NSNumber *DPO;
@property (nonatomic, strong) NSNumber *DPO_MA;

// ASI(6),可配置参数（周期）
@property (nonatomic, strong) NSNumber *ASI;
@property (nonatomic, strong) NSNumber *ASI_MA;


// =============================================================
@property (nonatomic, assign) BOOL isIncrease;

@property (nonatomic, assign) BOOL isShowTime;
@property (nonatomic, copy) NSString *showTimeStr;

@property (nonatomic, assign) CGPoint openPricePositionPoint;
@property (nonatomic, assign) CGPoint closePricePositionPoint;
@property (nonatomic, assign) CGPoint highPricePositionPoint;
@property (nonatomic, assign) CGPoint lowPricePositionPoint;

@property (nonatomic, assign) CGPoint MA_5PositionPoint;
@property (nonatomic, assign) CGPoint MA_10PositionPoint;
@property (nonatomic, assign) CGPoint MA_20PositionPoint;
@property (nonatomic, assign) CGPoint MA_30PositionPoint;

@property (nonatomic, assign) CGPoint volumeStartPositionPoint;
@property (nonatomic, assign) CGPoint volumeEndPositionPoint;

@property (nonatomic, assign) CGPoint MACD_DIFPositionPoint;
@property (nonatomic, assign) CGPoint MACD_DEAPositionPoint;
@property (nonatomic, assign) CGPoint MACD_BARStartPositionPoint;
@property (nonatomic, assign) CGPoint MACD_BAREndPositionPoint;

@property (nonatomic, assign) CGPoint KDJ_KPositionPoint;
@property (nonatomic, assign) CGPoint KDJ_DPositionPoint;
@property (nonatomic, assign) CGPoint KDJ_JPositionPoint;

@property (nonatomic, assign) CGPoint RSI_6PositionPoint;
@property (nonatomic, assign) CGPoint RSI_12PositionPoint;
@property (nonatomic, assign) CGPoint RSI_24PositionPoint;

@property (nonatomic, assign) CGPoint BOLL_UpperPositionPoint;
@property (nonatomic, assign) CGPoint BOLL_MidPositionPoint;
@property (nonatomic, assign) CGPoint BOLL_LowerPositionPoint;

@property (nonatomic, assign) CGPoint ARBR_ARPositionPoint;
@property (nonatomic, assign) CGPoint ARBR_BRPositionPoint;

@property (nonatomic, assign) CGPoint OBVPositionPoint;

@property (nonatomic, assign) CGPoint WR_1PositionPoint;
@property (nonatomic, assign) CGPoint WR_2PositionPoint;

@property (nonatomic, assign) CGPoint EMVPositionPoint;
@property (nonatomic, assign) CGPoint EMV_MAPositionPoint;

@property (nonatomic, assign) CGPoint DDDPositionPoint;
@property (nonatomic, assign) CGPoint AMAPositionPoint;

@property (nonatomic, assign) CGPoint CCIPositionPoint;

@property (nonatomic, assign) CGPoint BIAS_1PositionPoint;
@property (nonatomic, assign) CGPoint BIAS_2PositionPoint;
@property (nonatomic, assign) CGPoint BIAS_3PositionPoint;

@property (nonatomic, assign) CGPoint ROCPositionPoint;
@property (nonatomic, assign) CGPoint ROC_MAPositionPoint;

@property (nonatomic, assign) CGPoint MTMPositionPoint;
@property (nonatomic, assign) CGPoint MTM_MAPositionPoint;

@property (nonatomic, assign) CGPoint CRPositionPoint;
@property (nonatomic, assign) CGPoint CR_MA_1PositionPoint;
@property (nonatomic, assign) CGPoint CR_MA_2PositionPoint;

@property (nonatomic, assign) CGPoint DMI_PDIPositionPoint;
@property (nonatomic, assign) CGPoint DMI_MDIPositionPoint;
@property (nonatomic, assign) CGPoint DMI_ADXPositionPoint;
@property (nonatomic, assign) CGPoint DMI_ADXRPositionPoint;

@property (nonatomic, assign) CGPoint VRPositionPoint;
@property (nonatomic, assign) CGPoint VR_MAPositionPoint;

@property (nonatomic, assign) CGPoint TRIXPositionPoint;
@property (nonatomic, assign) CGPoint TRIX_MAPositionPoint;

@property (nonatomic, assign) CGPoint PSYPositionPoint;
@property (nonatomic, assign) CGPoint PSY_MAPositionPoint;

@property (nonatomic, assign) CGPoint DPOPositionPoint;
@property (nonatomic, assign) CGPoint DPO_MAPositionPoint;

@property (nonatomic, assign) CGPoint ASIPositionPoint;
@property (nonatomic, assign) CGPoint ASI_MAPositionPoint;



- (void)initData;

@end
