//
//  YFStock_TopBarMaskViewCollectionViewCell.m
//  YFStockDemo
//
//  Created by 李友富 on 2017/4/5.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import "YFStock_TopBarMaskViewCollectionViewCell.h"
#import "YFStock_Header.h"

@interface YFStock_TopBarMaskViewCollectionViewCell()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation YFStock_TopBarMaskViewCollectionViewCell

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.contentLabel = [UILabel new];
    self.contentLabel.frame = self.contentView.bounds;
    self.contentLabel.font = kFont_12;
    self.contentLabel.textColor = kCustomRGBColor(22, 22, 22, 179.0 / 255.0);
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.contentLabel];
}

#pragma mark - setter
- (void)setTitle:(NSString *)title content:(NSString *)content {
    
    self.title = title;
    self.content = content;
    
    self.contentLabel.text = [title stringByAppendingString:content];
}

@end
