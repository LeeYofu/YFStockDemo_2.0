//
//  YFStock_TimeLine.h
//  YFStockDemo
//
//  Created by 李友富 on 2017/4/5.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFStock_TimeLineModel.h"

@interface YFStock_TimeLine : UIView

- (YFStock_TimeLine *)initWithFrame:(CGRect)frame timeLineModels:(NSArray <YFStock_TimeLineModel *> *)timeLineModels;
// 传入的是所有的timeLine模型
- (void)reDrawWithKLineModels:(NSArray <YFStock_TimeLineModel *> *)timeLineModels;

@end
