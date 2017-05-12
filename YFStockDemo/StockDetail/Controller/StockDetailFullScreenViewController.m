//
//  StockDetailFullScreenViewController.m
//  GoldfishSpot
//
//  Created by 李友富 on 2017/4/19.
//  Copyright © 2017年 中泰荣科. All rights reserved.
//

#import "StockDetailFullScreenViewController.h"
#import "YFStock.h"
#import "YFNetworkRequest.h"

#define kTimeLineUrl @"https://goldfishspot.qdztrk.com/goldfishfinance/quotation/quotationAllPrices?quotation=SH0001"
#define kDayKlineUrl @"https://goldfishspot.qdztrk.com/goldfishfinance/quotation/echartData?bCode=SH0001&dType=DAY&count=500&quota=MA"
#define kWeekKlineUrl @"https://goldfishspot.qdztrk.com/goldfishfinance/quotation/echartData?bCode=SH0001&dType=WEEK&count=500&quota=MA"
#define kMonthKlineUrl @"https://goldfishspot.qdztrk.com/goldfishfinance/quotation/echartData?bCode=SH0001&dType=MONTH&count=500&quota=MA"

@interface StockDetailFullScreenViewController ()

@property (nonatomic, strong) NSMutableArray *timeLineDatas;
@property (nonatomic, strong) NSMutableArray *dayDatas;
@property (nonatomic, strong) NSMutableArray *weekDatas;
@property (nonatomic, strong) NSMutableArray *monthDatas;

@property (nonatomic, strong) YFStock *stock;

@property (nonatomic, strong) NSURLSessionDataTask *lastTask;

@end

@implementation StockDetailFullScreenViewController


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self createSubviews];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self config];
}

- (void)config {
    
    self.view.backgroundColor = kWhiteColor;
    
    [YFStock_Variable setIsFullScreen:YES];
}

- (void)createSubviews {
    
    // top view
    UIView *topBgView = [UIView new];
    topBgView.frame = CGRectMake(0, 0, kScreenWidth, 64);
    topBgView.backgroundColor = kCustomRGBColor(26, 181, 70, 1.0f);
    [self.view addSubview:topBgView];
    
    self.stock = [YFStock stockWithFrame:CGRectMake(0, topBgView.maxY, kScreenWidth, self.view.height - topBgView.height) dataSource:self];
    [self.view addSubview:self.stock.view];
    
    UIButton *fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fullScreenButton.frame = CGRectMake(self.view.width - topBgView.height, 0, topBgView.height, topBgView.height);
    fullScreenButton.backgroundColor = kBlueColor;
    [fullScreenButton addTarget:self action:@selector(exitFullScreen) forControlEvents:UIControlEventTouchUpInside];
    [topBgView addSubview:fullScreenButton];
}

- (void)exitFullScreen {
    
    [YFStock_Variable setIsFullScreen:NO];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(stockDetailFullScreenViewControllerExitButtonDidClicked)]) {
        
        [self.delegate stockDetailFullScreenViewControllerExitButtonDidClicked];
    }
}

#pragma mark - 网络请求
- (void)requestTimeLine {
    
    self.lastTask = [YFNetworkRequest getWithSubUrl:kTimeLineUrl parameters:nil sucess:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *resultBeanArray = responseObject[@"resultBean"];
        self.timeLineDatas = (NSMutableArray *)resultBeanArray;
        
        [self.stock reDraw];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"error = %@", error);
    }];
}

- (void)requestDayK {
    
    self.lastTask = [YFNetworkRequest getWithSubUrl:kDayKlineUrl parameters:nil sucess:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"success");

        NSArray *resultBeanArray = responseObject[@"resultBean"];
        self.dayDatas = (NSMutableArray *)resultBeanArray;
        
        [self.stock reDraw];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"error = %@", error);
    }];
}

