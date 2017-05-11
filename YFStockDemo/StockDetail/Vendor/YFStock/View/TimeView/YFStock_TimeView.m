//
//  YFStock_TimeView.m
//  YFStockDemo
//
//  Created by 李友富 on 2017/3/31.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import "YFStock_TimeView.h"
#import "YFStock_KLineModel.h"

@interface YFStock_TimeView()

@property (nonatomic, strong) NSArray *drawKLineModels;
@end

@implementation YFStock_TimeView

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(ctx, rect);
    
    if (self.drawKLineModels.count > 0) {
        
        NSDictionary *attribute = @{ NSFontAttributeName:kFont_9,NSForegroundColorAttributeName:kCustomRGBColor(103, 103, 103, 1.0) };

        [self.drawKLineModels enumerateObjectsUsingBlock:^(YFStock_KLineModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            if (obj.isShowTime) {
                
                CGRect rect = [obj.showTimeStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil];
                CGFloat x = obj.highPricePositionPoint.x - rect.size.width * 0.5;
                if (x > self.width - rect.size.width) {
                    
                    x = self.width - rect.size.width;
                }
                if (x < 0) {
                    
                    x = 0;
                }
                [obj.showTimeStr drawAtPoint:CGPointMake(x, (self.frame.size.height - rect.size.height) * 0.5f) withAttributes:attribute];
            }
        }];
    }
}

- (void)drawWithDataHandler:(NSArray *)drawKLineModels {
    
    self.drawKLineModels = drawKLineModels;
    
    [self setNeedsDisplay];
    
}




@end
