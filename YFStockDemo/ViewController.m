//
//  ViewController.m
//  YFStockDemo
//
//  Created by 李友富 on 2017/4/24.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import "ViewController.h"
#import "StockDetailViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =  CGRectMake(20, 100, 100, 45);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"上证指数" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonDidClicked {
    
    StockDetailViewController *stockDetailVC = [StockDetailViewController new];
    stockDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:stockDetailVC animated:YES];
}




@end
