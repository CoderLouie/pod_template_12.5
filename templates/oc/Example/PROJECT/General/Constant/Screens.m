//
//  Screens.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import "Screens.h"

@implementation Screens
+ (CGFloat)width {
    CGFloat sw = self.sw;
    CGFloat sh = self.sh;
    return sw < sh ? sw : sh;
}
+ (CGFloat)height {
    CGFloat sw = self.sw;
    CGFloat sh = self.sh;
    return sw < sh ? sh : sw;
}
+ (CGSize)size {
    return CGSizeMake(self.width, self.height);
}
+ (CGFloat)scale {
    return UIScreen.mainScreen.scale;
}
+ (BOOL)isIpad {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}
+ (BOOL)isIPhoneXSeries {
    return self.currentWindow.safeAreaInsets.bottom > 0;
}
+ (BOOL)isPortrait {
    return UIApplication.sharedApplication.statusBarOrientation == UIInterfaceOrientationPortrait;
}
/// 安全区域刘海一侧的间距 (20/44/50) 也即状态栏高度
+ (CGFloat)safeAreaT {
    UIEdgeInsets inset = self.safeAreaInsets;
    switch (UIApplication.sharedApplication.statusBarOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            return inset.top;
        case UIInterfaceOrientationLandscapeLeft:
            return inset.right;
        case UIInterfaceOrientationLandscapeRight:
            return inset.left;
        default: return 0;
    }
}
/// 安全区域刘海对侧的间距 也即 HomeIndicator 高度
+ (CGFloat)safeAreaB {
    UIEdgeInsets inset = self.safeAreaInsets;
    switch (UIApplication.sharedApplication.statusBarOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            return inset.bottom;
        case UIInterfaceOrientationLandscapeLeft:
            return inset.left;
        case UIInterfaceOrientationLandscapeRight:
            return inset.right;
        default: return 0;
    }
}
+ (CGFloat)bodyH {
    UIEdgeInsets inset = self.safeAreaInsets;
    return self.height - inset.top - inset.bottom;
}
+ (CGFloat)withoutHeaderH {
    return self.height - self.safeAreaT;
}
+ (CGFloat)withoutFooterH {
    return self.height - self.safeAreaB;
}
+ (CGFloat)navbarH {
    return self.safeAreaT + 44;
}
+ (CGFloat)tabbarH {
    return self.safeAreaB + 49;
}

+ (UIEdgeInsets)safeAreaInsets {
    UIWindow *window = self.currentWindow;
    if (!window) return UIEdgeInsetsZero;
    
    UIEdgeInsets inset = window.rootViewController.view.safeAreaInsets;
    if (inset.top > 0) return inset;
    return window.safeAreaInsets;
}
+ (UIWindow *)currentWindow {
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    if (window) return window;
#ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        UIScene *scene = UIApplication.sharedApplication.connectedScenes.anyObject;
        if (scene) {
            window = [scene valueForKeyPath:@"delegate.window"];
            if (window &&
                [window isKindOfClass:[UIWindow class]]) return window;
        }
        return UIApplication.sharedApplication.windows.lastObject;
    }
#endif
    return UIApplication.sharedApplication.keyWindow;
}

+ (CGFloat)pix:(CGFloat)value {
    return [self pixRound:value];
}
+ (CGFloat)pixFloor:(CGFloat)value {
    CGFloat scale = [self scale];
    return floor(value * scale) / scale;
}
+ (CGFloat)pixRound:(CGFloat)value {
    CGFloat scale = [self scale];
    return round(value * scale) / scale;
}
+ (CGFloat)pixCeil:(CGFloat)value {
    CGFloat scale = [self scale];
    return ceil(value * scale) / scale;
} 

static CGFloat _ReferenceW = 375.0f;
static CGFloat _ReferenceH = 812.0f;
static BOOL _ReferenceIsIPhoneX = true;
+ (void)setReferenceScreenSize:(CGSize)size
               isIPhoneXSeries:(BOOL)isIPhoneX {
    _ReferenceW = size.width;
    _ReferenceH = size.height;
    _ReferenceIsIPhoneX = isIPhoneX;
}
static BOOL _pixelAligment = PixelAligmentRound;
+ (void)setPixelAligment:(PixelAligment)aligment {
    _pixelAligment = aligment;
}

+ (CGFloat)fit:(CGFloat)value {
    return ScreenPixel([self width] / _ReferenceW * value,
                       _pixelAligment);
}
+ (CGFloat)fitH:(CGFloat)value {
    return ScreenPixel([self height] / _ReferenceH * value,
                       _pixelAligment);
}
+ (CGFloat)fitT:(CGFloat)value {
    CGFloat fitValue = self.withoutHeaderH / self.referenceWithoutHeaderHeight * value;
    return ScreenPixel(fitValue, _pixelAligment);
}
+ (CGFloat)fitC:(CGFloat)value {
    CGFloat fitValue = self.bodyH / self.referenceBodyHeight * value;
    return ScreenPixel(fitValue, _pixelAligment);
}
+ (CGFloat)fitS:(CGFloat)value {
    CGFloat sh = Screens.height;
    CGFloat fitValue = sh > 570 ? value : (sh / self.referenceBodyHeight * value);
    return ScreenPixel(fitValue, _pixelAligment);
}
// MARK: - Private
+ (CGFloat)referenceWithoutHeaderHeight {
    if (!_ReferenceIsIPhoneX) return _ReferenceH;
    return _ReferenceH - self.safeAreaT;
}
+ (CGFloat)referenceBodyHeight {
    if (!_ReferenceIsIPhoneX) return _ReferenceH;
    UIEdgeInsets inset = self.safeAreaInsets;
    return _ReferenceH - inset.top - inset.bottom;
}
+ (CGFloat)sw {
    return UIScreen.mainScreen.bounds.size.width;
}
+ (CGFloat)sh {
    return UIScreen.mainScreen.bounds.size.height;
}

@end


@implementation UIFont (ScreenFit)

- (UIFont *)fit {
    CGFloat newSize = [Screens width] / _ReferenceW * self.pointSize;
    return [self fontWithSize:round(newSize)];
}

@end


CGFloat ScreenPixel(CGFloat value, PixelAligment aligment) {
    CGFloat scale = [Screens scale];
    switch (aligment) {
        case PixelAligmentFloor:
            return floor(value * scale) / scale;
        case PixelAligmentRound:
            return round(value * scale) / scale;
        case PixelAligmentCeil:
            return ceil(value * scale) / scale;
    }
}
