//
//  YFStock_TimeView.h
//  YFStockDemo
//
//  Created by 李友富 on 2017/3/31.
//  Copyright © 2017年 李友富. All rights reserved.
//

// time view

#import <UIKit/UIKit.h>
#import "YFStock_DataHandler.h"

@interface YFStock_TimeView : UIView

// draw
- (void)drawWithDataHandler:(NSArray *)drawKLineModels;

@end
