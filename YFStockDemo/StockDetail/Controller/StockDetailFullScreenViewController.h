//
//  StockDetailFullScreenViewController.h
//  GoldfishSpot
//
//  Created by 李友富 on 2017/4/19.
//  Copyright © 2017年 中泰荣科. All rights reserved.
//

#import "BaseViewController.h"

@protocol StockDetailFullScreenViewControllerDelegate <NSObject>

@optional

- (void)stockDetailFullScreenViewControllerExitButtonDidClicked;

@end

@interface StockDetailFullScreenViewController : BaseViewController

@property (nonatomic, weak) id<StockDetailFullScreenViewControllerDelegate> delegate;
- (void)createSubviews;

@end
