//
//  YFStock_KLineView.m
//  YFStockDemo
//
//  Created by 李友富 on 2017/3/30.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import "YFStock_KLine.h"
#import "YFStock_ScrollView.h"
#import "YFStock_KLineView.h"
#import "YFStock_KLineBottomView.h"
#import "YFStock_KLineMaskView.h"
#import "YFStock_DataHandler.h"
#import "YFStock_TopBar.h"

#import "YF_Stock_KLineAboveViewTableViewCell.h"
#import "YF_Stock_KLineBelowViewTableViewCell.h"

@interface YFStock_KLine() <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *allKLineModels; // 所有的K线模型
@property (nonatomic, strong) YFStock_DataHandler *dataHandler; // dataHandler
@property (nonatomic, assign) CGFloat currentHeight;
@property (nonatomic, assign) CGFloat lastHeight;

@property (nonatomic, assign) CGFloat aboveMax;
@property (nonatomic, assign) CGFloat aboveMin;
@property (nonatomic, assign) CGFloat belowMax;
@property (nonatomic, assign) CGFloat belowMin;

@property (nonatomic, strong) NSArray <YFStock_KLineModel *> *drawKLineModels;

@property (nonatomic, strong) UITableView *aboveView;
@property (nonatomic, strong) UITableView *belowView;
@property (nonatomic, strong) YFStock_KLineMaskView *maskView; // 长按手势遮罩view（十字线）


@end

@implementation YFStock_KLine

#pragma mark - 初始化
- (YFStock_KLine *)initWithFrame:(CGRect)frame allKLineModels:(NSArray<YFStock_KLineModel *> *)allKLineModels {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = kClearColor;
        
        self.allKLineModels = allKLineModels;
        
        [self config];
        [self createSubviews];
    }
    return self;
}

- (void)config {
    
    self.bottomBarIndex = 0;
    
    self.currentHeight = [YFStock_Variable KLineWidth] + [YFStock_Variable KLineGap];
    self.lastHeight = self.currentHeight;
}

#pragma mark - 布局子视图
- (void)createSubviews {
    
    [self create_aboveView_belowView];
}

- (void)create_aboveView_belowView {
    
    CGFloat aboveViewBelowViewTotalHeight = self.height - kStockTimeViewHeight - kStockBottomBarHeight;
    CGFloat aboveViewHeight = aboveViewBelowViewTotalHeight * (1 - [YFStock_Variable KlineVolumeViewHeightRadio]);
    CGFloat belowViewHeight = aboveViewBelowViewTotalHeight - aboveViewHeight;
    
    self.aboveView = [self createTableViewWithFrame:CGRectMake(0, 0, self.width, aboveViewHeight)];
    self.belowView = [self createTableViewWithFrame:CGRectMake(0, self.height - belowViewHeight, self.width, belowViewHeight)];
    
    [self.aboveView registerClass:[YF_Stock_KLineAboveViewTableViewCell class] forCellReuseIdentifier:@"aboveCell"];
    [self.belowView registerClass:[YF_Stock_KLineBelowViewTableViewCell class] forCellReuseIdentifier:@"belowCell"];
}

- (UITableView *)createTableViewWithFrame:(CGRect)frame {
    
    UITableView *tableView = [UITableView new];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    tableView.transform = CGAffineTransformMakeRotation(M_PI * -0.5);
    tableView.frame = frame;
    
    tableView.backgroundColor = kWhiteColor;
    tableView.allowsSelection = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorColor = kClearColor;
    tableView.showsVerticalScrollIndicator = NO;
//    tableView.decelerationRate = 0.9;
    tableView.clipsToBounds = NO;
    tableView.layer.borderColor = kStockKlinePartLineColor.CGColor;
    tableView.layer.borderWidth = 0.5f;
    
    // 缩放
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(event_pinchAction:)];
    pinch.delegate = self;
    [tableView addGestureRecognizer:pinch];
    
    // 长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(event_longPressAction:)];
    longPress.minimumPressDuration = 0.2f;
    [tableView addGestureRecognizer:longPress];

    return tableView;
}

