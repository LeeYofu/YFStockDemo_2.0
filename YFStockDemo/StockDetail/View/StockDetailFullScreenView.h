//
//  StockDetailFullScreenView.h
//  YFStockDemo
//
//  Created by 李友富 on 2017/5/9.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StockDetailFullScreenViewDelegate <NSObject>

@optional

- (void)stockDetailFullScreenViewExitButtonDidClicked;

@end

@interface StockDetailFullScreenView : UIView

@property (nonatomic, weak) id<StockDetailFullScreenViewDelegate> delegate;

- (void)createSubviews;

@end
