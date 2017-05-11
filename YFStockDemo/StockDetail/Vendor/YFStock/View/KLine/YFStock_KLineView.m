//
//  YFStock_KLineView.m
//  YFStockDemo
//
//  Created by 李友富 on 2017/3/30.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import "YFStock_KLineView.h"
#import "YFStock_Header.h"
#import "YFKline.h"
#import "YFMA_BOLLLine.h"

@interface YFStock_KLineView()

@property (nonatomic, strong) YFKline *KLine;
@property (nonatomic, strong) YFMA_BOLLLine *MA_BOLLLine;

@end

@implementation YFStock_KLineView

- (void)drawWithDataHandler:(YFStock_DataHandler *)dataHandler {
    
    [self.KLine drawWithDrawKLineModels:dataHandler.drawKLineModels];
    [self.MA_BOLLLine drawWithKLineModels:dataHandler.drawKLineModels KLineLineType:YFStockKLineLineType_MA];
}

- (YFKline *)KLine {
    
    if (_KLine == nil) {
       
        _KLine = [[YFKline alloc] initWithFrame:self.bounds];
        [self addSubview:_KLine];
    }
    
    return _KLine;
}

- (YFMA_BOLLLine *)MA_BOLLLine {
    
    if (_MA_BOLLLine == nil) {
        
        _MA_BOLLLine = [[YFMA_BOLLLine alloc] initWithFrame:self.bounds];
        [self addSubview:_MA_BOLLLine];
    }
    return _MA_BOLLLine;
}

@end
