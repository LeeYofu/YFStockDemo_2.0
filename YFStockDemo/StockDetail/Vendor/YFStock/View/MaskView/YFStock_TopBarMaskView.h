//
//  YFStock_TopBarMaskView.h
//  YFStockDemo
//
//  Created by 李友富 on 2017/4/5.
//  Copyright © 2017年 李友富. All rights reserved.
//

// topBar的遮罩view

#import <UIKit/UIKit.h>
#import "YFStock_Header.h"

@interface YFStock_TopBarMaskView : UIView

- (void)setStockLineType:(YFStockLineType)stockLineType selectedStockLineModel:(id)selectedStockLineModel;

@end
