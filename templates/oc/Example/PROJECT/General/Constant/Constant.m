//
//  Constant.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "Constant.h"
 

@implementation GOAdapter

+ (CGSize)screenSize {
    static CGSize size = (CGSize){0, 0};
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size = [UIScreen mainScreen].bounds.size;
    });
    return size;
}
+ (BOOL)isIPhoneX {
    return [self screenSize].height >= 812.0;
}
+ (CGFloat)safeAreaTopHeight {
    return [self isIPhoneX] ? 24 : 0;
}
+ (CGFloat)safeAreaBottomHeight {
    return [self isIPhoneX] ? 34 : 0;
}
+ (CGFloat)statusBarHeight {
    return 20.0f;
}

static CGFloat _ReferenceW = 375.0f;
+ (void)referenceWidth:(CGFloat)width {
    _ReferenceW = width;
}
static CGFloat _ReferenceH = 375.0f;
+ (void)referenceHeight:(CGFloat)height {
    _ReferenceH = height;
}
@end
