//
//  YFStock_TopBarCollectionViewCell.h
//  YFStockDemo
//
//  Created by 李友富 on 2017/3/31.
//  Copyright © 2017年 李友富. All rights reserved.
//

// top bar cell

#import <UIKit/UIKit.h>

@interface YFStock_TopBarCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