#pragma mark - 更新数据
- (void)updateData {
    
    if (self.allKLineModels.count == 0) {
        
        return;
    }
    
    NSArray *indexPaths = [self.aboveView indexPathsForVisibleRows];
    if (indexPaths.count == 0) {
        
        [self tableViewReloadData];
        indexPaths = [self.aboveView indexPathsForVisibleRows];
    }
    
    NSIndexPath *firstIndexPath = indexPaths.firstObject;
    NSIndexPath *lastIndexPath = indexPaths.lastObject;
    NSArray *drawKLineModels = [self.allKLineModels subarrayWithRange:NSMakeRange(firstIndexPath.row, lastIndexPath.row - firstIndexPath.row + 1)];
    self.drawKLineModels = drawKLineModels;
    [self.dataHandler handleKLineModelDatasWithDrawKlineModelArray:drawKLineModels pointStartX:0 KLineViewHeight:self.aboveView.height volumeViewHeight:self.belowView.height bottomBarIndex:self.bottomBarIndex];
    
    if (self.aboveMax != self.dataHandler.maxKLineValue || self.aboveMin != self.dataHandler.minKLineValue) {
        
        self.aboveMax = self.dataHandler.maxKLineValue;
        self.aboveMin = self.dataHandler.minKLineValue;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KLineAboveMaxMinValueChanged" object:@[ @(self.aboveMax), @(self.aboveMin) ]];
    }
    
    
    CGFloat belowMax, belowMin;
    
    switch (self.bottomBarIndex) {
        case YFStockBottomBarIndex_MACD:
        {
            belowMax = self.dataHandler.MACDMaxValue;
            belowMin = self.dataHandler.MACDMinValue;
        }
            break;
        case YFStockBottomBarIndex_KDJ:
        {
            belowMax = self.dataHandler.KDJMaxValue;
            belowMin = self.dataHandler.KDJMinValue;
        }
            break;
        case YFStockBottomBarIndex_RSI:
        {
            belowMax = self.dataHandler.RSIMaxValue;
            belowMin = self.dataHandler.RSIMinValue;
        }
            break;
        case YFStockBottomBarIndex_ARBR:
        {
            belowMax = self.dataHandler.ARBRMaxValue;
            belowMin = self.dataHandler.ARBRMinValue;
        }
            break;
        case YFStockBottomBarIndex_OBV:
        {
            belowMax = self.dataHandler.OBVMaxValue;
            belowMin = self.dataHandler.OBVMinValue;
        }
            break;
        case YFStockBottomBarIndex_WR:
        {
            belowMax = self.dataHandler.WRMaxValue;
            belowMin = self.dataHandler.WRMinValue;
        }
            break;
        case YFStockBottomBarIndex_EMV:
        {
            belowMax = self.dataHandler.EMVMaxValue;
            belowMin = self.dataHandler.EMVMinValue;
        }
            break;
        case YFStockBottomBarIndex_DMA:
        {
            belowMax = self.dataHandler.DMAMaxValue;
            belowMin = self.dataHandler.DMAMinValue;
        }
            break;
        case YFStockBottomBarIndex_CCI:
        {
            belowMax = self.dataHandler.CCIMaxValue;
            belowMin = self.dataHandler.CCIMinValue;
        }
            break;
        case YFStockBottomBarIndex_BIAS:
        {
            belowMax = self.dataHandler.BIASMaxValue;
            belowMin = self.dataHandler.BIASMinValue;
        }
            break;
        case YFStockBottomBarIndex_ROC:
        {
            belowMax = self.dataHandler.ROCMaxValue;
            belowMin = self.dataHandler.ROCMinValue;
        }
            break;
        case YFStockBottomBarIndex_MTM:
        {
            belowMax = self.dataHandler.MTMMaxValue;
            belowMin = self.dataHandler.MTMMinValue;
        }
            break;
        case YFStockBottomBarIndex_CR:
        {
            belowMax = self.dataHandler.CRMaxValue;
            belowMin = self.dataHandler.CRMinValue;
        }
            break;
        case YFStockBottomBarIndex_DMI:
        {
            belowMax = self.dataHandler.DMIMaxValue;
            belowMin = self.dataHandler.DMIMinValue;
        }
            break;
        case YFStockBottomBarIndex_VR:
        {
            belowMax = self.dataHandler.VRMaxValue;
            belowMin = self.dataHandler.VRMinValue;
        }
            break;
            
        case YFStockBottomBarIndex_TRXI:
        {
            belowMax = self.dataHandler.TRIXMaxValue;
            belowMin = self.dataHandler.TRIXMinValue;
        }
            break;
        case YFStockBottomBarIndex_PSY:
        {
            belowMax = self.dataHandler.PSYMaxValue;
            belowMin = self.dataHandler.PSYMinValue;
        }
            break;
        case YFStockBottomBarIndex_DPO:
        {
            belowMax = self.dataHandler.DPOMaxValue;
            belowMin = self.dataHandler.DPOMinValue;
        }
            break;
        case YFStockBottomBarIndex_ASI:
        {
            belowMax = self.dataHandler.ASIMaxValue;
            belowMin = self.dataHandler.ASIMinValue;
        }
            break;
            
        default:
        {
            belowMax = 0;
            belowMin = 0;
        }
            break;
    }
    
    if (self.belowMax != belowMax || self.belowMin != belowMin) {
        
        self.belowMax = belowMax;
        self.belowMin = belowMin;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KLineBelowMaxMinValueChanged" object:@[ @(self.belowMax), @(self.belowMin) ]];
    }
}

