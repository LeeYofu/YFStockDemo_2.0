//
//  YFStock_KLineMaskView.h
//  YFStockDemo
//
//  Created by 李友富 on 2017/3/31.
//  Copyright © 2017年 李友富. All rights reserved.
//

// 遮罩 十字线 视图

#import <UIKit/UIKit.h>
#import "YFStock_KLineModel.h"
#import "YFStock_ScrollView.h"

@interface YFStock_KLineMaskView : UIView

@property (nonatomic, strong) YFStock_KLineModel *selectedKLineModel;

- (void)resetLineFrameWithPoint:(CGPoint)point;

@end
