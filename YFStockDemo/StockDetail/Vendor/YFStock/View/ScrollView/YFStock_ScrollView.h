//
//  YFStock_ScrollView.h
//  YFStockDemo
//
//  Created by 李友富 on 2017/3/30.
//  Copyright © 2017年 李友富. All rights reserved.
//

// time line 和 k line 滚动的scrollView 主要用来绘制 分割线

#import <UIKit/UIKit.h>
#import "YFStock_Header.h"
#import "YFStock_DataHandler.h"

@interface YFStock_ScrollView : UIScrollView

@property (nonatomic, assign) YFStockLineType stockLineType; // 股票线类型

- (void)drawWithDataHandler:(YFStock_DataHandler *)dataHandler KLineViewHeight:(CGFloat)KLineViewHeight bottomViewY:(CGFloat)bottomViewY;

@end
