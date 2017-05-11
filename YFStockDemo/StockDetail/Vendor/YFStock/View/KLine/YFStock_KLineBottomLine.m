//
//  YFStock_VolumeLine.m
//  YFStockDemo
//
//  Created by 李友富 on 2017/3/31.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import "YFStock_KLineBottomLine.h"
#import "YFStock_Header.h"

@interface YFStock_KLineBottomLine()

@property (nonatomic, assign) CGContextRef context;
@property (nonatomic, strong) NSArray <YFStock_KLineModel *> *drawKLineModels;
@property (nonatomic, assign) YFStockBottomBarIndex bottomBarSelectedIndex;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation YFStock_KLineBottomLine

#pragma mark - lazy loading
- (CAShapeLayer *)shapeLayer {
    
    if (_shapeLayer == nil) {
        
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.frame = self.layer.bounds;
        _shapeLayer.backgroundColor = kClearColor.CGColor;
        [self.layer addSublayer:_shapeLayer];
    }
    return _shapeLayer;
}

#pragma mark - draw
- (void)drawWithBottomBarSelectedIndex:(NSInteger)bottomBarSelectedIndex drawKLineModels:(NSArray<YFStock_KLineModel *> *)drawKLineModels {
    
    self.drawKLineModels = drawKLineModels;
    
    if (!self.drawKLineModels || self.drawKLineModels.count == 0) return;
    
    if (_shapeLayer) {
        
        [_shapeLayer removeFromSuperlayer];
        _shapeLayer = nil;
    }
    
    self.bottomBarSelectedIndex = bottomBarSelectedIndex;
        
    switch (self.bottomBarSelectedIndex) {
        case YFStockBottomBarIndex_MACD:
        {
            [self drawMACD];
        }
            break;
        case YFStockBottomBarIndex_KDJ:
        {
            [self drawKDJ];
        }
            break;
        case YFStockBottomBarIndex_RSI:
        {
            [self drawRSI];
        }
            break;
        case YFStockBottomBarIndex_ARBR:
        {
            [self drawARBR];
        }
            break;
        case YFStockBottomBarIndex_OBV:
        {
            [self drawOBV];
        }
            break;
        case YFStockBottomBarIndex_WR:
        {
            [self drawWR];
        }
            break;
        case YFStockBottomBarIndex_EMV:
        {
            [self drawEMV];
        }
            break;
        case YFStockBottomBarIndex_DMA:
        {
            [self drawDMA];
        }
            break;
        case YFStockBottomBarIndex_CCI:
        {
            [self drawCCI];
        }
            break;
        case YFStockBottomBarIndex_BIAS:
        {
            [self drawBIAS];
        }
            break;
        case YFStockBottomBarIndex_ROC:
        {
            [self drawROC];
        }
            break;
        case YFStockBottomBarIndex_MTM:
        {
            [self drawMTM];
        }
            break;
        case YFStockBottomBarIndex_CR:
        {
            [self drawCR];
        }
            break;
        case YFStockBottomBarIndex_DMI:
        {
            [self drawDMI];
        }
            break;
        case YFStockBottomBarIndex_VR:
        {
            [self drawVR];
        }
            break;
            
        case YFStockBottomBarIndex_TRXI:
        {
            [self drawTRIX];
        }
            break;
        case YFStockBottomBarIndex_PSY:
        {
            [self drawPSY];
        }
            break;
        case YFStockBottomBarIndex_DPO:
        {
            [self drawDPO];
        }
            break;
        case YFStockBottomBarIndex_ASI:
        {
            [self drawASI];
        }
            break;
            
        default:
            break;
    }
}