#pragma mark - Draw相关
- (void)reDrawWithAllKLineModels:(NSArray<YFStock_KLineModel *> *)allKLineModels {
    
    self.allKLineModels = allKLineModels;
    
    [self updateData];
    [self tableViewReloadData];
    
//    [self.aboveView setContentOffset:CGPointMake(0, self.aboveView.contentSize.height - self.aboveView.width)];
//    [self.belowView setContentOffset:CGPointMake(0, self.belowView.contentSize.height - self.belowView.width)];
    [self.aboveView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:allKLineModels.count ? allKLineModels.count - 1 : 0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    [self.belowView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:allKLineModels.count ? allKLineModels.count - 1 : 0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];

}

- (void)refresh {
    
    [self tableViewReloadData];
}

- (void)setHidden:(BOOL)hidden {
    
    [super setHidden:hidden];
    
    if (hidden) {
        
        self.allKLineModels = @[];

        [self tableViewReloadData];
    }
}

- (void)tableViewReloadData {
    
    [self.aboveView reloadData];
    [self.belowView reloadData];
    
}

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allKLineModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.aboveView]) {
        
        YF_Stock_KLineAboveViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aboveCell"];
        
        cell.isFullScreen = [YFStock_Variable isFullScreen];
        cell.topBarSelectedIndex = [YFStock_Variable selectedIndex];
        cell.visibleMax = self.aboveMax;
        cell.visibleMin = self.aboveMin;
        cell.cWidth = self.aboveView.height;
        cell.cHeight = [YFStock_Variable KLineWidth] + [YFStock_Variable KLineGap];
        cell.KLineModel = self.allKLineModels[indexPath.row];
        
        //判断是否有上一个值
        if (indexPath.row > 0) {
            
            YFStock_KLineModel *lastModel = self.allKLineModels[indexPath.row - 1];
            cell.lastKLineModel = lastModel;
        } else {
            
            cell.lastKLineModel = nil;
        }
        //判断是否有下一个
        if (indexPath.row < self.allKLineModels.count - 1) {
            
            YFStock_KLineModel *nextModel = self.allKLineModels[indexPath.row + 1];
            cell.nextKLineModel = nextModel;
        } else {
            
            cell.nextKLineModel = nil;
        }
        
        return cell;

    } else {
        
        YF_Stock_KLineBelowViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"belowCell"];
        
        cell.isFullScreen = [YFStock_Variable isFullScreen];
        cell.topBarSelectedIndex = [YFStock_Variable selectedIndex];
        cell.visibleMax = self.belowMax;
        cell.visibleMin = self.belowMin;
        cell.cWidth = self.belowView.height;
        cell.cHeight = [YFStock_Variable KLineWidth] + [YFStock_Variable KLineGap];

        cell.KLineModel = self.allKLineModels[indexPath.row];
        
        //判断是否有上一个值
        if (indexPath.row > 0) {
            
            YFStock_KLineModel *lastModel = self.allKLineModels[indexPath.row - 1];
            cell.lastKLineModel = lastModel;
        } else {
            
            cell.lastKLineModel = nil;
        }
        //判断是否有下一个
        if (indexPath.row < self.allKLineModels.count - 1) {
            
            YFStock_KLineModel *nextModel = self.allKLineModels[indexPath.row + 1];
            cell.nextKLineModel = nextModel;
        } else {
            
            cell.nextKLineModel = nil;
        }

        // 放在最后
        cell.bottomBarIndex = self.bottomBarIndex;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return ([YFStock_Variable KLineWidth] + [YFStock_Variable KLineGap]);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self updateData];

    if ([scrollView isEqual:self.aboveView]) {
        
        self.belowView.contentOffset = self.aboveView.contentOffset;
    } else {
        
        self.aboveView.contentOffset = self.belowView.contentOffset;
    }
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    
//    if (decelerate) {
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            printf("STOP IT!!\n");
//            [scrollView setContentOffset:scrollView.contentOffset animated:NO];
//        });
//    }
//}

