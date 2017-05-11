

#import "YFKline.h"
#import "YFStock_Header.h"

@interface YFKline()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation YFKline

- (CAShapeLayer *)shapeLayer {
    
    if (_shapeLayer == nil) {
        
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.frame = self.layer.bounds;
        _shapeLayer.backgroundColor = kClearColor.CGColor;
        [self.layer addSublayer:_shapeLayer];
    }
    return _shapeLayer;
}


#pragma mark - 绘制
- (void)drawWithDrawKLineModels:(NSArray<YFStock_KLineModel *> *)drawKLineModels {
    
    if (! drawKLineModels || drawKLineModels.count == 0) {
        
        return;
    }
    
    if (_shapeLayer) {
        
        [_shapeLayer removeFromSuperlayer];
        _shapeLayer = nil;
    }
    
    [drawKLineModels enumerateObjectsUsingBlock:^(YFStock_KLineModel *KLineModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIColor *strokeColor;
        CGFloat x, y, width, height;
        CGFloat topLineHeight, bottomLineHeight;
        CGFloat lineX;
    
        if (KLineModel.isIncrease) {
            
            strokeColor = kStockIncreaseColor;
            
            x = KLineModel.closePricePositionPoint.x - [YFStock_Variable KLineWidth] * 0.5;
            y = KLineModel.closePricePositionPoint.y;
            width = [YFStock_Variable KLineWidth];
            height = ABS(KLineModel.closePricePositionPoint.y - KLineModel.openPricePositionPoint.y);
            topLineHeight = ABS(KLineModel.highPricePositionPoint.y - KLineModel.closePricePositionPoint.y);
            bottomLineHeight = ABS(KLineModel.lowPricePositionPoint.y - KLineModel.openPricePositionPoint.y);
        } else {
            
            strokeColor = kStockDecreaseColor;
            
            x = KLineModel.openPricePositionPoint.x - [YFStock_Variable KLineWidth] * 0.5;
            y = KLineModel.openPricePositionPoint.y;
            width = [YFStock_Variable KLineWidth];
            height = ABS(KLineModel.openPricePositionPoint.y - KLineModel.closePricePositionPoint.y);
            topLineHeight = ABS(KLineModel.highPricePositionPoint.y - KLineModel.openPricePositionPoint.y);
            bottomLineHeight = ABS(KLineModel.lowPricePositionPoint.y - KLineModel.closePricePositionPoint.y);
        }
        
        lineX = KLineModel.openPricePositionPoint.x;
        
        CGRect rect = CGRectMake(x, y, width, height);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
        path.lineWidth = kStockPartLineHeight;
        [path moveToPoint:CGPointMake(lineX, y)];
        [path addLineToPoint:CGPointMake(lineX, y - topLineHeight)];
        [path moveToPoint:CGPointMake(lineX, y + height)];
        [path addLineToPoint:CGPointMake(lineX, y + height + bottomLineHeight)];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = KLineModel.isIncrease ? kWhiteColor.CGColor : strokeColor.CGColor;
        shapeLayer.strokeColor = strokeColor.CGColor;
        shapeLayer.path = path.CGPath;
        shapeLayer.frame = self.shapeLayer.bounds;
        shapeLayer.backgroundColor = kClearColor.CGColor;
        [self.shapeLayer addSublayer:shapeLayer];
        
    }];
}


@end