- (void)drawVolume {
    
    [self.drawKLineModels enumerateObjectsUsingBlock:^(YFStock_KLineModel *KLineModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIColor *strokeColor;
        CGFloat x, y, width, height;
        
        if (KLineModel.isIncrease) {
            
            strokeColor = kStockIncreaseColor;
            
        } else {
            
            strokeColor = kStockDecreaseColor;
        }
        
        x = KLineModel.volumeStartPositionPoint.x - [YFStock_Variable KLineWidth] * 0.5;
        y = KLineModel.volumeStartPositionPoint.y;
        width = [YFStock_Variable KLineWidth];
        height = ABS(KLineModel.volumeEndPositionPoint.y - KLineModel.volumeStartPositionPoint.y);
        
        CGRect rect = CGRectMake(x, y, width, height);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
        path.lineWidth = kStockPartLineHeight;
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = strokeColor.CGColor;
        shapeLayer.strokeColor = strokeColor.CGColor;
        shapeLayer.path = path.CGPath;
        shapeLayer.frame = self.shapeLayer.bounds;
        shapeLayer.backgroundColor = kClearColor.CGColor;
        [self.shapeLayer addSublayer:shapeLayer];

    }];
}

- (void)drawMACD {
    
    // MACD
    [self.drawKLineModels enumerateObjectsUsingBlock:^(YFStock_KLineModel *KLineModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIColor *strokeColor;
        CGFloat x, y, width, height;

        if (KLineModel.MACD_BAR.floatValue > 0) {
            
            strokeColor = kStockIncreaseColor;
        } else {
            
            strokeColor = kStockDecreaseColor;
        }
        
        x = KLineModel.MACD_BARStartPositionPoint.x - 0.5 * [YFStock_Variable KLineWidth];
        y = KLineModel.MACD_BARStartPositionPoint.y;
        width = [YFStock_Variable KLineWidth];
        height = KLineModel.MACD_BAREndPositionPoint.y - KLineModel.MACD_BARStartPositionPoint.y;
        
        CGRect rect = CGRectMake(x, y, width, height);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
        path.lineWidth = kStockPartLineHeight;
        
        [self createShapeLayerWithStrokeColor:strokeColor fillColor:strokeColor path:path frame:self.shapeLayer.bounds backgroundColor:kClearColor];

    }];
    
    // DIFF
    [self drawWithPositionPointKey:@"MACD_DIFPositionPoint" N:0 strokeColor:kStockDIFFLineColor];
    
    // DEA
    [self drawWithPositionPointKey:@"MACD_DEAPositionPoint" N:0 strokeColor:kStockDEALineColor];
}

- (void)drawKDJ {
    
    // K
    [self drawWithPositionPointKey:@"KDJ_KPositionPoint" N:0 strokeColor:kStockMA5LineColor];
    
    // D
    [self drawWithPositionPointKey:@"KDJ_DPositionPoint" N:0 strokeColor:kStockMA10LineColor];
    
    // J
    [self drawWithPositionPointKey:@"KDJ_JPositionPoint" N:0 strokeColor:kStockMA20LineColor];
}

- (void)drawRSI {
    
    // RSI_6
    [self drawWithPositionPointKey:@"RSI_6PositionPoint" N:kStock_RSI_6_N strokeColor:kStockMA5LineColor];
    
    // RSI_12
    [self drawWithPositionPointKey:@"RSI_12PositionPoint" N:kStock_RSI_12_N strokeColor:kStockMA10LineColor];
    
    // RSI_24
    [self drawWithPositionPointKey:@"RSI_24PositionPoint" N:kStock_RSI_24_N strokeColor:kStockMA20LineColor];
}

- (void)drawARBR {
    
    // AR
    [self drawWithPositionPointKey:@"ARBR_ARPositionPoint" N:kStock_ARBR_N strokeColor:kStockMA5LineColor];

    // BR
    [self drawWithPositionPointKey:@"ARBR_BRPositionPoint" N:kStock_ARBR_N strokeColor:kStockMA10LineColor];
}

- (void)drawOBV {
    
    [self drawVolume];
    
    // OBV
    [self drawWithPositionPointKey:@"OBVPositionPoint" N:0 strokeColor:kStockMA5LineColor];
}

