//
//  YFStock_TimeLineView.h
//  YFStockDemo
//
//  Created by 李友富 on 2017/4/6.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFStock_DataHandler.h"

@interface YFStock_TimeLineView : UIView

- (void)drawWithDataHandler:(YFStock_DataHandler *)dataHandler;

@end
