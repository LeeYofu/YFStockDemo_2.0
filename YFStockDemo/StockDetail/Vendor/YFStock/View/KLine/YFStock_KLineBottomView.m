//
//  YFStock_KLineVolumeView.m
//  YFStockDemo
//
//  Created by 李友富 on 2017/3/30.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import "YFStock_KLineBottomView.h"
#import "YFStock_KLineBottomLine.h"

@interface YFStock_KLineBottomView()

@property (nonatomic, strong) YFStock_KLineBottomLine *bottomLine;

@end

@implementation YFStock_KLineBottomView

- (void)drawWithDataHandler:(YFStock_DataHandler *)dataHandler bottomBarSelectedIndex:(NSInteger)bottomBarSelectedIndex {
    
    [self.bottomLine drawWithBottomBarSelectedIndex:bottomBarSelectedIndex drawKLineModels:dataHandler.drawKLineModels];
}

- (YFStock_KLineBottomLine *)bottomLine {
    
    if (_bottomLine == nil) {
        
        _bottomLine = [[YFStock_KLineBottomLine alloc] initWithFrame:self.bounds];
        [self addSubview:_bottomLine];
    }
    return _bottomLine;
}

@end
