//
//  YFStock_TimeLineModel.h
//  YFStockDemo
//
//  Created by 李友富 on 2017/4/5.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YFStock_TimeLineModel : NSObject

@property (nonatomic, assign) CGFloat bidPrice1;
@property (nonatomic, copy) NSString *transactionTime;

@property (nonatomic, assign) CGPoint pricePositionPoint;

@end
