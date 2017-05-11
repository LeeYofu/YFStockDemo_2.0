//
//  YF_Stock_KLineBelowViewTableViewCell.m
//  YFStockDemo
//
//  Created by 李友富 on 2017/5/8.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import "YF_Stock_KLineBelowViewTableViewCell.h"

@interface YF_Stock_KLineBelowViewTableViewCell()

@property (nonatomic, strong) CAShapeLayer *layer1;
@property (nonatomic, strong) CAShapeLayer *layer2;
@property (nonatomic, strong) CAShapeLayer *layer3;
@property (nonatomic, strong) CAShapeLayer *layer4;

@property (nonatomic, strong) UIView *partLine;

@end

@implementation YF_Stock_KLineBelowViewTableViewCell

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (CAShapeLayer *)getMALayer {
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.backgroundColor = kWhiteColor.CGColor;
    layer.fillColor = kClearColor.CGColor;
    layer.lineWidth = 1.0f;
    layer.lineJoin = kCALineJoinRound;
    layer.lineCap = kCALineCapRound;
    return layer;
}

- (CAShapeLayer *)layer1 {
    
    if (_layer1 == nil) {
        
        _layer1 = [self getMALayer];
        [self.contentView.layer addSublayer:_layer1];
    }
    return _layer1;
}

- (CAShapeLayer *)layer2 {
    
    if (_layer2 == nil) {
        
        _layer2 = [self getMALayer];
        [self.contentView.layer addSublayer:_layer2];
    }
    return _layer2;
}

- (CAShapeLayer *)layer3 {
    
    if (_layer3 == nil) {
        
        _layer3 = [self getMALayer];
        [self.contentView.layer addSublayer:_layer3];
    }
    return _layer3;
}

- (CAShapeLayer *)layer4 {
    
    if (_layer4 == nil) {
        
        _layer4 = [self getMALayer];
        [self.contentView.layer addSublayer:_layer4];
    }
    return _layer4;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = kWhiteColor;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KLineBelowMaxMinValueChanged:) name:@"KLineBelowMaxMinValueChanged" object:nil];
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.partLine = [UIView new];
    self.partLine.backgroundColor = kStockKlinePartLineColor;
    [self.contentView addSubview:self.partLine];
    self.partLine.hidden = YES;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
        
    self.partLine.frame = CGRectMake(0, self.cHeight * 0.5 - 0.5 * kStockPartLineHeight, self.cWidth, kStockPartLineHeight);
}

- (void)KLineBelowMaxMinValueChanged:(NSNotification *)notify {
    
    NSArray *arr = [notify object];
    
    self.visibleMax = [arr[0] floatValue];
    self.visibleMin = [arr[1] floatValue];
    
    if (self.isFullScreen == [YFStock_Variable isFullScreen] && self.topBarSelectedIndex == [YFStock_Variable selectedIndex]) {
        
        [self drawWithBottomBarIndex:self.bottomBarIndex];
    }
}

