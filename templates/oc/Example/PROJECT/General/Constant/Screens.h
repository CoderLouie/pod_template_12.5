//
//  Screens.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 像素对齐方式
typedef NS_ENUM(NSInteger, PixelAligment) {
    PixelAligmentFloor = 0,
    PixelAligmentRound,
    PixelAligmentCeil
};

/// 屏幕适配工具类
@interface Screens : NSObject

+ (CGFloat)width;

+ (CGFloat)height;

+ (CGSize)size;

+ (CGFloat)scale;

+ (BOOL)isIpad;

+ (BOOL)isIPhoneXSeries;

+ (BOOL)isPortrait;

/// 安全区域刘海一侧的间距 (20/44/50) 也即状态栏高度
+ (CGFloat)safeAreaT;

/// 安全区域刘海对侧的间距 也即 HomeIndicator 高度
+ (CGFloat)safeAreaB;

+ (CGFloat)bodyH;

+ (CGFloat)withoutHeaderH;

+ (CGFloat)withoutFooterH;

+ (CGFloat)navbarH;

+ (CGFloat)tabbarH;

+ (UIEdgeInsets)safeAreaInsets;

+ (UIWindow *)currentWindow;


+ (CGFloat)pix:(CGFloat)value;
+ (CGFloat)pixFloor:(CGFloat)value;
+ (CGFloat)pixRound:(CGFloat)value;
+ (CGFloat)pixCeil:(CGFloat)value;

+ (void)setReferenceScreenSize:(CGSize)size
               isIPhoneXSeries:(BOOL)isIPhoneX;
+ (void)setPixelAligment:(PixelAligment)aligment;

+ (CGFloat)fit:(CGFloat)value;
+ (CGFloat)fitH:(CGFloat)value;
+ (CGFloat)fitT:(CGFloat)value;
+ (CGFloat)fitC:(CGFloat)value;

/// 设备屏幕高度小于570的时候才会进行高度适配，适用于小屏幕手机
+ (CGFloat)fitS:(CGFloat)value;
@end

@interface UIFont (ScreenFit)

- (UIFont *)fit NS_SWIFT_UNAVAILABLE("");

@end

FOUNDATION_EXTERN CGFloat ScreenPixel(CGFloat value, PixelAligment aligment);

NS_ASSUME_NONNULL_END
