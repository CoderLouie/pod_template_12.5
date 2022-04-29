//
//  UIViewController+LYAdd.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//
 
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (IVAdd)

- (MASViewAttribute *)iv_safe_top;
- (MASViewAttribute *)iv_safe_bottom;

@end

@interface UIViewController (LYAdd)
- (UIAlertController *)presentAlertWithStyle:(UIAlertControllerStyle)style
                                        make:(void (^)(UIAlertController *alert))make;

/// 从SB中加载指定的控制器 name为sb名称
+ (instancetype)loadFromStoryboardWithName:(NSString *)name;
/// 从Main.storyboard加载控制器
+ (instancetype)loadFromMainStoryboard;
@end

@interface UIAlertController (LYAdd)
- (UIAlertAction *)addActionWithTitle:(NSString *)title
                                style:(UIAlertActionStyle)style
                              handler:(void (^)(UIAlertAction *action))handler;
@end

NS_ASSUME_NONNULL_END
