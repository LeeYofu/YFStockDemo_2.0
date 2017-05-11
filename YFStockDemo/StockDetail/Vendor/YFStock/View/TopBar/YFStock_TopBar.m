//
//  YFStock_TopBar.m
//  YFStockDemo
//
//  Created by 李友富 on 2017/3/31.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import "YFStock_TopBar.h"
#import "YFStock_TopBarCollectionViewCell.h"

static NSString *identifier = @"collectionCell";

@interface YFStock_TopBar() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *titles; // 标题数组
@property (nonatomic, assign) YFStockTopBarIndex selectedIndex;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewFlowLayout;

@end

@implementation YFStock_TopBar

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles topBarSelectedIndex:(YFStockTopBarIndex)topBarSelectedIndex {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = kStockTopBarBgColor;
        
        // 当前选中下标，默认为0
        self.selectedIndex = topBarSelectedIndex;
        self.titles = titles;

        [self createSubviews];
    }
    return self;
}

#pragma mark - 创建子视图
- (void)createSubviews {
    
    // collection view
    self.collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemSizeW = self.width / self.titles.count;
    if (itemSizeW < 55) {
        
        itemSizeW = 55;
    }
    if (itemSizeW > 70) {
        
        itemSizeW = 70;
    }
    CGFloat itemSizeH = self.height;
    
    self.collectionViewFlowLayout.itemSize = CGSizeMake(itemSizeW, itemSizeH);
    self.collectionViewFlowLayout.minimumInteritemSpacing = 0; // 左右间距
    self.collectionViewFlowLayout.minimumLineSpacing = 0; // line 上下间距
    self.collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.collectionViewFlowLayout];
    self.collectionView.backgroundColor = kStockTopBarBgColor;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.bounces = NO;
    
    [self.collectionView registerClass:[YFStock_TopBarCollectionViewCell class]forCellWithReuseIdentifier:identifier];
    
    [self addSubview:self.collectionView];
}

#pragma mark - 集合视图代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    YFStock_TopBarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.selectedIndex = self.selectedIndex;
    cell.title = self.titles[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 给当前选中下标赋值
    self.selectedIndex = indexPath.row;
    
    // reload data
    [self.collectionView reloadData];
    
    // 将改变的下标传到外界 == stock
    if (self.delegate && [self.delegate respondsToSelector:@selector(YFStock_TopBar:didSelectedItemAtIndex:)]) {
        
        [self.delegate YFStock_TopBar:self didSelectedItemAtIndex:indexPath.row];
    }
}

- (NSArray *)titles {
    
    if (_titles == nil) {
        
        _titles = [NSArray new];
    }
    return _titles;
}

@end
