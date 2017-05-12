//
//  CustomNavigationController.m
//  GoldfishSpot
//
//  Created by 李友富 on 2017/4/19.
//  Copyright © 2017年 中泰荣科. All rights reserved.
//

#import "CustomNavigationController.h"

@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

- (BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    
//    return [self.topViewController supportedInterfaceOrientations];
//}

@end