- (void)drawWithBottomBarIndex:(NSInteger)bottomBarIndex {
    
    self.layer1.path = nil;
    self.layer2.path = nil;
    self.layer3.path = nil;
    self.layer4.path = nil;
    
    switch (bottomBarIndex) {
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

    
}

- (void)drawMACD {
    
    // BAR
    CGFloat unitValue = [self getBelowLineUnitValue];

    UIColor *strokeColor;
    CGFloat x, y, width, height;
    
    y = [YFStock_Variable KLineGap] * 0.5;
    height = [YFStock_Variable KLineWidth];
    x = self.cWidth * 0.5f;
    width = self.KLineModel.MACD_BAR.floatValue / unitValue;

    if (self.KLineModel.MACD_BAR.floatValue > 0) {
        
        strokeColor = kStockIncreaseColor;
    } else {
        
        strokeColor = kStockDecreaseColor;
    }

    CGRect rect = CGRectMake(x, y, width, height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES]; 
    self.layer3.fillColor = strokeColor.CGColor;
    self.layer3.strokeColor = strokeColor.CGColor;
    [CATransaction commit];
    
    self.layer3.path = path.CGPath;
    
    // DIF  DEA
    UIBezierPath *bezierPath1 = [self getBezierPathWithKey:@"MACD_DIF"];
    [self drawLineWithLayer:self.layer1 bezierPath:bezierPath1 strokeColor:kStockMA5LineColor];
    
    UIBezierPath *bezierPat2 = [self getBezierPathWithKey:@"MACD_DEA"];
    [self drawLineWithLayer:self.layer2 bezierPath:bezierPat2 strokeColor:kStockMA10LineColor];
}

- (void)drawKDJ {
    
    UIBezierPath *bezierPath_K = [self getBezierPathWithKey:@"KDJ_K"];
    [self drawLineWithLayer:self.layer1 bezierPath:bezierPath_K strokeColor:kStockMA5LineColor];
    
    UIBezierPath *bezierPath_D = [self getBezierPathWithKey:@"KDJ_D"];
    [self drawLineWithLayer:self.layer2 bezierPath:bezierPath_D strokeColor:kStockMA10LineColor];
    
    UIBezierPath *bezierPath_J = [self getBezierPathWithKey:@"KDJ_J"];
    [self drawLineWithLayer:self.layer3 bezierPath:bezierPath_J strokeColor:kStockMA20LineColor];
}

- (void)drawRSI {
    
    UIBezierPath *bezierPath_RSI1 = [self getBezierPathWithKey:@"RSI_6"];
    [self drawLineWithLayer:self.layer1 bezierPath:bezierPath_RSI1 strokeColor:kStockMA5LineColor];
    
    UIBezierPath *bezierPath_RSI2 = [self getBezierPathWithKey:@"RSI_12"];
    [self drawLineWithLayer:self.layer2 bezierPath:bezierPath_RSI2 strokeColor:kStockMA10LineColor];
    
    UIBezierPath *bezierPath_RSI3 = [self getBezierPathWithKey:@"RSI_24"];
    [self drawLineWithLayer:self.layer3 bezierPath:bezierPath_RSI3 strokeColor:kStockMA20LineColor];
}

- (void)drawARBR {
    
    UIBezierPath *bezierPath_AR = [self getBezierPathWithKey:@"ARBR_AR"];
    [self drawLineWithLayer:self.layer1 bezierPath:bezierPath_AR strokeColor:kStockMA5LineColor];
    
    UIBezierPath *bezierPath_BR = [self getBezierPathWithKey:@"ARBR_BR"];
    [self drawLineWithLayer:self.layer2 bezierPath:bezierPath_BR strokeColor:kStockMA10LineColor];
}

- (void)drawOBV {
    
    UIBezierPath *bezierPath_OBV = [self getBezierPathWithKey:@"OBV"];
    [self drawLineWithLayer:self.layer1 bezierPath:bezierPath_OBV strokeColor:kStockMA5LineColor];
}

- (void)drawWR {
    
    UIBezierPath *bezierPath_WR1 = [self getBezierPathWithKey:@"WR_1"];
    [self drawLineWithLayer:self.layer1 bezierPath:bezierPath_WR1 strokeColor:kStockMA5LineColor];
    
    UIBezierPath *bezierPath_WR2 = [self getBezierPathWithKey:@"WR_2"];
    [self drawLineWithLayer:self.layer2 bezierPath:bezierPath_WR2 strokeColor:kStockMA10LineColor];
}

- (void)drawEMV {
    
    UIBezierPath *bezierPath_EMV = [self getBezierPathWithKey:@"EMV"];
    [self drawLineWithLayer:self.layer1 bezierPath:bezierPath_EMV strokeColor:kStockMA5LineColor];
    
    UIBezierPath *bezierPath_EMV_MA = [self getBezierPathWithKey:@"EMV_MA"];
    [self drawLineWithLayer:self.layer2 bezierPath:bezierPath_EMV_MA strokeColor:kStockMA10LineColor];
}

- (void)drawDMA {
    
    UIBezierPath *bezierPath_DDD = [self getBezierPathWithKey:@"DDD"];
    [self drawLineWithLayer:self.layer1 bezierPath:bezierPath_DDD strokeColor:kStockMA5LineColor];
    
    UIBezierPath *bezierPath_AMA = [self getBezierPathWithKey:@"AMA"];
    [self drawLineWithLayer:self.layer2 bezierPath:bezierPath_AMA strokeColor:kStockMA10LineColor];
}

- (void)drawCCI {
    
    UIBezierPath *bezierPath_CCI = [self getBezierPathWithKey:@"CCI"];
    [self drawLineWithLayer:self.layer1 bezierPath:bezierPath_CCI strokeColor:kStockMA5LineColor];
}

- (void)drawBIAS {
    
    UIBezierPath *bezierPath_BIAS1 = [self getBezierPathWithKey:@"BIAS_1"];
    [self drawLineWithLayer:self.layer1 bezierPath:bezierPath_BIAS1 strokeColor:kStockMA5LineColor];
    
    UIBezierPath *bezierPath_BIAS2 = [self getBezierPathWithKey:@"BIAS_2"];
    [self drawLineWithLayer:self.layer2 bezierPath:bezierPath_BIAS2 strokeColor:kStockMA10LineColor];
    
    UIBezierPath *bezierPath_BIAS3 = [self getBezierPathWithKey:@"BIAS_3"];
    [self drawLineWithLayer:self.layer3 bezierPath:bezierPath_BIAS3 strokeColor:kStockMA20LineColor];
}

- (void)drawROC {
    
    UIBezierPath *bezierPath_ROC = [self getBezierPathWithKey:@"ROC"];
    [self drawLineWithLayer:self.layer1 bezierPath:bezierPath_ROC strokeColor:kStockMA5LineColor];
    
    UIBezierPath *bezierPath_ROC_MA = [self getBezierPathWithKey:@"ROC_MA"];
    [self drawLineWithLayer:self.layer2 bezierPath:bezierPath_ROC_MA strokeColor:kStockMA10LineColor];
}

- (void)drawMTM {
    
    UIBezierPath *bezierPath_MTM = [self getBezierPathWithKey:@"MTM"];
    [self drawLineWithLayer:self.layer1 bezierPath:bezierPath_MTM strokeColor:kStockMA5LineColor];
    
    UIBezierPath *bezierPath_MTM_MA = [self getBezierPathWithKey:@"MTM_MA"];
    [self drawLineWithLayer:self.layer2 bezierPath:bezierPath_MTM_MA strokeColor:kStockMA10LineColor];
}

- (void)drawCR {
    
    UIBezierPath *bezierPath_CR = [self getBezierPathWithKey:@"CR"];
    [self drawLineWithLayer:self.layer1 bezierPath:bezierPath_CR strokeColor:kStockMA5LineColor];
    
    UIBezierPath *bezierPath_CR_MA_1 = [self getBezierPathWithKey:@"CR_MA_1"];
    [self drawLineWithLayer:self.layer2 bezierPath:bezierPath_CR_MA_1 strokeColor:kStockMA10LineColor];
    
    UIBezierPath *bezierPath_CR_MA_2 = [self getBezierPathWithKey:@"CR_MA_2"];
    [self drawLineWithLayer:self.layer3 bezierPath:bezierPath_CR_MA_2 strokeColor:kStockMA20LineColor];    
}

- (void)drawDMI {
    
    UIBezierPath *bezierPath1 = [self getBezierPathWithKey:@"DMI_PDI"];
    [self drawLineWithLayer:self.layer1 bezierPath:bezierPath1 strokeColor:kStockMA5LineColor];
    
    UIBezierPath *bezierPat2 = [self getBezierPathWithKey:@"DMI_MDI"];
    [self drawLineWithLayer:self.layer2 bezierPath:bezierPat2 strokeColor:kStockMA10LineColor];
    
    UIBezierPath *bezierPath3 = [self getBezierPathWithKey:@"DMI_ADX"];
    [self drawLineWithLayer:self.layer3 bezierPath:bezierPath3 strokeColor:kStockMA20LineColor];
    
    UIBezierPath *bezierPath4 = [self getBezierPathWithKey:@"DMI_ADXR"];
    [self drawLineWithLayer:self.layer4 bezierPath:bezierPath4 strokeColor:kStockMA30LineColor];
}

- (void)drawVR {
    
    UIBezierPath *bezierPath1 = [self getBezierPathWithKey:@"VR"];
    [self drawLineWithLayer:self.layer1 bezierPath:bezierPath1 strokeColor:kStockMA5LineColor];
    
    UIBezierPath *bezierPat2 = [self getBezierPathWithKey:@"VR_MA"];
    [self drawLineWithLayer:self.layer2 bezierPath:bezierPat2 strokeColor:kStockMA10LineColor];
}

- (void)drawTRIX {
    
    UIBezierPath *bezierPath1 = [self getBezierPathWithKey:@"TRIX"];
    [self drawLineWithLayer:self.layer1 bezierPath:bezierPath1 strokeColor:kStockMA5LineColor];
    
    UIBezierPath *bezierPat2 = [self getBezierPathWithKey:@"TRIX_MA"];
    [self drawLineWithLayer:self.layer2 bezierPath:bezierPat2 strokeColor:kStockMA10LineColor];
}

- (void)drawPSY {
    
    UIBezierPath *bezierPath1 = [self getBezierPathWithKey:@"PSY"];
    [self drawLineWithLayer:self.layer1 bezierPath:bezierPath1 strokeColor:kStockMA5LineColor];
    
    UIBezierPath *bezierPat2 = [self getBezierPathWithKey:@"PSY_MA"];
    [self drawLineWithLayer:self.layer2 bezierPath:bezierPat2 strokeColor:kStockMA10LineColor];
}

- (void)drawDPO {
    
    UIBezierPath *bezierPath1 = [self getBezierPathWithKey:@"DPO"];
    [self drawLineWithLayer:self.layer1 bezierPath:bezierPath1 strokeColor:kStockMA5LineColor];
    
    UIBezierPath *bezierPat2 = [self getBezierPathWithKey:@"DPO_MA"];
    [self drawLineWithLayer:self.layer2 bezierPath:bezierPat2 strokeColor:kStockMA10LineColor];
}

- (void)drawASI {
    
    UIBezierPath *bezierPath1 = [self getBezierPathWithKey:@"ASI"];
    [self drawLineWithLayer:self.layer1 bezierPath:bezierPath1 strokeColor:kStockMA5LineColor];
    
    UIBezierPath *bezierPat2 = [self getBezierPathWithKey:@"ASI_MA"];
    [self drawLineWithLayer:self.layer2 bezierPath:bezierPat2 strokeColor:kStockMA10LineColor];
}

- (UIBezierPath *)getBezierPathWithKey:(NSString *)key {
    
    CGFloat leftX, leftY, midX, midY, rightX, rightY;
    
    midX = [self getXWithValue:[[self.KLineModel valueForKey:key] floatValue]];
    midY = self.cHeight * 0.5;
    
    leftX = [self getXWithValue:([[self.lastKLineModel valueForKey:key] floatValue] + [[self.KLineModel valueForKey:key] floatValue]) * 0.5];
    leftY = 0;
    
    rightX = [self getXWithValue:([[self.nextKLineModel valueForKey:key] floatValue] + [[self.KLineModel valueForKey:key] floatValue]) * 0.5];;
    rightY = self.cHeight;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    if (self.lastKLineModel) {
        
        [bezierPath moveToPoint:CGPointMake(leftX, leftY)];
    } else {
        
        [bezierPath moveToPoint:CGPointMake(midX, midY)];
    }
    [bezierPath addLineToPoint:CGPointMake(midX, midY)];
    
    if (self.nextKLineModel) {
        
        [bezierPath addLineToPoint:CGPointMake(rightX, rightY)];
    }
    
    return bezierPath;
}

- (void)drawLineWithLayer:(CAShapeLayer *)layer bezierPath:(UIBezierPath *)bezierPath strokeColor:(UIColor *)strokeColor {
    
    layer.strokeColor = strokeColor.CGColor;
    layer.path = bezierPath.CGPath;
}

#pragma mark - 计算
- (CGFloat)getBelowLineMaxX {
    
    return self.cWidth - 2 * 1;
}

- (CGFloat)getBelowLineMinX {
    
    return 1;
}

- (CGFloat)getBelowLineUnitValue {
    
    CGFloat unitValue = (self.visibleMax - self.visibleMin) / ([self getBelowLineMaxX] - [self getBelowLineMinX]);
    
    if (unitValue == 0) unitValue = 0.01f;

    return unitValue;
}

- (CGFloat)getXWithValue:(CGFloat)value {
    
    CGFloat x = (value - self.visibleMin) / [self getBelowLineUnitValue] + [self getBelowLineMinX];
    
    return x;
}

#pragma mark - setter
- (void)setBottomBarIndex:(YFStockBottomBarIndex)bottomBarIndex {
    
    _bottomBarIndex = bottomBarIndex;
    
    [self drawWithBottomBarIndex:bottomBarIndex];
}

- (void)setKLineModel:(YFStock_KLineModel *)KLineModel {
    
    _KLineModel = KLineModel;
    
    if (KLineModel.isShowTime) {
        
        self.partLine.hidden = NO;
    } else {
        
        self.partLine.hidden = YES;
    }
}

@end
