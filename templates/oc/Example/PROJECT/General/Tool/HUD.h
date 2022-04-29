//
//  HUD.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HUD : NSObject

+ (void)reset;

+ (void)setMinimumDismissTimeInterval:(NSTimeInterval)interval;

+ (void)setMaximumDismissTimeInterval:(NSTimeInterval)interval;

+ (void)showLoading;

+ (void)showLoadingWithStatus:(NSString *)status;



+ (void)showProgress:(float)progress status:(NSString*)status;

+ (void)showInfoWithStatus:(NSString *)status;

+ (void)showInfoWithStatus:(NSString *)status
              dismissAfter:(NSTimeInterval)interval;

+ (void)showInfoWithStatus:(NSString *)status
                completion:(nullable void(^)(void))completion;

+ (void)showInfoWithStatus:(NSString *)status
              dismissAfter:(NSTimeInterval)interval
                completion:(nullable void(^)(void))completion;

+ (void)showSuccessWithStatus:(NSString *)status;

+ (void)showErrorWithStatus:(NSString *)status;


/**
 在屏幕底部显示提示语 黑色背景，白色文字，会自动消失

 @param tip 提示语
 @warning 在提示语显示期间，如果调用`+ dismiss`强制隐藏，会导致再次使用该控件时位置不正确，此时需调用`+ reset`
 */
+ (void)showTip:(NSString *)tip;

+ (void)showTip:(NSString *)tip marginFromScrrenBottomEdge:(CGFloat)margin;

+ (void)showTip:(NSString *)tip
marginFromScrrenBottomEdge:(CGFloat)margin
     completion:(nullable void(^)(void))completion;

+ (void)dismiss;

+ (BOOL)isVisible;

+ (void)alertWithTitle:(nullable NSString *)title
                  done:(nullable void (^)(void))block;
+ (void)alertWithMessage:(nullable NSString *)message
                    done:(nullable void (^)(void))block;
+ (void)alertWithTitle:(nullable NSString *)title
               message:(nullable NSString *)message
                  done:(nullable void (^)(void))block;

+ (void)presentSheetWithTitle:(nullable NSString *)title
                      actions:(NSArray *)actions;

+ (void)presentSheetWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message
                      actions:(NSArray *)actions;
@end

NS_ASSUME_NONNULL_END
