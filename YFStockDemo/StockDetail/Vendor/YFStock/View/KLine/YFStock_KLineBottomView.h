//
//  YFStock_KLineVolumeView.h
//  YFStockDemo
//
//  Created by 李友富 on 2017/3/30.
//  Copyright © 2017年 李友富. All rights reserved.
//

// 真正的成交量视图

#import <UIKit/UIKit.h>
#import "YFStock_DataHandler.h"

@interface YFStock_KLineBottomView : UIView

// draw method
- (void)drawWithDataHandler:(YFStock_DataHandler *)dataHandler bottomBarSelectedIndex:(NSInteger)bottomBarSelectedIndex;

@end
