//
//  UIView+Extension.h
//
//  Created by apple on 14-6-27.
//  Copyright (c) 2014年 Liyoufu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)

#pragma mark - frame,bounds,size等
/** X */
@property (nonatomic, assign) CGFloat x;

/** Y */
@property (nonatomic, assign) CGFloat y;

/** MaxX */
@property (nonatomic, assign) CGFloat maxX;

/** MaxY */
@property (nonatomic, assign) CGFloat maxY;

/** CenterX */
@property (nonatomic, assign) CGFloat centerX;

/** CenterY */
@property (nonatomic, assign) CGFloat centerY;

/** Width */
@property (nonatomic, assign) CGFloat width;

/** Height */
@property (nonatomic, assign) CGFloat height;

/** Size */
@property (nonatomic, assign) CGSize size;

#pragma mark - viewController
// 获取视图控制器
- (UIViewController *)viewController;

// 视图变圆角视图
- (UIView *)roundViewWithCornerRadius:(CGFloat)cornerRadius;


@end
