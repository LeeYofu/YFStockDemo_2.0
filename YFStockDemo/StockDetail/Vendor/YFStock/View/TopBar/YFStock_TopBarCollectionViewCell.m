//
//  YFStock_TopBarCollectionViewCell.m
//  YFStockDemo
//
//  Created by 李友富 on 2017/3/31.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import "YFStock_TopBarCollectionViewCell.h"
#import "YFStock_Header.h"

@interface YFStock_TopBarCollectionViewCell()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation YFStock_TopBarCollectionViewCell

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self createSubviews];
    }
    return self;
}

#pragma mark - 创建子视图
- (void)createSubviews {
    
    self.titleLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
    self.titleLabel.font = kFont_14;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = kStockTopBarNormalFontColor;
    [self.contentView addSubview:self.titleLabel];
}

#pragma mark - setter
- (void)setTitle:(NSString *)title {
    
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    _selectedIndex = selectedIndex;
    
    if (selectedIndex == self.indexPath.row) {
        
        self.titleLabel.textColor = kStockTopBarSelectedFontColor;
    } else {
        
        self.titleLabel.textColor = kStockTopBarNormalFontColor;
    }
}

@end
