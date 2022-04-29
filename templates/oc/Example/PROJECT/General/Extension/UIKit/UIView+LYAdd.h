//
//  UIView+LYAdd.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LYAdd)

/// 是否显示在屏幕上
- (BOOL)isShowingOnScreen;

/// 从xib文件初始化视图
+ (instancetype)viewFromXib;

- (NSArray<__kindof UIView *> *)subViewsWithClass:(Class)cls;


@end
