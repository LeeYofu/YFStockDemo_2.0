//
//  YFStock_KLineView.h
//  YFStockDemo
//
//  Created by 李友富 on 2017/3/30.
//  Copyright © 2017年 李友富. All rights reserved.
//

// 真正的K线视图

#import <UIKit/UIKit.h>
#import "YFStock_DataHandler.h"

@interface YFStock_KLineView : UIView

// draw method
- (void)drawWithDataHandler:(YFStock_DataHandler *)dataHandler;

@end
