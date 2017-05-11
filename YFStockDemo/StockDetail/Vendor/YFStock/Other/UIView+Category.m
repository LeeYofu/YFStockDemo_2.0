//
//  UIView+Extension.m
//
//  Created by apple on 14-6-27.
//  Copyright (c) 2014年 Liyoufu. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Category)

#pragma mark - frame,bounds,size等
/** X */
- (void)setX:(CGFloat)x {
    
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x {
    
    return self.frame.origin.x;
}

/** Y */
- (void)setY:(CGFloat)y {
    
     CGRect frame = self.frame;
     frame.origin.y = y;
     self.frame = frame;
}

- (CGFloat)y {
    
     return self.frame.origin.y;
}

/** MaxX */
- (void)setMaxX:(CGFloat)maxX {
    
    self.x = maxX - self.width;
}

- (CGFloat)maxX {
    
    return CGRectGetMaxX(self.frame);
}

/** MaxY */
- (void)setMaxY:(CGFloat)maxY {
    
    self.y = maxY - self.height;
}

- (CGFloat)maxY {
    
    return CGRectGetMaxY(self.frame);
}

/** CenterX */
- (void)setCenterX:(CGFloat)centerX {
    
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX {
    
    return self.center.x;
}

/** CenterY */
- (void)setCenterY:(CGFloat)centerY {
    
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY {
    
    return self.center.y;
}

/** Width */
- (void)setWidth:(CGFloat)width {
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    
    return self.frame.size.width;
}

/** Height */
- (void)setHeight:(CGFloat)height {
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    
    return self.frame.size.height;
}

/** Size*/
- (void)setSize:(CGSize)size {
    
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    
    return self.frame.size;
}

#pragma mark - other
- (UIViewController *)viewController {
    
    UIResponder *nextResponder =  self;
    do {
        nextResponder = [nextResponder nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController*)nextResponder;
        
    } while (nextResponder != nil);
    
    return nil;
}

- (UIView *)roundViewWithCornerRadius:(CGFloat)cornerRadius {
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius * 0.5f;
    
    return self;
}

@end
