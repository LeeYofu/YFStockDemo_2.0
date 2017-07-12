//
//  YFStock.h
//  YFStockDemo
//
//  Created by 李友富 on 2017/3/30.
//  Copyright © 2017年 李友富. All rights reserved.
//

// Stock 用来相关数据的获取，以及股票视图的创建，绘制等；[Main]

#import <Foundation/Foundation.h>
#import "YFStock_Header.h"
@class YFStock;

@protocol YFStockDataSource <NSObject>

@required
// 获取该类型最原始数据
- (NSArray *)YFStock:(YFStock *)stock stockDatasOfIndex:(YFStockTopBarIndex)index;
// 获取当前位置下的股票图类型
- (YFStockLineType)YFStock:(YFStock *)stock stockLineTypeOfIndex:(YFStockTopBarIndex)index;
// 获取topBar的标题数组
- (NSArray <NSString *> *)titleItemsOfStock:(YFStock *)stock;
// 股票图类型有切换时调用
- (void)YFStock:(YFStock *)stock didSelectedStockLineTypeAtIndex:(YFStockTopBarIndex)index;

@optional

@end

@interface YFStock : NSObject

@property (nonatomic, strong) UIView *view; // 主视图
@property (nonatomic, strong) UIView *mainView; // 画线的主要视图

// 初始化
+ (YFStock *)stockWithFrame:(CGRect)frame dataSource:(id)dataSource;
// 绘制/重绘
- (void)reDraw;
- (void)refresh;

@end
