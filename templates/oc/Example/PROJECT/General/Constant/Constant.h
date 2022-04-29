//
//  Constant.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

NS_INLINE UIColor *RGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha) {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}
NS_INLINE UIColor *RGB(CGFloat red, CGFloat green, CGFloat blue) {
    return RGBA(red, green, blue, 1.0);
}
NS_INLINE UIColor *GrayColor(CGFloat value) {
    return RGBA(value, value, value, 1.0);
}
NS_INLINE UIColor *GrayAColor(CGFloat value, CGFloat alpha) {
    return RGBA(value, value, value, alpha);
}

NS_INLINE NSInteger RandomInRange(NSInteger lower, NSInteger upper) {
    return lower + (arc4random() % (upper - lower + 1));
}

/** roundl 四舍五入取整，求最接近 x 的整数
5.2 -> 5.0
5.5 -> 6.0
-5.2 -> -5.0
-5.5 -> -6.0
*/
NS_INLINE CGFloat Rounded(NSInteger numberOfDecimalPlaces, CGFloat value) {
    NSUInteger factor = pow(10.0, MAX(0, numberOfDecimalPlaces));
    return roundl((value * factor)) / factor;
}
/** ceill 向上取整，求不小于 x 的最小整数
 5.2 -> 6.0
 5.5 -> 6.0
 -5.2 -> -5.0
 -5.5 -> -5.0
 */
NS_INLINE CGFloat RoundedUp(NSInteger numberOfDecimalPlaces, CGFloat value) {
    NSUInteger factor = pow(10.0, MAX(0, numberOfDecimalPlaces));
    return ceill((value * factor)) / factor;
}
/** floorl 向下取整，求不大于 x 的最大整数
5.2 -> 5.0
5.5 -> 5.0
-5.2 -> -6.0
-5.5 -> -6.0
*/
NS_INLINE CGFloat RoundedDown(NSInteger numberOfDecimalPlaces, CGFloat value) {
    NSUInteger factor = pow(10.0, MAX(0, numberOfDecimalPlaces));
    return floorl((value * factor)) / factor;
}
/** truncl 取浮点数的整数部分，舍弃小数部分
 5.2 -> 5.0
 5.5 -> 5.0
 -5.2 -> -5.0
 -5.5 -> -5.0
 */
NS_INLINE CGFloat RoundedTowardZero(NSInteger numberOfDecimalPlaces, CGFloat value) {
    NSUInteger factor = pow(10.0, MAX(0, numberOfDecimalPlaces));
    return truncl((value * factor)) / factor;
}

// modf, modff, modfl - 把浮点数分解为小数部分和整数部分

/** 求最接近value的multiple倍的整数
 RoundedToNearest(5, 6) -> 5
 RoundedToNearest(8, 6) -> 10
 */
NS_INLINE NSInteger RoundedToNearest(NSInteger multiple, NSInteger value) {
    return value == 0 ? 0 : (NSInteger)(round(value / multiple)) * multiple;
} 

NS_INLINE NSString *RandomString1(NSInteger lowerLength, NSInteger upperLength) {
    static const NSString *alphabet = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSUInteger count = alphabet.length - 1;
    NSUInteger n = RandomInRange(lowerLength, upperLength);
    NSMutableString *string = [NSMutableString stringWithCapacity: count];
    while (n-- > 0) {
        [string appendFormat:@"%c", [alphabet characterAtIndex:RandomInRange(0, count)]];
    }
    return string;
}
NS_INLINE NSString *RandomString() {
    return RandomString1(5, 40);
}

NS_INLINE NSString *TR(NSString *key) {
    return NSLocalizedString(key, nil);
}

typedef NSString * const NotificationName;

@interface GOAdapter : NSObject

@end

NS_ASSUME_NONNULL_END
