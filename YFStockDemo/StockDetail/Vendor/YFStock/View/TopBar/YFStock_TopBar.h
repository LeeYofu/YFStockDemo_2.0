//
//  YFStock_TopBar.h
//  YFStockDemo
//
//  Created by 李友富 on 2017/3/31.
//  Copyright © 2017年 李友富. All rights reserved.
//

/** 股票图类型筛选条 */

#import <UIKit/UIKit.h>
#import "YFStock_Header.h"
@class YFStock_TopBar;

@protocol YFStock_TopBarDelegate <NSObject>

@optional

// 选中某个类型 的 下标
- (void)YFStock_TopBar:(YFStock_TopBar *)topBar didSelectedItemAtIndex:(NSInteger)index;

@end

@interface YFStock_TopBar : UIView

// delegate
@property (nonatomic, weak) id<YFStock_TopBarDelegate> delegate;

// 初始化，传入标题数组
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *> *)titles topBarSelectedIndex:(YFStockTopBarIndex)topBarSelectedIndex;

@end
