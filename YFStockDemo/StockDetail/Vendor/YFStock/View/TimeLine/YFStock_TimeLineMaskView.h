//
//  YFStock_TimeLineMaskView.h
//  YFStockDemo
//
//  Created by 李友富 on 2017/4/6.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFStock_ScrollView.h"
#import "YFStock_TimeLineModel.h"

@interface YFStock_TimeLineMaskView : UIView

@property (nonatomic, strong) YFStock_TimeLineModel *selectedTimeLineModel;
@property (nonatomic, strong) YFStock_ScrollView *scrollView;

// reset line frame
- (void)resetLineFrame;

@end
