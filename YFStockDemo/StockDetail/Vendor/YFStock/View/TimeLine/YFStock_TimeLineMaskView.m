//
//  YFStock_TimeLineMaskView.m
//  YFStockDemo
//
//  Created by 李友富 on 2017/4/6.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import "YFStock_TimeLineMaskView.h"
#import "YFStock_Header.h"

@interface YFStock_TimeLineMaskView()

@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic, strong) UIView *horizontalLineLine;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation YFStock_TimeLineMaskView

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
    self.verticalLine.backgroundColor = kWhiteColor;
    [self addSubview:self.verticalLine];
    
    self.horizontalLineLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kStockPartLineHeight)];
    self.horizontalLineLine.backgroundColor = kWhiteColor;
    [self addSubview:self.horizontalLineLine];
    
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

- (void)resetLineFrame {
    
    if (self.selectedTimeLineModel.pricePositionPoint.x - self.scrollView.contentOffset.x < 0 ||
        self.selectedTimeLineModel.pricePositionPoint.x - self.scrollView.contentOffset.x > self.scrollView.width) {
        
        return;
    }
    
    // 水平垂直线
    self.verticalLine.frame = CGRectMake(self.selectedTimeLineModel.pricePositionPoint.x - self.scrollView.contentOffset.x, 0, kStockPartLineHeight, self.height);
    self.horizontalLineLine.frame = CGRectMake(0, self.selectedTimeLineModel.pricePositionPoint.y, self.width, kStockPartLineHeight);
    
    // timeLabel
    self.timeLabel.text = [NSString stringWithFormat:@"%@", self.selectedTimeLineModel.transactionTime];
    [self.timeLabel sizeToFit];
    CGFloat timeLabelW = self.timeLabel.width + 10;
    CGFloat timeLabelX = self.verticalLine.x - timeLabelW * 0.5f;
    CGFloat timeLabelY = (self.scrollView.height - kStockTimeViewHeight) * (1 - [YFStock_Variable KlineVolumeViewHeightRadio]) + kStockPartLineHeight;
    if (timeLabelX < 0) {
        
        timeLabelX = 0;
    }
    if (timeLabelX > self.width - timeLabelW) {
        
        timeLabelX = self.width - timeLabelW;
    }
    self.timeLabel.frame = CGRectMake(timeLabelX, timeLabelY, timeLabelW, kStockTimeViewHeight);
    
    // price label
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f", self.selectedTimeLineModel.bidPrice1];
    [self.priceLabel sizeToFit];
    CGFloat priceLabelW = self.priceLabel.width + 10;
    CGFloat priceLabelY = self.horizontalLineLine.y - kStockTimeViewHeight * 0.5f;
    CGFloat priceLabelX = -kStockKLineScrollViewLeftGap;
    if (self.verticalLine.x < self.width * 0.5f) {
        
        priceLabelX = self.width - priceLabelW;
    }
    if (self.verticalLine.x >= self.width * 0.5f) {
        
        priceLabelX = -kStockKLineScrollViewLeftGap;
    }
    self.priceLabel.frame = CGRectMake(priceLabelX, priceLabelY, priceLabelW, kStockTimeViewHeight);
}


@end