- (void)drawWR {
    
    // WR_1
    [self drawWithPositionPointKey:@"WR_1PositionPoint" N:kStock_WR_1_N strokeColor:kStockMA5LineColor];
    
    // WR_2
    [self drawWithPositionPointKey:@"WR_2PositionPoint" N:kStock_WR_2_N strokeColor:kStockMA10LineColor];
}

- (void)drawEMV {
    
    // EMV
    [self drawWithPositionPointKey:@"EMVPositionPoint" N:kStock_EMV_N strokeColor:kStockMA5LineColor];
    
    // EMV_MA
    [self drawWithPositionPointKey:@"EMV_MAPositionPoint" N:kStock_EMV_MA_N strokeColor:kStockMA10LineColor];
}

- (void)drawDMA {
    
    // DDD
    [self drawWithPositionPointKey:@"DDDPositionPoint" N:kStock_DMA_LONG strokeColor:kStockMA5LineColor];

    // AMA
    [self drawWithPositionPointKey:@"AMAPositionPoint" N:kStock_DMA_LONG strokeColor:kStockMA10LineColor];
}

- (void)drawCCI {
    
    // CCI
    [self drawWithPositionPointKey:@"CCIPositionPoint" N:kStock_CCI_N strokeColor:kStockMA5LineColor];
}

- (void)drawBIAS {
    
    // BIAS_1
    [self drawWithPositionPointKey:@"BIAS_1PositionPoint" N:kStock_BIAS_1_N strokeColor:kStockMA5LineColor];
    
    // BIAS_2
    [self drawWithPositionPointKey:@"BIAS_2PositionPoint" N:kStock_BIAS_2_N strokeColor:kStockMA10LineColor];
    
    // BIAS_3
    [self drawWithPositionPointKey:@"BIAS_3PositionPoint" N:kStock_BIAS_3_N strokeColor:kStockMA20LineColor];
}

- (void)drawROC {
    
    // ROC
    [self drawWithPositionPointKey:@"ROCPositionPoint" N:kStock_ROC_N strokeColor:kStockMA5LineColor];
    
    // ROC_MA
    [self drawWithPositionPointKey:@"ROC_MAPositionPoint" N:kStock_ROC_MA_N strokeColor:kStockMA10LineColor];
}

- (void)drawMTM {
    
    // MTM
    [self drawWithPositionPointKey:@"MTMPositionPoint" N:kStock_MTM_N strokeColor:kStockMA5LineColor];
    
    // MTM_MA
    [self drawWithPositionPointKey:@"MTM_MAPositionPoint" N:kStock_MTM_MA_N strokeColor:kStockMA10LineColor];
}

- (void)drawCR {
    
    // cr
    [self drawWithPositionPointKey:@"CRPositionPoint" N:kStock_CR_N strokeColor:kStockMA5LineColor];
    
    // ma1
    [self drawWithPositionPointKey:@"CR_MA_1PositionPoint" N:kStock_CR_MA_1_N strokeColor:kStockMA10LineColor];

    // ma2
    [self drawWithPositionPointKey:@"CR_MA_2PositionPoint" N:kStock_CR_MA_2_N strokeColor:kStockMA20LineColor];

}

- (void)drawDMI {
    
    [self drawWithPositionPointKey:@"DMI_PDIPositionPoint" N:kStock_DMI_PDIMDI_N strokeColor:kStockMA5LineColor];
    [self drawWithPositionPointKey:@"DMI_MDIPositionPoint" N:kStock_DMI_PDIMDI_N strokeColor:kStockMA10LineColor];
    [self drawWithPositionPointKey:@"DMI_ADXPositionPoint" N:kStock_DMI_ADX_ADXR_N strokeColor:kStockMA20LineColor];
    [self drawWithPositionPointKey:@"DMI_ADXRPositionPoint" N:kStock_DMI_ADX_ADXR_N strokeColor:kStockMA30LineColor];

}

