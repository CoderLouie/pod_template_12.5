//
//  TabBarController.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (TabBarControllerAdded)

- (void)tabbarItemDidSelect;
- (void)tabbarItemDidDeselect;
- (void)tabbarItemDidSelectAgain;

@end

@interface TabBarController : UITabBarController

@end

NS_ASSUME_NONNULL_END
