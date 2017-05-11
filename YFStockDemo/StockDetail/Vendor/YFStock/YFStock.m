
//  YFStock.m
//  YFStockDemo
//
//  Created by 李友富 on 2017/3/30.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import "YFStock.h"
#import "YFStock_TopBar.h"
#import "YFStock_TopBarMaskView.h"
#import "YFStock_KLine.h"
#import "YFStock_TimeLine.h"
#import "YFStock_KLineModel.h"
#import "YFStock_DataHandler.h"

@interface YFStock() <YFStock_TopBarDelegate, YFStock_KLineDelegate>

@property (nonatomic, weak) id<YFStockDataSource> dataSource;
@property (nonatomic, strong) NSMutableArray <__kindof UIView *> *stockLineViews; // 盛放所有股票视图
@property (nonatomic, assign) NSInteger bottomBarIndex;

@property (nonatomic, strong) YFStock_TopBar *topBar; // 顶部分类条
@property (nonatomic, strong) YFStock_TopBar *bottomBar; // bottomBar
@property (nonatomic, strong) YFStock_TopBarMaskView *topBarMaskView; // top bar mask view

@end

@implementation YFStock

#pragma mark - 初始化
+ (YFStock *)stockWithFrame:(CGRect)frame dataSource:(id)dataSource {
    
    YFStock *stock = [YFStock new];
    
    stock.view = [[UIView alloc] initWithFrame:frame];
    stock.view.backgroundColor = kStockThemeColor;
    
    stock.dataSource = dataSource;
    
    stock.bottomBarIndex = 0;
    
    [stock createSubviews];
   
    // 根据当前index请求对应的数据
    [stock.dataSource YFStock:stock didSelectedStockLineTypeAtIndex:[YFStock_Variable selectedIndex]];
    
    return stock;
}

#pragma mark - 创建子视图
- (void)createSubviews {
    
    [self createTopBarView];
    [self createMainView];
    [self createBottomBarView];
}

- (void)createTopBarView {
    
    self.topBar = [[YFStock_TopBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kStockTopBarHeight) titles:[self.dataSource titleItemsOfStock:self] topBarSelectedIndex:[YFStock_Variable selectedIndex]];
    self.topBar.delegate = self;
    [self.view addSubview:self.topBar];
}

- (void)createBottomBarView {
    
    CGFloat aboveViewBelowViewTotalHeight = self.mainView.height - kStockTimeViewHeight - kStockBottomBarHeight;
    CGFloat aboveViewHeight = aboveViewBelowViewTotalHeight * (1 - [YFStock_Variable KlineVolumeViewHeightRadio]);
    CGFloat belowViewHeight = aboveViewBelowViewTotalHeight - aboveViewHeight;
    
    self.bottomBar = [[YFStock_TopBar alloc] initWithFrame:CGRectMake(0, self.mainView.height - kStockBottomBarHeight - belowViewHeight + self.topBar.maxY, self.view.width, kStockBottomBarHeight) titles:@[ @"MACD", @"KDJ", @"RSI", @"ARBR", @"OBV", @"WR", @"EMV", @"DMA", @"CCI", @"BIAS", @"ROC", @"MTM", @"CR", @"DMI", @"VR", @"TRIX", @"PSY", @"DPO", @"ASI", @"SAR" ] topBarSelectedIndex:0];
    self.bottomBar.delegate = self;
    [self.view addSubview:self.bottomBar];
    
    self.bottomBar.hidden = [YFStock_Variable selectedIndex] == 0;
}

- (void)createMainView {
    
    self.mainView = [UIView new];
    CGFloat mainViewY = kStockTopBarHeight + kStockMainViewTopGap;
    self.mainView.frame = CGRectMake(0, mainViewY, self.view.width, self.view.height - mainViewY);
    [self.view addSubview:self.mainView];
    
    [self.stockLineViews removeAllObjects];
    
    // 根据topBar标题数组元素个数创建对应股票视图
    for (int i = 0; i < [[self.dataSource titleItemsOfStock:self] count]; i ++) {
        
        UIView *stockLineView;
        
        if ([self.dataSource YFStock:self stockLineTypeOfIndex:i] == YFStockLineTypeTimeLine) { // 如果是 time line 类型
            
            NSArray *timeLineModels = [self handleOriginDataSourceWithIndex:i];
            stockLineView = [[YFStock_TimeLine alloc] initWithFrame:self.mainView.bounds timeLineModels:timeLineModels];
        } else { // 如果是 K线类型
            
            NSArray *allKLineModels = [self handleOriginDataSourceWithIndex:i];
            stockLineView = [[YFStock_KLine alloc] initWithFrame:self.mainView.bounds allKLineModels:allKLineModels];
            ((YFStock_KLine *)stockLineView).delegate = self;
        }
        
        // 不是第一个就要隐藏掉
        stockLineView.hidden = i != [YFStock_Variable selectedIndex];
        
        [self.mainView addSubview:stockLineView];
        
        // 将创建的所有类型视图添加到股票视图数组里
        [self.stockLineViews addObject:stockLineView];
    }
}

