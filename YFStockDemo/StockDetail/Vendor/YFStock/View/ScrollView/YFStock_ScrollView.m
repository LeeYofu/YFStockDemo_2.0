//
//  YFStock_ScrollView.m
//  YFStockDemo
//
//  Created by 李友富 on 2017/3/30.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import "YFStock_ScrollView.h"

@interface YFStock_ScrollView()

@property (nonatomic, strong) YFStock_DataHandler *dataHandler;
@property (nonatomic, assign) CGFloat KLineViewHeight;
@property (nonatomic, assign) CGFloat bottomViewY;

@end

@implementation YFStock_ScrollView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self config];
    }
    return self;
}

- (void)config {
    
    self.backgroundColor = kClearColor;
    
    self.bounces = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
}

#pragma mark - drawRectangle
- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // clear
    CGContextClearRect(ctx, rect);
    
    // time line
    if (self.stockLineType == YFStockLineTypeTimeLine) {
        
        
    } else { // K line(分k线和成交量线条)
        
        CGContextSetStrokeColorWithColor(ctx, kStockKlinePartLineColor.CGColor);
        CGContextSetLineWidth(ctx, kStockPartLineHeight);
        
        // k line **********  **********
        // 1.获取绘制KLineView的高度，然后根据其行数求出单位高度
        CGFloat KLineViewHeight = self.KLineViewHeight;
        CGFloat KlineUnitHeight = (KLineViewHeight - 2 * kStockKLineScrollViewInsideTopBottomPadding ) / [YFStock_Variable KLineRowCount];
        
        // 2.根据单位高度和行数绘制KLineView的分割线
        // 顶部线条
        const CGPoint topLine[] = { CGPointMake(0, kStockPartLineHeight), CGPointMake(self.contentSize.width, kStockPartLineHeight) };
        CGContextStrokeLineSegments(ctx, topLine, 2);
        // 底部线条
        const CGPoint bottomLine[] = { CGPointMake(0, KLineViewHeight), CGPointMake(self.contentSize.width, KLineViewHeight) };
        CGContextStrokeLineSegments(ctx, bottomLine, 2);

        
        CGFloat y = kStockKLineScrollViewInsideTopBottomPadding;
        for (int i = 0; i < [YFStock_Variable KLineRowCount] + 1; i ++) {
            
            const CGPoint line[] = { CGPointMake(0, y), CGPointMake(self.contentSize.width, y) };
            
            CGContextStrokeLineSegments(ctx, line, 2);

            y += KlineUnitHeight;
        }
        
        // volumeLine **********  **********
        // 先求出 line0的y值【这里投机取巧了一些，但是丝毫无影响】
        CGFloat line0Y = self.bottomViewY + kStockPartLineHeight;
        const CGPoint line0[] = { CGPointMake(0, line0Y), CGPointMake(self.contentSize.width, line0Y) };
        const CGPoint line1[] = { CGPointMake(0, self.height - kStockPartLineHeight), CGPointMake(self.contentSize.width, self.height - kStockPartLineHeight) };

        CGContextStrokeLineSegments(ctx, line0, 2);
        CGContextStrokeLineSegments(ctx, line1, 2);
        
        // 竖线(时间分割线) **********  **********
        [self.dataHandler.drawKLineModels enumerateObjectsUsingBlock:^(YFStock_KLineModel * _Nonnull KLineModel, NSUInteger idx, BOOL * _Nonnull stop) {
           
            if (KLineModel.isShowTime) {
                
                const CGPoint line[] = { CGPointMake(KLineModel.highPricePositionPoint.x, 0), CGPointMake(KLineModel.highPricePositionPoint.x, self.height) };
                CGContextStrokeLineSegments(ctx, line, 2);
            }
        }];
    }
}

- (void)drawWithDataHandler:(YFStock_DataHandler *)dataHandler KLineViewHeight:(CGFloat)KLineViewHeight bottomViewY:(CGFloat)bottomViewY {
    
    self.dataHandler = dataHandler;
    self.KLineViewHeight = KLineViewHeight;
    self.bottomViewY = bottomViewY;
    
    [self setNeedsDisplay];
//    // 获取上下文
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    // clear
////    CGContextClearRect(ctx, rect);
//    
//    // time line
//    if (self.stockLineType == YFStockLineTypeTimeLine) {
//        
//        
//    } else { // K line(分k线和成交量线条)
//        
//        CGContextSetStrokeColorWithColor(ctx, kStockKlinePartLineColor.CGColor);
//        CGContextSetLineWidth(ctx, kStockPartLineHeight);
//        
//        // k line **********  **********
//        // 1.获取绘制KLineView的高度，然后根据其行数求出单位高度
//        CGFloat KLineViewHeight = self.KLineViewHeight;
//        CGFloat KlineUnitHeight = (KLineViewHeight - 2 * kStockKLineScrollViewInsideTopBottomPadding ) / [YFStock_Variable KLineRowCount];
//        
//        // 2.根据单位高度和行数绘制KLineView的分割线
//        // 顶部线条
//        const CGPoint topLine[] = { CGPointMake(0, kStockPartLineHeight), CGPointMake(self.contentSize.width, kStockPartLineHeight) };
//        CGContextStrokeLineSegments(ctx, topLine, 2);
//        // 底部线条
//        const CGPoint bottomLine[] = { CGPointMake(0, KLineViewHeight), CGPointMake(self.contentSize.width, KLineViewHeight) };
//        CGContextStrokeLineSegments(ctx, bottomLine, 2);
//        
//        
//        CGFloat y = kStockKLineScrollViewInsideTopBottomPadding;
//        for (int i = 0; i < [YFStock_Variable KLineRowCount] + 1; i ++) {
//            
//            const CGPoint line[] = { CGPointMake(0, y), CGPointMake(self.contentSize.width, y) };
//            
//            CGContextStrokeLineSegments(ctx, line, 2);
//            
//            y += KlineUnitHeight;
//        }
//        
//        // volumeLine **********  **********
//        // 先求出 line0的y值【这里投机取巧了一些，但是丝毫无影响】
//        CGFloat line0Y = self.bottomViewY + kStockPartLineHeight;
//        const CGPoint line0[] = { CGPointMake(0, line0Y), CGPointMake(self.contentSize.width, line0Y) };
//        const CGPoint line1[] = { CGPointMake(0, self.height - kStockPartLineHeight), CGPointMake(self.contentSize.width, self.height - kStockPartLineHeight) };
//        
//        CGContextStrokeLineSegments(ctx, line0, 2);
//        CGContextStrokeLineSegments(ctx, line1, 2);
//        
//        // 竖线(时间分割线) **********  **********
//        [self.dataHandler.drawKLineModels enumerateObjectsUsingBlock:^(YFStock_KLineModel * _Nonnull KLineModel, NSUInteger idx, BOOL * _Nonnull stop) {
//            
//            if (KLineModel.isShowTime) {
//                
//                const CGPoint line[] = { CGPointMake(KLineModel.highPricePositionPoint.x, 0), CGPointMake(KLineModel.highPricePositionPoint.x, self.height) };
//                CGContextStrokeLineSegments(ctx, line, 2);
//            }
//        }];
//    }

}

@end
