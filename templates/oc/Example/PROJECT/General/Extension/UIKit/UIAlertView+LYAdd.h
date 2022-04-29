//
//  UIAlertView+LYAdd.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (LYAdd)

- (UIAlertView *(^)(NSString *title, void(^handler)(void)))addNormalButton;

- (UIAlertView *(^)(NSString *title, void(^handler)(void)))setCancelButton;

@end


@interface NSObject (AlertSupport)

#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)alert:(void (^)(UIAlertView *alert))maker;

@end
