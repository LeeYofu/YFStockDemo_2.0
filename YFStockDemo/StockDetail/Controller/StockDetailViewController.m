//
//  StockDetailViewController.m
//  GoldfishSpot
//
//  Created by 李友富 on 2017/4/18.
//  Copyright © 2017年 中泰荣科. All rights reserved.
//

#import "StockDetailViewController.h"
#import "YFStock.h"
#import "YFNetworkRequest.h"
#import "StockDetailFullScreenViewController.h"
#import "StockDetailFullScreenView.h"
#import "AFNetworking.h"

#define kTimeLineUrl @"https://goldfishspot.qdztrk.com/goldfishfinance/quotation/quotationAllPrices?quotation=SH0001"
#define kDayKlineUrl @"https://goldfishspot.qdztrk.com/goldfishfinance/quotation/echartData?bCode=SH0001&dType=DAY&count=500&quota=MA"
#define kWeekKlineUrl @"https://goldfishspot.qdztrk.com/goldfishfinance/quotation/echartData?bCode=SH0001&dType=WEEK&count=150&quota=MA"
#define kMonthKlineUrl @"https://goldfishspot.qdztrk.com/goldfishfinance/quotation/echartData?bCode=SH0001&dType=MONTH&count=500&quota=MA"
#define kYearKLineUrl @"https://goldfishspot.qdztrk.com/goldfishfinance/quotation/echartData?bCode=SH0001&dType=YEAR&count=500&quota=MA"

@interface StockDetailViewController () <YFStockDataSource, StockDetailFullScreenViewControllerDelegate, StockDetailFullScreenViewDelegate>

@property (nonatomic, strong) NSMutableArray *timeLineDatas;
@property (nonatomic, strong) NSMutableArray *dayDatas;
@property (nonatomic, strong) NSMutableArray *weekDatas;
@property (nonatomic, strong) NSMutableArray *monthDatas;
@property (nonatomic, strong) NSMutableArray *yearDatas;
@property (nonatomic, assign) BOOL canAutoRotate;

@property (nonatomic, strong) YFStock *stock;
@property (nonatomic, strong) StockDetailFullScreenViewController *fullScreenVC;
@property (nonatomic, strong) UIView *fullScreenView;
@property (nonatomic, strong) StockDetailFullScreenView *stockDetailFullScreenView;

@property (nonatomic, strong) NSURLSessionDataTask *lastTask;

@end

@implementation StockDetailViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self config];
    
    [self createSubviews];
}

- (void)config {
    
    self.view.backgroundColor = kWhiteColor;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [YFStock_Variable setSelectedIndex:0];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    self.canAutoRotate = NO;
}

