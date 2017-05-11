//
//  YFStock_TimeLineView.m
//  YFStockDemo
//
//  Created by 李友富 on 2017/4/6.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import "YFStock_TimeLineView.h"
#import "YFStock_DataHandler.h"

@interface YFStock_TimeLineView()

@property (nonatomic, strong) YFStock_DataHandler *dataHandler;

@end

@implementation YFStock_TimeLineView

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // clear
    CGContextClearRect(ctx, rect);
    
    // security
    if (! self.dataHandler.drawTimeLineModels) {
        
        return;
    }
    
    if (self.dataHandler.drawTimeLineModels.count > 0) {
        
        // 画均线
        CGContextSetStrokeColorWithColor(ctx, kYellowColor.CGColor);
        CGFloat lengths[] = { 3, 3 };
        CGContextSetLineDash(ctx, 0, lengths, 2);
        CGContextSetLineWidth(ctx, 1.0);
        const CGPoint line1[] = { CGPointMake(0, self.dataHandler.avgTimeLinePositionY), CGPointMake(self.width, self.dataHandler.avgTimeLinePositionY) };
        CGContextStrokeLineSegments(ctx, line1, 2);
        
        // 画分时线
        CGContextSetStrokeColorWithColor(ctx, kRedColor.CGColor);
        CGFloat lengths1[] = { 1, 0 };
        CGContextSetLineDash(ctx, 0, lengths1, 2);
        CGContextSetLineWidth(ctx, kStockMALineWidth);
        CGPoint firstPoint = self.dataHandler.drawTimeLineModels.firstObject.pricePositionPoint;
        NSAssert(!isnan(firstPoint.x) && !isnan(firstPoint.y), @"出现NAN值：MA画线");
        CGContextMoveToPoint(ctx, firstPoint.x, firstPoint.y);
        for (NSInteger idx = 1; idx < self.dataHandler.drawTimeLineModels.count ; idx++) {
            
            CGPoint point = [self.dataHandler.drawTimeLineModels[idx] pricePositionPoint];
            CGContextAddLineToPoint(ctx, point.x, point.y);
        }
        CGContextStrokePath(ctx);
        
        // 画背景色
        CGContextSetFillColorWithColor(ctx, kCustom0xColor(0x60cfff, 0.1f).CGColor);
        CGPoint lastPoint = self.dataHandler.drawTimeLineModels.lastObject.pricePositionPoint;
        CGContextMoveToPoint(ctx, firstPoint.x, firstPoint.y);
        for (NSInteger idx = 1; idx < self.dataHandler.drawTimeLineModels.count ; idx++) {
            
            CGPoint point = [self.dataHandler.drawTimeLineModels[idx] pricePositionPoint];
            CGContextAddLineToPoint(ctx, point.x, point.y);
        }
        CGContextAddLineToPoint(ctx, lastPoint.x, CGRectGetMaxY(self.frame));
        CGContextAddLineToPoint(ctx, firstPoint.x, CGRectGetMaxY(self.frame));
        CGContextClosePath(ctx);
        CGContextFillPath(ctx);
    }
}

- (void)drawWithDataHandler:(YFStock_DataHandler *)dataHandler {
    
    self.dataHandler = dataHandler;
    
    // 不放到主线程里面，会导致卡顿！！！
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self setNeedsDisplay];
    });
}


@end
