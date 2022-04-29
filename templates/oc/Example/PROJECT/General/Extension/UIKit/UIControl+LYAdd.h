//
//  UIScrollView+LYAdd.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (LYAdd)

/// 接收事件间隔
@property (nonatomic, assign) NSTimeInterval acceptEventInterval;

@end

@interface UIButton (LYAdd)

/**
 自定义响应边界 UIEdgeInsetsMake(-3, -4, -5, -6). 表示扩大
 例如： self.btn.hitEdgeInsets = UIEdgeInsetsMake(-3, -4, -5, -6);
 */
@property(nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;

- (void)cutdown:(NSUInteger)interval
       progress:(void (^)(UIButton *button, NSUInteger left))progressBlock
            end:(void (^)(UIButton *button))endBlock;
@end
