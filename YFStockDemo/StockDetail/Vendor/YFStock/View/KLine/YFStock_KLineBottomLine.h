//
//  YFStock_VolumeLine.h
//  YFStockDemo
//
//  Created by 李友富 on 2017/3/31.
//  Copyright © 2017年 李友富. All rights reserved.
//

// VolumeLine

#import <UIKit/UIKit.h>
#import "YFStock_KLineModel.h"

@interface YFStock_KLineBottomLine : UIView

// draw
- (void)drawWithBottomBarSelectedIndex:(NSInteger)bottomBarSelectedIndex drawKLineModels:(NSArray <YFStock_KLineModel *>*)drawKLineModels;


@end
