//
//  BaseViewController.m
//  YFStockDemo
//
//  Created by 李友富 on 2017/4/24.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 默认设置状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}

- (BOOL)shouldAutorotate {
    
    return NO;
}

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    
//    return UIInterfaceOrientationMaskPortrait;
//}

@end
