//
//  YFStock_TimeLine.m
//  YFStockDemo
//
//  Created by 李友富 on 2017/4/5.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import "YFStock_TimeLine.h"
#import "YFStock_Header.h"
#import "YFStock_ScrollView.h"
#import "YFStock_TimeLineView.h"
#import "YFStock_DataHandler.h"
#import "YFStock_TimeLineMaskView.h"

@interface YFStock_TimeLine()

@property (nonatomic, strong) NSArray *allTimeLineModels;
@property (nonatomic, strong) YFStock_DataHandler *dataHandler;

@property (nonatomic, strong) YFStock_ScrollView *scrollView;
@property (nonatomic, strong) YFStock_TimeLineView *timeLineView;
@property (nonatomic, strong) YFStock_TimeLineMaskView *maskView;

@end

@implementation YFStock_TimeLine

- (YFStock_TimeLine *)initWithFrame:(CGRect)frame timeLineModels:(NSArray<YFStock_TimeLineModel *> *)timeLineModels {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = kClearColor;
        
        self.allTimeLineModels = timeLineModels;
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    [self createScrollView];
    [self createTimeLineView];
}

- (void)createScrollView {
    
    // scrollView 跟 self视图 是有上线左右 间距 的
    self.scrollView = [[YFStock_ScrollView alloc] initWithFrame:CGRectMake(kStockKLineScrollViewLeftGap, kStockKLineScrollViewTopGap, self.width - kStockKLineScrollViewLeftGap - kStockKLineScrollViewRightGap, self.height - kStockKLineScrollViewTopGap - kStockKLineScrollViewBottomGap)];
    self.scrollView.stockLineType = YFStockLineTypeTimeLine;
    self.scrollView.scrollEnabled = NO;
    [self addSubview:self.scrollView];
    
    // 长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(event_longPressAction:)];
    longPress.minimumPressDuration = 0.3f;
    [self.scrollView addGestureRecognizer:longPress];
}

- (void)createTimeLineView {
    
    self.timeLineView = [[YFStock_TimeLineView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, 240)];
    self.timeLineView.backgroundColor = kClearColor;
    [self.scrollView addSubview:self.timeLineView];
}

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    // security
    if (self.allTimeLineModels.count > 0) {
        
        [self updateDrawTimeLineModels];
        
        if (! _maskView || _maskView.hidden == YES) { // 不是长按等状态
            
            // 更新背景线
            [self.scrollView drawWithDataHandler:self.dataHandler KLineViewHeight:0 bottomViewY:0];
            
            [self.timeLineView drawWithDataHandler:self.dataHandler];
        }
        
//        // 绘制左边的数值
//        [self drawLeftDesc];
//        
//        // 绘制时间
//        [self.timeView drawWithDataHandler:self.dataHandler];
    }
}

- (void)reDrawWithKLineModels:(NSArray<YFStock_TimeLineModel *> *)timeLineModels {
    
    self.allTimeLineModels = timeLineModels;
    
    [self layoutIfNeeded];
    
//    [self updateScrollViewContentWidth];
    
    [self setNeedsDisplay];
}

//#pragma mark - 更新contentSize
//- (CGFloat)updateScrollViewContentWidth {
//    
//    // 根据stockModels的个数和间隔和K线的宽度计算出self的宽度，并设置contentsize
//    CGFloat kLineViewWidth = self.allTimeLineModels.count * [YFStock_Variable KLineWidth] + (self.allTimeLineModels.count - 1) * [YFStock_Variable KLineGap];
//    
//    if(kLineViewWidth < self.scrollView.width) {
//        
//        kLineViewWidth = self.scrollView.width;
//    }
//    
//    // 更新scrollview的contentsize
//    self.scrollView.contentSize = CGSizeMake(kLineViewWidth, self.scrollView.contentSize.height);
//    
//    return kLineViewWidth;
//}

- (void)updateDrawTimeLineModels {
    
    //
    [self calculateTimeLinePadding];
    
    [self.dataHandler handleTimeLineModelDatasWithDrawTimeLineModelArray:self.allTimeLineModels timeLineViewHeight:self.timeLineView.height];
}

- (void)calculateTimeLinePadding {
    
    NSInteger totalMinutes = [[YFStock_DataHandler dataHandler] timeLineTradingMinutesWithStockType:@"SH0001"];
    CGFloat timeLineWidth = self.timeLineView.width / (totalMinutes + 1);
    
    [YFStock_Variable setTimeLineWidth:timeLineWidth - [YFStock_Variable timeLineGap]];
}

- (void)event_longPressAction:(UILongPressGestureRecognizer *)longPress {
    
    __block YFStock_TimeLineModel *selectedTimeLineModel;
    
    // 开始+数值改变状态
    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state) {
        
        // 获取location
        CGPoint location = [longPress locationInView:self.scrollView];
        
        // security
        if (location.x < 0 || location.x > self.scrollView.width) return;
        
        [self.dataHandler.drawTimeLineModels enumerateObjectsUsingBlock:^(YFStock_TimeLineModel *timeLineModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGPoint pricePoint = timeLineModel.pricePositionPoint;
            CGFloat pricePointX = pricePoint.x;
            CGFloat touchPointX = location.x;
            int priceIntX = (int)pricePointX;
            int touchIntX = (int)touchPointX;
            
            if (touchIntX == priceIntX || ABS(touchPointX - pricePointX) <= ([YFStock_Variable timeLineWidth] + [YFStock_Variable timeLineGap]) * 0.5f) {
                
                selectedTimeLineModel = timeLineModel;
                
                // 显示十字线-重置十字线frame等
                self.maskView.hidden = NO;
                self.maskView.selectedTimeLineModel = timeLineModel;
                self.maskView.scrollView = self.scrollView;
                [self.maskView resetLineFrame];
            }
        }];
    }
    
    // 结束、取消等状态
    if(longPress.state == UIGestureRecognizerStateEnded || longPress.state == UIGestureRecognizerStateCancelled || longPress.state == UIGestureRecognizerStateFailed) {
        
        // 隐藏十字线
        self.maskView.hidden = YES;
        
//        selectedKLineModel = nil;
    }
    
    
    // 将选中的model传给stock，用于topbarmaskview的数据展示
//    if (self.delegate && [self.delegate respondsToSelector:@selector(YFStockKLine:didSelectedKLineModel:)]) {
//        
//        [self.delegate YFStockKLine:self didSelectedKLineModel:selectedKLineModel];
//    }

}

- (YFStock_DataHandler *)dataHandler {
    
    if (_dataHandler == nil) {
        
        _dataHandler = [YFStock_DataHandler dataHandler];
    }
    return _dataHandler;
}

- (UIView *)maskView {
    
    if (_maskView == nil) {
        
        _maskView = [[YFStock_TimeLineMaskView alloc] initWithFrame:self.scrollView.frame];
        [self addSubview:_maskView];
    }
    return _maskView;
}


@end