- (void)createSubviews {
    
    // top view
    UIView *topBgView = [UIView new];
    topBgView.frame = CGRectMake(0, 0, kScreenWidth, 156);
    topBgView.backgroundColor = kCustomRGBColor(26, 181, 70, 1.0f);
    [self.view addSubview:topBgView];
    
    self.stock = [YFStock stockWithFrame:CGRectMake(0, topBgView.maxY, kScreenWidth, self.view.height - 45 - topBgView.height - 100) dataSource:self];
    [self.view addSubview:self.stock.view];
    
    UIButton *fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fullScreenButton.frame = CGRectMake(self.view.width - 45, self.stock.view.maxY, 45, kScreenHeight - self.stock.view.maxY);
    fullScreenButton.backgroundColor = kBlueColor;
    [fullScreenButton addTarget:self action:@selector(enterFullScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fullScreenButton];
    
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

- (void)requestYearK {
    
    self.lastTask = [YFNetworkRequest getWithSubUrl:kYearKLineUrl parameters:nil sucess:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *resultBeanArray = responseObject[@"resultBean"];
        self.yearDatas = (NSMutableArray *)resultBeanArray;
        
        [self.stock reDraw];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - dataSource
- (void)YFStock:(YFStock *)stock didSelectedStockLineTypeAtIndex:(YFStockTopBarIndex)index {
    
    //    [[AFHTTPSessionManager manager].operationQueue cancelAllOperations];
    [self.lastTask cancel];
    
    if (index == YFStockTopBarIndex_MinuteHour) { // 分时
        
        [self requestTimeLine];
    } else if (index == YFStockTopBarIndex_DayK) { // day
        
        [self requestDayK];
    } else if (index == YFStockTopBarIndex_WeekK) { // week
        
        [self requestWeekK];
    } else if (index == YFStockTopBarIndex_MonthK) { // month
        
        [self requestMonthK];
    }
    else if (index == YFStockTopBarIndex_YearK) { // year
        
        [self requestYearK];
    } else { // other
        
    }
}

- (NSArray *)YFStock:(YFStock *)stock stockDatasOfIndex:(YFStockTopBarIndex)index {
    
    if (index == YFStockTopBarIndex_MinuteHour) { // 分时
        
        return self.timeLineDatas;
    } else if (index == YFStockTopBarIndex_DayK) { // day
        
        return [[self.dayDatas arrayByAddingObjectsFromArray:self.dayDatas] arrayByAddingObjectsFromArray:self.dayDatas];
    } else if (index == YFStockTopBarIndex_WeekK) { // week
        
        return self.weekDatas;
    } else if (index == YFStockTopBarIndex_MonthK) { // month
        
        return self.monthDatas;
    }
    else if (index == YFStockTopBarIndex_YearK) { // year
        
        return self.yearDatas;
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

#pragma mark - 全屏/竖屏相关
- (void)enterFullScreen {
    
    [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
    //    [self addFullScreenView];
}

- (void)exitFullScreen {
    
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
    //    [self removeFullScreenView];
}

- (BOOL)shouldAutorotate {
    
    return self.canAutoRotate;
    //    return YES;
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    
    self.canAutoRotate = YES;
    
    NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
    NSNumber *orientationTarget = [NSNumber numberWithInt:orientation];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    
    self.canAutoRotate = NO;
}

- (void)deviceOrientationDidChange {
    
    if (self.canAutoRotate == NO) {
        
        return;
    }
    NSLog(@"NAV deviceOrientationDidChange:%ld",(long)[UIDevice currentDevice].orientation);
    
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) { // portrait
        
        [self removeFullScreenView];
//        [self.stock refresh]; // refresh
//        [YFStock_Variable setIsFullScreen:NO];
    } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft ||
               [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) { // left/right
        
        [self addFullScreenView];
//        [self.stock refresh]; // refresh
//        [YFStock_Variable setIsFullScreen:YES];
    }
}

- (void)addFullScreenView {
    
    if (self.fullScreenView == nil) {
        
        StockDetailFullScreenViewController *fullScreenVC = [StockDetailFullScreenViewController new];
        fullScreenVC.delegate = self;
        self.fullScreenVC = fullScreenVC;
        self.fullScreenView = fullScreenVC.view;
        [self.view addSubview:self.fullScreenView];
    }
    
    //    self.stockDetailFullScreenView = [StockDetailFullScreenView new];
    //    self.stockDetailFullScreenView.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    //    self.stockDetailFullScreenView.delegate = self;
    //    [self.view addSubview:self.stockDetailFullScreenView];
    //
    //    self.stockDetailFullScreenView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    //
    //    [self.stockDetailFullScreenView createSubviews];
}

- (void)removeFullScreenView {
    
    if (self.fullScreenView) {
        
        [self.fullScreenView removeFromSuperview];
        self.fullScreenView = nil;
        self.fullScreenVC = nil;
    }
    
    //    [self.stockDetailFullScreenView removeFromSuperview];
    //    self.stockDetailFullScreenView = nil;
}

- (void)stockDetailFullScreenViewControllerExitButtonDidClicked {
    
    [self exitFullScreen];
}

- (void)stockDetailFullScreenViewExitButtonDidClicked {
    
    [self exitFullScreen];
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

- (NSMutableArray *)yearDatas {
    
    if (_yearDatas == nil) {
        
        _yearDatas = [NSMutableArray new];
    }
    return _yearDatas;
}


@end
