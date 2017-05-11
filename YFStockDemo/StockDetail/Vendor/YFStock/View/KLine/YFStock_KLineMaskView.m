//
//  YFStock_KLineMaskView.m
//  YFStockDemo
//
//  Created by 李友富 on 2017/3/31.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import "YFStock_KLineMaskView.h"
#import "YFStock_Header.h"

@interface YFStock_KLineMaskView()

@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic, strong) UIView *horizontalLine;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation YFStock_KLineMaskView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = kClearColor;
        self.hidden = YES;
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.verticalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kStockPartLineHeight, self.height)];
    self.verticalLine.backgroundColor = kBlackColor;
    [self addSubview:self.verticalLine];
    
    self.horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kStockPartLineHeight)];
    self.horizontalLine.backgroundColor = kBlackColor;
    [self addSubview:self.horizontalLine];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.frame = CGRectZero;
    self.timeLabel.font = kFont_9;
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.textColor = kWhiteColor;
    self.timeLabel.backgroundColor = kBlackColor;
    [self addSubview:self.timeLabel];
    
    self.priceLabel = [UILabel new];
    self.priceLabel.frame = CGRectZero;
    self.priceLabel.font = kFont_9;
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    self.priceLabel.textColor = kWhiteColor;
    self.priceLabel.backgroundColor = kBlackColor;
    [self addSubview:self.priceLabel];
}

- (void)resetLineFrameWithPoint:(CGPoint)point {
    
    self.verticalLine.frame = CGRectMake(point.x - 0.5, 0, 1, self.height);
    self.horizontalLine.frame = CGRectMake(0, point.y - 0.5, self.width, 1);
}

@end
