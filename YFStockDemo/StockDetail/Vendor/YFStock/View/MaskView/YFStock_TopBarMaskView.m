//
//  YFStock_TopBarMaskView.m
//  YFStockDemo
//
//  Created by 李友富 on 2017/4/5.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import "YFStock_TopBarMaskView.h"
#import "YFStock_TopBarMaskViewCollectionViewCell.h"
#import "YFStock_KLineModel.h"

static NSString *identifier = @"cell";

@interface YFStock_TopBarMaskView() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *contentArray;

@property (nonatomic, strong) NSArray *KLineTitleArray;

@property (nonatomic, assign) YFStockLineType stockLineType;
@property (nonatomic, strong) YFStock_KLineModel *selectedKLineModel;

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewFlowLayout;

@end

@implementation YFStock_TopBarMaskView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.hidden = YES;
        self.backgroundColor = kStockTopBarBgColor;
        
        [self config];
        [self createSubviews];
    }
    return self;
}

- (void)config {
    
    self.KLineTitleArray = @[
                             @"高:",
                             @"开:",
                             @"低:",
                             @"收:"
                             ];
}

- (void)createSubviews {
    
    self.timeLabel = [UILabel new];
    self.timeLabel.frame = CGRectMake(0, 0, 0, self.height); // 0!!!!
    self.timeLabel.font = kFont_12;
    self.timeLabel.textColor = kWhiteColor;
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.timeLabel];
    
    // collection view
    self.collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat collectionViewWidth = self.width - self.timeLabel.maxX;
    CGFloat itemSizeW = collectionViewWidth / 5;
    CGFloat itemSizeH = self.height;
    self.collectionViewFlowLayout.itemSize = CGSizeMake(itemSizeW, itemSizeH);
    self.collectionViewFlowLayout.minimumInteritemSpacing = 0; // 左右间距
    self.collectionViewFlowLayout.minimumLineSpacing = 0; // line 上下间距
    self.collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.timeLabel.maxX + 5, 0, collectionViewWidth, self.height) collectionViewLayout:self.collectionViewFlowLayout];
    self.collectionView.backgroundColor = kStockTopBarBgColor;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self addSubview:self.collectionView];
    
    [self.collectionView registerClass:[YFStock_TopBarMaskViewCollectionViewCell class]forCellWithReuseIdentifier:identifier];
}


#pragma mark - setter
- (void)setStockLineType:(YFStockLineType)stockLineType selectedStockLineModel:(id)selectedStockLineModel {
    
    self.stockLineType = stockLineType;
    if (self.stockLineType == YFStockLineTypeTimeLine) {
        
        
    } else {
        
        self.selectedKLineModel = (YFStock_KLineModel *)selectedStockLineModel;
        self.timeLabel.text = self.selectedKLineModel.dataTime;
    }
    
    [self.collectionView reloadData];
}

- (void)setSelectedKLineModel:(YFStock_KLineModel *)selectedKLineModel {
    
    _selectedKLineModel = selectedKLineModel;
    
    self.titleArray = self.KLineTitleArray;
    self.contentArray = @[
                          [NSString stringWithFormat:@"%.2f", selectedKLineModel.highPrice.floatValue],
                          [NSString stringWithFormat:@"%.2f", selectedKLineModel.openPrice.floatValue],
                          [NSString stringWithFormat:@"%.2f", selectedKLineModel.lowPrice.floatValue],
                          [NSString stringWithFormat:@"%.2f", selectedKLineModel.closePrice.floatValue]
                          ];
}

#pragma mark - 集合视图代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.stockLineType == YFStockLineTypeTimeLine) {
        
        return 4;
    } else {
        
        return self.titleArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    YFStock_TopBarMaskViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell setTitle:self.titleArray[indexPath.row] content:self.contentArray[indexPath.row]];
    return cell;
}

@end
