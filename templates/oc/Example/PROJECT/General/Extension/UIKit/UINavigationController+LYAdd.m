//
//  UINavigationController+LYAdd.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "UINavigationController+LYAdd.h" 

@implementation UINavigationController (LYAdd)

- (UIViewController *)popToViewControllerWithClass:(Class)cls {
    UIViewController *topVC = self.topViewController;
    while (![topVC isKindOfClass:cls]) {
        [self popViewControllerAnimated:NO];
        topVC = self.topViewController;
    }
    return topVC;
}

@end