#pragma mark - 手势相关
- (void)event_pinchAction:(UIPinchGestureRecognizer *)gesture {
    
    if (gesture.numberOfTouches == 2 && gesture.state != 0.0f) {
        
        self.aboveView.scrollEnabled = NO;
        
        // 计算捏合中心，根据中心点，确定放大位置
        CGPoint p1 = [gesture locationOfTouch:0 inView:gesture.view];
        CGPoint p2 = [gesture locationOfTouch:1 inView:gesture.view];
        CGPoint newCenter = CGPointMake((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);
        NSIndexPath *indexPath = [self.aboveView indexPathForRowAtPoint:newCenter]; // 获取响应的长按的indexpath(中心位置)
        
        // 添加临时变数
        CGFloat tempHeight = _lastHeight * gesture.scale;
        
        if (_currentHeight == tempHeight || tempHeight < kStockKlineMinWidth + [YFStock_Variable KLineGap] || tempHeight > kStockKlineMaxWidth + [YFStock_Variable KLineGap]) {
            
            
        } else {
            
            // 变化之前
            CGFloat y1 = indexPath.row * _currentHeight;
            CGFloat o1 = self.aboveView.contentOffset.y;
            CGFloat h1 = _currentHeight * 0.5;
            
            // 变化之后
            CGFloat y2 = indexPath.row * tempHeight;
            CGFloat h2 = tempHeight * 0.5;
            
            CGFloat o2 = y2 + h2 - y1 + o1 - h1;
            
            _currentHeight = tempHeight;
            
            [YFStock_Variable setKLineWidth:_currentHeight - [YFStock_Variable KLineGap]];
            
            [self updateData];
            [self tableViewReloadData];
            
            if (o2 < 0) {
                
                o2 = 0;
            }
            if (o2 > self.aboveView.contentSize.height - self.aboveView.width) {
                
                o2 = self.aboveView.contentSize.height - self.aboveView.width;
            }
            self.aboveView.contentOffset = CGPointMake(0, o2);
            self.belowView.contentOffset = self.aboveView.contentOffset;
        }
    }
    
    // 当滑动结束时
    if (gesture.state == 3 || gesture.state == 6) {
        
        _lastHeight = _currentHeight;
        self.aboveView.scrollEnabled = YES;
    }}

- (void)event_longPressAction:(UILongPressGestureRecognizer *)longPress {
    
    CGPoint p = [longPress locationInView:longPress.view];
    
    NSIndexPath *indexPath = [(UITableView *)longPress.view indexPathForRowAtPoint:p]; // 获取响应的长按的indexpath
    
    YFStock_KLineModel *selectedModel = self.allKLineModels[indexPath.row];
    
//    NSLog(@"%@", selectedModel.dataTime);
    
    CGFloat x, y, price;
    x = indexPath.row * self.currentHeight + 0.5 * self.currentHeight;
    x -= self.aboveView.contentOffset.y;
    
    price = selectedModel.closePrice.floatValue;
    
    CGFloat unitValue = (self.aboveMax - self.aboveMin) / self.aboveView.height;
    y = self.aboveView.height - (price - self.aboveMin) / unitValue;
    
    NSLog(@"%f - %f", x, y);
    
    // 显示十字线-重置十字线frame等
    self.maskView.hidden = NO;
    self.maskView.selectedKLineModel = selectedModel;
    [self.maskView resetLineFrameWithPoint:CGPointMake(x, y)];
    
    
    // 结束、取消等状态
    if(longPress.state == UIGestureRecognizerStateEnded || longPress.state == UIGestureRecognizerStateCancelled || longPress.state == UIGestureRecognizerStateFailed) {
        
        self.maskView.hidden = YES;
    }
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

#pragma mark - setter
- (void)setBottomBarIndex:(NSInteger)bottomBarIndex {
    
    if (_bottomBarIndex != bottomBarIndex) {
        
        _bottomBarIndex = bottomBarIndex;
        
//        // belowView刷新重绘线条
        [self updateData];
        [self tableViewReloadData];
    }
}

#pragma mark - lazy loading
- (NSArray *)allKLineModels {
    
    if (_allKLineModels == nil) {
        
        _allKLineModels = [NSArray new];
    }
    return _allKLineModels;
}

- (YFStock_DataHandler *)dataHandler {
    
    if (_dataHandler == nil) {
        
        _dataHandler = [YFStock_DataHandler dataHandler];
    }
    return _dataHandler;
}

- (UIView *)maskView {
    
    if (_maskView == nil) {
        
        _maskView = [[YFStock_KLineMaskView alloc] initWithFrame:self.frame];
        [self addSubview:_maskView];
    }
    return _maskView;
}

@end
