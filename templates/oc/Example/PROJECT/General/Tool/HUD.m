//
//  HUD.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import "HUD.h"

#import <SVProgressHUD/SVProgressHUD.h>

#import "UIAlertView+LYAdd.h"
#import "UIWindow+LYAdd.h"


@interface NSString (HUD)
- (NSString *)safelyString;
@end


@implementation NSString (HUD)
- (NSString *)safelyString {
    if (![self isKindOfClass:[NSString class]]) return nil;
    if (!self.length) return nil;
    return self;
}
@end

@implementation HUD

+ (void)initialize {
    [self reset];
}

+ (void)reset {
    [SVProgressHUD resetOffsetFromCenter];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setMaximumDismissTimeInterval:5];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
}

+ (void)setMaximumDismissTimeInterval:(NSTimeInterval)interval {
    [SVProgressHUD setMaximumDismissTimeInterval:interval];
}

+ (void)setMinimumDismissTimeInterval:(NSTimeInterval)interval {
    [SVProgressHUD setMinimumDismissTimeInterval:interval];
}

+ (void)showLoading {
    [SVProgressHUD show];
}

+ (void)showLoadingWithStatus:(NSString *)status {
    [SVProgressHUD showWithStatus:status.safelyString];
}

+ (void)showProgress:(float)progress status:(NSString*)status {
    [SVProgressHUD showProgress:progress status:status.safelyString];
}

+ (void)showInfoWithStatus:(NSString *)status {
    [SVProgressHUD showInfoWithStatus:status.safelyString];
}

+ (void)showInfoWithStatus:(NSString *)status
              dismissAfter:(NSTimeInterval)interval {
    [SVProgressHUD showInfoWithStatus:status.safelyString];
    [SVProgressHUD dismissWithDelay:interval];
}

+ (void)showInfoWithStatus:(NSString *)status
                completion:(void(^)(void))completion {
    NSString *tip = status.safelyString;
    NSTimeInterval delay = [SVProgressHUD displayDurationForString:tip];
    [SVProgressHUD showInfoWithStatus:status.safelyString];
    [SVProgressHUD dismissWithDelay:delay completion:completion];
}

+ (void)showInfoWithStatus:(NSString *)status
              dismissAfter:(NSTimeInterval)interval
                completion:(void(^)(void))completion {
    [SVProgressHUD showInfoWithStatus:status.safelyString];
    [SVProgressHUD dismissWithDelay:interval completion:completion];
}

+ (void)showSuccessWithStatus:(NSString *)status {
    [SVProgressHUD showSuccessWithStatus:status.safelyString];
}

+ (void)showErrorWithStatus:(NSString *)status {
    [SVProgressHUD showErrorWithStatus:status.safelyString];
}

+ (void)showTip:(NSString *)tip {
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat screenW = size.width;
    [self showTip:tip marginFromScrrenBottomEdge:20 * (screenW / 375.0)];
}

+ (void)showTip:(NSString *)tip marginFromScrrenBottomEdge:(CGFloat)margin
{
    [self showTip:tip marginFromScrrenBottomEdge:margin completion:nil];
}

+ (void)showTip:(NSString *)tip
marginFromScrrenBottomEdge:(CGFloat)margin
     completion:(void(^)(void))completion {
    NSTimeInterval delay = [SVProgressHUD displayDurationForString:tip.safelyString];
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat screenH = size.height;
    CGFloat offsetY = screenH * 0.5 - margin;
    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, offsetY)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    [SVProgressHUD showImage:nil status:tip.safelyString];
#pragma clang diagnostic pop
    
    [SVProgressHUD dismissWithDelay:delay completion:^{
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD resetOffsetFromCenter];
        !completion ?: completion();
    }];
}

+ (void)dismiss {
    if ([SVProgressHUD isVisible]) [SVProgressHUD dismiss];
}

+ (BOOL)isVisible {
    return [SVProgressHUD isVisible];
}

+ (void)alertWithTitle:(NSString *)title done:(void (^)(void))block {
    [self alertWithTitle:title message:nil done:block];
}
+ (void)alertWithMessage:(NSString *)message done:(void (^)(void))block {
    [self alertWithTitle:@"提示" message:message done:block];
}
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message done:(void (^)(void))block {
    [@1 alert:^(UIAlertView *alert) {
        alert.title = title;
        alert.message = message;
        alert.addNormalButton(@"确定", block);
        alert.setCancelButton(@"取消", nil);
    }];
}
+ (void)presentSheetWithTitle:(NSString *)title
                      actions:(NSArray *)actions {
    [self presentSheetWithTitle:title message:nil actions:actions];
}
+ (void)presentSheetWithTitle:(NSString *)title
                      message:(NSString *)message
                      actions:(NSArray *)actions {
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSArray *item in actions) {
        UIAlertAction *one = [UIAlertAction actionWithTitle:item[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ((void (^)(void))item[1])();
        }];
        [sheet addAction:one];
    }
     
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
     
    [sheet addAction:cancel];
    UIViewController *vc = [UIApplication sharedApplication].delegate.window.ly_currentViewController;
    [vc presentViewController:sheet animated:YES completion:nil];
}

@end
