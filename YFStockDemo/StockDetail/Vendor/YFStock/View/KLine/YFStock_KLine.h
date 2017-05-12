//
//  YFStock_KLineView.h
//  YFStockDemo
//
//  Created by 李友富 on 2017/3/30.
//  Copyright © 2017年 李友富. All rights reserved.
//

// K线视图 和 成交量视图 的结合体（并不是真正的、单一的K线视图）

#import <UIKit/UIKit.h>
#import "YFStock_KLineModel.h"
#import "YFStock_Header.h"
@class YFStock_KLine;

@protocol YFStock_KLineDelegate <NSObject>

@optional

// 长按状态下选中了哪个模型
- (void)YFStockKLine:(YFStock_KLine *)KLine didSelectedKLineModel:(YFStock_KLineModel *)KLineModel;

@end

@interface YFStock_KLine : UIView

@property (nonatomic, assign) NSInteger bottomBarIndex;
@property (nonatomic, weak) id <YFStock_KLineDelegate> delegate;

// 初始化，传入 所有的 K线模型
- (YFStock_KLine *)initWithFrame:(CGRect)frame allKLineModels:(NSArray <YFStock_KLineModel *> *)allKLineModels;
// 重绘/绘制，传入 所有的 K线模型
- (void)reDrawWithAllKLineModels:(NSArray <YFStock_KLineModel *> *)allKLineModels;
- (void)refresh;

@end
