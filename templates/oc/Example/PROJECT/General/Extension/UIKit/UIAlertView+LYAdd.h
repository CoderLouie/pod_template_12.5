//
//  UIAlertView+LYAdd.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (LYAdd)

- (UIAlertView *)addDefaultActionWithTitle:(NSString *)title handler:(void (^)(void))handler;

- (UIAlertView *)addCancelActionWithTitle:(NSString *)title handler:(void (^)(void))handler;

@end


@interface NSObject (AlertSupport)

#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)alert:(void (^)(UIAlertView *alert))maker;

@end