- (void)drawVR {
    
    [self drawWithPositionPointKey:@"VRPositionPoint" N:kStock_VR_N strokeColor:kStockMA30LineColor];
    [self drawWithPositionPointKey:@"VR_MAPositionPoint" N:kStock_VR_MA_N strokeColor:kStockMA10LineColor];
}

- (void)drawTRIX {
    
    [self drawWithPositionPointKey:@"TRIXPositionPoint" N:kStock_TRIX_N strokeColor:kStockMA30LineColor];
    [self drawWithPositionPointKey:@"TRIX_MAPositionPoint" N:kStock_TRIX_MA_N strokeColor:kStockMA10LineColor];
}

- (void)drawPSY {
    
    [self drawWithPositionPointKey:@"PSYPositionPoint" N:kStock_PSY_N strokeColor:kStockMA5LineColor];
    [self drawWithPositionPointKey:@"PSY_MAPositionPoint" N:kStock_PSY_MA_N strokeColor:kStockMA10LineColor];
}

- (void)drawDPO {
    
    [self drawWithPositionPointKey:@"DPOPositionPoint" N:kStock_DPO_N strokeColor:kStockMA5LineColor];
    [self drawWithPositionPointKey:@"DPO_MAPositionPoint" N:kStock_DPO_MA_N strokeColor:kStockMA10LineColor];
}

- (void)drawASI {
    
    [self drawWithPositionPointKey:@"ASIPositionPoint" N:kStock_ASI_N strokeColor:kStockMA5LineColor];
    [self drawWithPositionPointKey:@"ASI_MAPositionPoint" N:kStock_ASI_MA_N strokeColor:kStockMA10LineColor];

}

#pragma mark - other
- (void)drawWithPositionPointKey:(NSString *)positionPointKey N:(NSInteger)N strokeColor:(UIColor *)strokeColor {
    
    UIBezierPath *bezierPath = [self createBezierPathWithLineWidth:kStockPartLineHeight];
    
    // start index
    NSInteger startIndex = [self getStartIndexWithDrawKLineModels:self.drawKLineModels N:N];
    
    CGPoint startPoint = [[self.drawKLineModels[startIndex] valueForKey:positionPointKey] CGPointValue];
    NSAssert(!isnan(startPoint.x) && !isnan(startPoint.y), @"出现NAN值：MA画线");
    
    [bezierPath moveToPoint:startPoint];
    
    for (NSInteger idx = startIndex + 1; idx < self.drawKLineModels.count; idx++) {
        
        CGPoint point = [[self.drawKLineModels[idx] valueForKey:positionPointKey] CGPointValue];
        
        [bezierPath addLineToPoint:point];
    }
    [self createShapeLayerWithStrokeColor:strokeColor fillColor:kClearColor path:bezierPath frame:self.shapeLayer.frame backgroundColor:kClearColor];
    
}

- (UIBezierPath *)createBezierPathWithLineWidth:(CGFloat)lineWidth {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = lineWidth;
    return path;
}

- (void)createShapeLayerWithStrokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor path:(UIBezierPath *)path frame:(CGRect)frame backgroundColor:(UIColor *)backGroundColor {
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = fillColor.CGColor;
    layer.strokeColor = strokeColor.CGColor;
    layer.path = path.CGPath;
    layer.frame = frame;
    layer.backgroundColor = backGroundColor.CGColor;
    [self.shapeLayer addSublayer:layer];
}

- (NSInteger)getStartIndexWithDrawKLineModels:(NSArray <YFStock_KLineModel *> *)drawKLineModels N:(NSInteger)N {
    
    NSInteger startIndex = 0;
    
    if ([drawKLineModels.firstObject index].integerValue <= N - 1) {
        
        startIndex = N - 1 - [drawKLineModels.firstObject index].integerValue;
    }
    if (startIndex > drawKLineModels.count - 1) {
        
        startIndex = drawKLineModels.count - 1;
    }
    
    return startIndex;
}

@end
