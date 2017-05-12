//
//  CustomTabBarController.m
//  YFStockDemo
//
//  Created by 李友富 on 2017/4/24.
//  Copyright © 2017年 李友富. All rights reserved.
//

#import "CustomTabBarController.h"
#import "CustomNavigationController.h"
#import "ViewController.h"

@interface CustomTabBarController ()

@end

@implementation CustomTabBarController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    ViewController *VC = [ViewController new];
    [self addChildViewController:VC title:@"首页" imageName:@"首页-未点击" selectedImageName:@"首页-点击"];
    
}

- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    
    childController.title = title;
    childController.tabBarItem.image = [UIImage imageNamed:imageName];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CustomNavigationController *navigationC = [[CustomNavigationController alloc] initWithRootViewController:childController];
    [self addChildViewController:navigationC];
}


- (BOOL)shouldAutorotate
{
    return [self.selectedViewController shouldAutorotate];
}

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//
//    return [self.selectedViewController supportedInterfaceOrientations];
//}



@end
