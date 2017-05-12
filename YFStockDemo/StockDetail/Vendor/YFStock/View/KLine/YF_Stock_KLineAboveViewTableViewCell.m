//
//  YF_Stock_KLineAboveViewTableViewCell.m
//  YFStockDemo
//
//  Created by 李友富 on 2017/5/8.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import "YF_Stock_KLineAboveViewTableViewCell.h"

@interface YF_Stock_KLineAboveViewTableViewCell()

@property (nonatomic, assign) CGFloat lastVisibleMax;
@property (nonatomic, assign) CGFloat lastVisibleMin;

@property (nonatomic, strong) CAShapeLayer *KLineShapeLayer;
@property (nonatomic, strong) CAShapeLayer *MA_1ShapeLayer;
@property (nonatomic, strong) CAShapeLayer *MA_2ShapeLayer;
@property (nonatomic, strong) CAShapeLayer *MA_3ShapeLayer;
@property (nonatomic, strong) CAShapeLayer *MA_4ShapeLayer;

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *partLine;

@end

@implementation YF_Stock_KLineAboveViewTableViewCell

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - lazy loading
- (CAShapeLayer *)KLineShapeLayer {
    
    if (_KLineShapeLayer == nil) {
        
        _KLineShapeLayer = [CAShapeLayer layer];
        _KLineShapeLayer.frame = self.contentView.bounds;
        _KLineShapeLayer.lineJoin = kCALineJoinRound;
        _KLineShapeLayer.lineCap = kCALineCapRound;
        [self.layer addSublayer:_KLineShapeLayer];
    }
    return _KLineShapeLayer;
}

- (CAShapeLayer *)getLineLayer {
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.contentView.bounds;
    layer.fillColor = kClearColor.CGColor;
    layer.lineWidth = 1.0f;
    layer.lineJoin = kCALineJoinRound;
    layer.lineCap = kCALineCapRound;
    
    [self.contentView.layer addSublayer:layer];
    
    return layer;
}

- (CAShapeLayer *)MA_1ShapeLayer {
    
    if (_MA_1ShapeLayer == nil) {
        
        _MA_1ShapeLayer = [self getLineLayer];
    }
    return _MA_1ShapeLayer;
}

- (CAShapeLayer *)MA_2ShapeLayer {
    
    if (_MA_2ShapeLayer == nil) {
        
        _MA_2ShapeLayer = [self getLineLayer];
    }
    return _MA_2ShapeLayer;
}

- (CAShapeLayer *)MA_3ShapeLayer {
    
    if (_MA_3ShapeLayer == nil) {
        
        _MA_3ShapeLayer = [self getLineLayer];
    }
    return _MA_3ShapeLayer;
}

- (CAShapeLayer *)MA_4ShapeLayer {
    
    if (_MA_4ShapeLayer == nil) {
        
        _MA_4ShapeLayer = [self getLineLayer];
    }
    return _MA_4ShapeLayer;
}

- (UIView *)partLine {
    
    if (_partLine == nil) {
        
        _partLine = [UIView new];
        _partLine.backgroundColor = kStockKlinePartLineColor;
        [self.contentView addSubview:_partLine];
        _partLine.hidden = YES;
        
        _partLine.frame = CGRectMake(-kStockKLineAboveViewTopBottomPadding, self.cHeight * 0.5 - 0.5 * kStockPartLineHeight, self.cWidth + 2 * kStockKLineAboveViewTopBottomPadding, kStockPartLineHeight);
    }
    return _partLine;
}

- (UILabel *)timeLabel {
    
    if (_timeLabel == nil) {
        
        _timeLabel = [UILabel new];
        _timeLabel.font = kFont_9;
        _timeLabel.textColor = kCustomRGBColor(103, 103, 103, 1.0);
        _timeLabel.hidden = YES;
        _timeLabel.backgroundColor = kClearColor;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_timeLabel];
        _timeLabel.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
        
        _timeLabel.frame = CGRectMake(-15 - kStockKLineAboveViewTopBottomPadding, -30 + self.cHeight * 0.5, 15, 60);
    }
    return _timeLabel;
}


#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = kClearColor;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KLineAboveMaxMinValueChanged:) name:@"KLineAboveMaxMinValueChanged" object:nil];
    }
    return self;
}

- (void)KLineAboveMaxMinValueChanged:(NSNotification *)notify {
    
    NSArray *arr = [notify object];
    
    self.visibleMax = [arr[0] floatValue];
    self.visibleMin = [arr[1] floatValue];
    
    if (self.isFullScreen == [YFStock_Variable isFullScreen] && self.topBarSelectedIndex == [YFStock_Variable selectedIndex] && self.bottomBarIndex == [YFStock_Variable bottomBarSelectedIndex]) {
        
        [self drawAllLine];
    }
}

- (void)setNextKLineModel:(YFStock_KLineModel *)nextKLineModel {
    
    _nextKLineModel = nextKLineModel;
    
    [self drawAllLine];
}