#pragma mark - （重新）绘制
- (void)reDraw {
    
    // 获取到当前选中的类型
    NSInteger index = [YFStock_Variable selectedIndex];
    
    self.stockLineViews[index].hidden = NO;
    
    // 根据当前选中类型，获取对应的原始数据，然后处理原始数据，然后根据index找到对应的股票视图重新绘制
    // TimeLine
    if ([self.dataSource YFStock:self stockLineTypeOfIndex:index] == YFStockLineTypeTimeLine) {
        
        YFStock_TimeLine *timeLineView = self.stockLineViews[index];
#warning isnot klinemodels
        [timeLineView reDrawWithKLineModels:[self handleOriginDataSourceWithIndex:index]];
    } else { // KLine
        
        YFStock_KLine *stockLineView = self.stockLineViews[index];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{

            NSArray *array = [self handleOriginDataSourceWithIndex:index];

            dispatch_async(dispatch_get_main_queue(), ^{

                [stockLineView reDrawWithAllKLineModels:array];
            });
        });
        
//        [stockLineView reDrawWithAllKLineModels:[self handleOriginDataSourceWithIndex:index]];
    }
}

- (void)refresh {
    
    NSInteger index = [YFStock_Variable selectedIndex];
    
    self.stockLineViews[index].hidden = NO;
    if ([self.dataSource YFStock:self stockLineTypeOfIndex:index] == YFStockLineTypeTimeLine) {
        
        YFStock_TimeLine *timeLineView = self.stockLineViews[index];
    } else { // KLine
        
        YFStock_KLine *stockLineView = self.stockLineViews[index];
        [stockLineView refresh];
    }
}

#pragma mark - 处理原始数据
- (NSArray *)handleOriginDataSourceWithIndex:(NSInteger)index {
    
    // 重新从外界拿 最新的数据
    // 这里数组需要倒序排序，因为网络请求返回的数据是按照时间由近及远排序的，但是画图是按照由时间由远及近绘制的，使用中需要根据实际情况作出新相应的改变；【KLine倒序，timeLines不用】
    NSArray *originDatas;
    
    // 原始数据转换为模型数据/数组
    if ([self.dataSource YFStock:self stockLineTypeOfIndex:index] == YFStockLineTypeTimeLine) {
                
        originDatas = [self.dataSource YFStock:self stockDatasOfIndex:index]; // 无逆序
        // 原始数据转模型
        return [[YFStock_DataHandler dataHandler] handleAllTimeLineOriginDataArray:originDatas topBarIndex:[YFStock_Variable selectedIndex]];
    } else {
        
        originDatas = [[[self.dataSource YFStock:self stockDatasOfIndex:index] reverseObjectEnumerator] allObjects]; // 逆序
//        originDatas = [self.dataSource YFStock:self stockDatasOfIndex:index];
        // 原始数据转模型
        return [[YFStock_DataHandler dataHandler] handleAllKLineOriginDataArray:originDatas topBarIndex:[YFStock_Variable selectedIndex]];
    }
}

#pragma mark - 代理方法
- (void)YFStock_TopBar:(YFStock_TopBar *)topBar didSelectedItemAtIndex:(NSInteger)index {
    
    if ([topBar isEqual:self.topBar]) {
        
        // 重复点击同样的index，直接返回，不执行操作
        if ([YFStock_Variable selectedIndex] == index) {
            
            return;
        }
        
        // 当前视图隐藏
        self.stockLineViews[[YFStock_Variable selectedIndex]].hidden = YES;
        
        // 新的视图在调用draw的时候再显示即可 self.stockLineViews[index].hidden = NO;
        
        // update currentIndex
        [YFStock_Variable setSelectedIndex:index];
        // 让linewidth变为初始默认宽度
        [YFStock_Variable setKLineWidth:[YFStock_Variable defaultKLineWidth]];
        
        // 这里通知外界重新开始请求最新的数据，请求完毕后外界调用draw方法，开始重绘
        [self.dataSource YFStock:self didSelectedStockLineTypeAtIndex:index];
        
        self.stockLineViews[index].hidden = NO;
        if ([self.stockLineViews[index] isKindOfClass:[YFStock_KLine class]]) {
            
            YFStock_KLine *KLine = self.stockLineViews[index];
            KLine.bottomBarIndex = self.bottomBarIndex;
        }
        
        self.bottomBar.hidden = [YFStock_Variable selectedIndex] == 0;
        

    } else { // bottom bar
                
        // YFStock_KLine 的下面的belowView根据index类型重新绘制
        YFStock_KLine *KLine = self.stockLineViews[[YFStock_Variable selectedIndex]];
        KLine.bottomBarIndex = index;
        self.bottomBarIndex = index;
    }
    

}

- (void)YFStockKLine:(YFStock_KLine *)KLine didSelectedKLineModel:(YFStock_KLineModel *)KLineModel {
    
    if (KLineModel) {
        
        self.topBarMaskView.hidden = NO;
        [self.topBarMaskView setStockLineType:YFStockLineTypeKLine selectedStockLineModel:KLineModel];
    } else {
        
        self.topBarMaskView.hidden = YES;
    }
}

#pragma mark - lazy loading
- (NSMutableArray *)stockLineViews {
    
    if (_stockLineViews == nil) {
        
        _stockLineViews = [NSMutableArray new];
    }
    return _stockLineViews;
}

- (YFStock_TopBarMaskView *)topBarMaskView {
    
    if (_topBarMaskView == nil) {
        
        _topBarMaskView = [[YFStock_TopBarMaskView alloc] initWithFrame:self.topBar.bounds];
        [self.topBar addSubview:_topBarMaskView];
    }
    return _topBarMaskView;
}


@end
