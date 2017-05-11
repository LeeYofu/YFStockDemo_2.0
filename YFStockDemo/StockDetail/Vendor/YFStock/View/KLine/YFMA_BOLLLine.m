

#import "YFMA_BOLLLine.h"

@interface YFMA_BOLLLine()

@property (nonatomic, strong) NSArray *drawKLineModels;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;


@end

@implementation YFMA_BOLLLine

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
- (void)drawWithKLineModels:(NSArray<YFStock_KLineModel *> *)drawKLineModels KLineLineType:(YFStockKLineLineType)KLineLineType {

    if(!drawKLineModels || drawKLineModels.count == 0) {

        return;
    }
    
    if (_shapeLayer) {
        
        [_shapeLayer removeFromSuperlayer];
        _shapeLayer = nil;
    }

    self.drawKLineModels = drawKLineModels;

    switch (KLineLineType) {
        case YFStockKLineLineType_MA:
        {
            [self drawMA];
        }
            break;
        case YFStockKLineLineType_BOLL:
        {
            [self drawBOLL];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - MA
- (void)drawMA {
    
    [self drawMA_5];
    [self drawMA_10];
    [self drawMA_20];
}

- (void)drawMA_5 {
    
    [self drawWithPositionPointKey:@"MA_5PositionPoint" N:kStock_MA_5_N strokeColor:kStockMA5LineColor];
}

- (void)drawMA_10 {
    
    [self drawWithPositionPointKey:@"MA_10PositionPoint" N:kStock_MA_10_N strokeColor:kStockMA10LineColor];
}

- (void)drawMA_20 {
    
    [self drawWithPositionPointKey:@"MA_20PositionPoint" N:kStock_MA_20_N strokeColor:kStockMA20LineColor];
}

#pragma mark - BOLL
- (void)drawBOLL {
    
    [self drawBOLL_UPPER];
    [self drawBOLL_MID];
    [self drawBOLL_LOWER];
}

- (void)drawBOLL_UPPER {
    
    [self drawWithPositionPointKey:@"BOLL_UpperPositionPoint" N:0 strokeColor:kStockMA5LineColor];
}

- (void)drawBOLL_MID {
    
    [self drawWithPositionPointKey:@"BOLL_MidPositionPoint" N:0 strokeColor:kStockMA5LineColor];
}

- (void)drawBOLL_LOWER {
    
    [self drawWithPositionPointKey:@"BOLL_LowerPositionPoint" N:0 strokeColor:kStockMA5LineColor];
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