- (void)setKLineModel:(YFStock_KLineModel *)KLineModel {
    
    _KLineModel = KLineModel;
    
    if (KLineModel.isShowTime) {
        
        self.timeLabel.hidden = NO;
        self.timeLabel.text = KLineModel.showTimeStr;
        
        self.partLine.hidden = NO;
    } else {
        
        self.timeLabel.hidden = YES;
        
        self.partLine.hidden = YES;
    }
}

#pragma mark - draw
- (void)drawAllLine {
    
    [self drawKLine];
    [self drawMALine];
}

- (void)drawKLine {
    
    CGFloat KLineUnitValue = [self getKLineUnitValue];
    if (KLineUnitValue == 0) KLineUnitValue = 0.01f;
    UIColor *strokeColor;
    CGFloat x, y, width, height;
    CGFloat topLineHeight, bottomLineHeight;
    
    y = [YFStock_Variable KLineGap] * 0.5;
    height = [YFStock_Variable KLineWidth];
    
    if (self.KLineModel.isIncrease) {
        
        strokeColor = kStockIncreaseColor;
        
        x = [self getXWithValue:self.KLineModel.openPrice.floatValue];
        width = ABS(self.KLineModel.openPrice.floatValue - self.KLineModel.closePrice.floatValue) / KLineUnitValue;
        topLineHeight = ABS(self.KLineModel.highPrice.floatValue - self.KLineModel.closePrice.floatValue) / KLineUnitValue;
        bottomLineHeight = ABS(self.KLineModel.lowPrice.floatValue - self.KLineModel.openPrice.floatValue) / KLineUnitValue;
    } else {
        
        strokeColor = kStockDecreaseColor;
        
        x = [self getXWithValue:self.KLineModel.closePrice.floatValue];
        width = ABS(self.KLineModel.openPrice.floatValue - self.KLineModel.closePrice.floatValue) / KLineUnitValue;
        topLineHeight = ABS(self.KLineModel.highPrice.floatValue - self.KLineModel.openPrice.floatValue) / KLineUnitValue;
        bottomLineHeight = ABS(self.KLineModel.lowPrice.floatValue - self.KLineModel.closePrice.floatValue) / KLineUnitValue;
    }
        
    CGRect rect = CGRectMake(x, y, width, height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    
    CGFloat highLowY = self.cHeight * 0.5;
    [path moveToPoint:CGPointMake(x + width, highLowY)];
    [path addLineToPoint:CGPointMake(x + width + topLineHeight, highLowY)];
    [path moveToPoint:CGPointMake(x , highLowY)];
    [path addLineToPoint:CGPointMake(x - bottomLineHeight, highLowY)];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.KLineShapeLayer.fillColor = self.KLineModel.isIncrease ? kWhiteColor.CGColor : strokeColor.CGColor;
    self.KLineShapeLayer.strokeColor = strokeColor.CGColor;
    [CATransaction commit];
    
    self.KLineShapeLayer.path = path.CGPath;
    
}

- (void)drawMALine {
    
    [self drawMA_1];
    [self drawMA_2];
    [self drawMA_3];
    [self drawMA_4];
}

- (void)drawMA_1 {
    
    UIBezierPath *bezierPath = [self getBezierPahtForMAWithKey:@"MA_5"];
    [self drawMALineWithLayer:self.MA_1ShapeLayer bezierPath:bezierPath strokeColor:kStockMA5LineColor];
}

- (void)drawMA_2 {
    
    UIBezierPath *bezierPath = [self getBezierPahtForMAWithKey:@"MA_10"];
    [self drawMALineWithLayer:self.MA_2ShapeLayer bezierPath:bezierPath strokeColor:kStockMA10LineColor];
}

- (void)drawMA_3 {
    
    UIBezierPath *bezierPath = [self getBezierPahtForMAWithKey:@"MA_20"];
    [self drawMALineWithLayer:self.MA_3ShapeLayer bezierPath:bezierPath strokeColor:kStockMA20LineColor];
}

- (void)drawMA_4 {
    
    UIBezierPath *bezierPath = [self getBezierPahtForMAWithKey:@"MA_30"];
    [self drawMALineWithLayer:self.MA_4ShapeLayer bezierPath:bezierPath strokeColor:kStockMA30LineColor];
}

- (UIBezierPath *)getBezierPahtForMAWithKey:(NSString *)key {
    
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

- (void)drawMALineWithLayer:(CAShapeLayer *)layer bezierPath:(UIBezierPath *)bezierPath strokeColor:(UIColor *)strokeColor {
    
    layer.strokeColor = strokeColor.CGColor;
    layer.path = bezierPath.CGPath;
}

#pragma mark - 计算
- (CGFloat)getKLineMaxX {
    
    return self.cWidth - 2 * 1;
}

- (CGFloat)getKLineMinX {
    
    return 1;
}

- (CGFloat)getKLineUnitValue {
    
    CGFloat KLineUnitValue = (self.visibleMax - self.visibleMin) / ([self getKLineMaxX] - [self getKLineMinX]);
    
    return KLineUnitValue;
}

- (CGFloat)getXWithValue:(CGFloat)value {
    
    CGFloat x = (value - self.visibleMin) / [self getKLineUnitValue]  + [self getKLineMinX];
    
    return x;
}

@end
