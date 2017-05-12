//
//  YF_Stock_KLineAboveViewTableViewCell.h
//  YFStockDemo
//
//  Created by 李友富 on 2017/5/8.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFStock_Header.h"
#import "YFStock_KLineModel.h"

@interface YF_Stock_KLineAboveViewTableViewCell : UITableViewCell

@property (nonatomic, assign) CGFloat visibleMax;
@property (nonatomic, assign) CGFloat visibleMin;
@property (nonatomic, assign) CGFloat cWidth;
@property (nonatomic, assign) CGFloat cHeight;
@property (nonatomic, strong) YFStock_KLineModel *KLineModel;
@property (nonatomic, strong) YFStock_KLineModel *lastKLineModel;
@property (nonatomic, strong) YFStock_KLineModel *nextKLineModel;
@property (nonatomic, assign) BOOL isFullScreen;
@property (nonatomic, assign) NSInteger topBarSelectedIndex;
@property (nonatomic, assign) YFStockBottomBarIndex bottomBarIndex;

@end
