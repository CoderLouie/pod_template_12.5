//
//  UIView+LYAdd.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "UIView+LYAdd.h"
#import <objc/runtime.h>

@implementation UIView (LYAdd)

/// 判断一个控件是否真正显示在主窗口
- (BOOL)isShowingOnScreen
{
    if (self.isHidden) return NO;
    if (self.alpha <= 0.01) return NO;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (self.window != window) return NO;
    // 以主窗口左上角为坐标原点, 计算self的矩形框
    CGRect newFrame = [window convertRect:self.frame fromView:self.superview];
    CGRect winBounds = window.bounds;
    // 主窗口的bounds 和 self的矩形框 是否有重叠
    return CGRectIntersectsRect(newFrame, winBounds);
}

/// 从xib文件初始化视图
+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
}

- (void)_subViewsWithClass:(Class)cls array:(NSMutableArray *)views {
    if ([self isMemberOfClass:cls]) {
        [views addObject:self];
    }
    if (self.subviews.count == 0) return;
    [self.subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj _subViewsWithClass:cls array:views];
    }];
}

- (NSArray<__kindof UIView *> *)subViewsWithClass:(Class)cls {
    NSMutableArray *views = [NSMutableArray array];
    [self _subViewsWithClass:cls array:views];
    return views;
}

@end