- (void)requestWeekK {
    
    self.lastTask = [YFNetworkRequest getWithSubUrl:kWeekKlineUrl parameters:nil sucess:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *resultBeanArray = responseObject[@"resultBean"];
        self.weekDatas = (NSMutableArray *)resultBeanArray;
        
        [self.stock reDraw];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"error = %@", error);
    }];
}

- (void)requestMonthK {
    
    self.lastTask = [YFNetworkRequest getWithSubUrl:kMonthKlineUrl parameters:nil sucess:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *resultBeanArray = responseObject[@"resultBean"];
        self.monthDatas = (NSMutableArray *)resultBeanArray;
        
        [self.stock reDraw];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - dataSource
- (void)YFStock:(YFStock *)stock didSelectedStockLineTypeAtIndex:(YFStockTopBarIndex)index {
    
    [self.lastTask cancel];
    
    if (index == YFStockTopBarIndex_MinuteHour) { // 分时
        
        [self requestTimeLine];
    } else if (index == YFStockTopBarIndex_DayK) { // day
        
        [self requestDayK];
    } else if (index == YFStockTopBarIndex_WeekK) { // week
        
        [self requestWeekK];
    } else if (index == YFStockTopBarIndex_MonthK) { // month
        
        [self requestMonthK];
    } else { // other
        
    }
}

- (NSArray *)YFStock:(YFStock *)stock stockDatasOfIndex:(YFStockTopBarIndex)index {
    
    if (index == YFStockTopBarIndex_MinuteHour) { // 分时
        
        return self.timeLineDatas;
    } else if (index == YFStockTopBarIndex_DayK) { // day
        
        return [[[[self.dayDatas arrayByAddingObjectsFromArray:self.dayDatas] arrayByAddingObjectsFromArray:self.dayDatas] arrayByAddingObjectsFromArray:self.dayDatas] arrayByAddingObjectsFromArray:self.dayDatas];
    } else if (index == YFStockTopBarIndex_WeekK) { // week
        
        return [[[[self.weekDatas arrayByAddingObjectsFromArray:self.weekDatas] arrayByAddingObjectsFromArray:self.weekDatas] arrayByAddingObjectsFromArray:self.weekDatas] arrayByAddingObjectsFromArray:self.weekDatas];
    } else if (index == YFStockTopBarIndex_MonthK) { // month
        
        return [[[[self.monthDatas arrayByAddingObjectsFromArray:self.monthDatas] arrayByAddingObjectsFromArray:self.monthDatas] arrayByAddingObjectsFromArray:self.monthDatas] arrayByAddingObjectsFromArray:self.monthDatas];
    } else { // other
        
        return @[];
    }
};

- (YFStockLineType)YFStock:(YFStock *)stock stockLineTypeOfIndex:(YFStockTopBarIndex)index {
    
    if (index == YFStockTopBarIndex_MinuteHour) {
        
        return YFStockLineTypeTimeLine;
    }
    return YFStockLineTypeKLine;
}

- (NSArray<NSString *> *)titleItemsOfStock:(YFStock *)stock {
    
    return @[ @"分时", @"日K", @"周K", @"月K", @"5分", @"30分", @"60分", @"年K" ];
}

#pragma mark - lazy loading
- (NSMutableArray *)timeLineDatas {
    
    if (_timeLineDatas == nil) {
        
        _timeLineDatas = [NSMutableArray new];
    }
    return _timeLineDatas;
}

- (NSMutableArray *)dayDatas {
    
    if (_dayDatas == nil) {
        
        _dayDatas = [NSMutableArray new];
    }
    return _dayDatas;
}

- (NSMutableArray *)weekDatas {
    
    if (_weekDatas == nil) {
        
        _weekDatas = [NSMutableArray new];
    }
    return _weekDatas;
}

- (NSMutableArray *)monthDatas {
    
    if (_monthDatas == nil) {
        
        _monthDatas = [NSMutableArray new];
    }
    return _monthDatas;
}


@end
