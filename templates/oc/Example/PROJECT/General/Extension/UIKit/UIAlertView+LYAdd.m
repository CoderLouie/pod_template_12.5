//
//  UIAlertView+LYAdd.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import "UIAlertView+LYAdd.h"
#import <objc/runtime.h>


@implementation UIAlertView (LYAdd)


- (UIAlertView *(^)(NSString *, void (^)(void)))addNormalButton {
   return ^(NSString *title, void(^handler)(void)) {
       NSAssert(title.length, @"A button without a title cannot be added to the alert view.");
       NSInteger idx = [self addButtonWithTitle:title];
       objc_setAssociatedObject(self, (char *)idx, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
       return self;
   };
}

- (UIAlertView *(^)(NSString *, void (^)(void)))setCancelButton {
   return ^(NSString *title, void(^handler)(void)) {
       if (!title.length) {
           title = NSLocalizedString(@"Cancel", nil);
       }
       
       NSInteger idx = [self addButtonWithTitle:title];
       self.cancelButtonIndex = idx;
       objc_setAssociatedObject(self, (char *)idx, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
       return self;
   };
}

@end


@implementation NSObject (AlertSupport)

- (void)alert:(void (^)(UIAlertView *))maker {
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
   UIAlertView *alert = [[UIAlertView alloc] init];
   !maker ? : maker(alert);
   alert.delegate = self;
   [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index {
   void (^handler)(void) = objc_getAssociatedObject(alertView, (char *)index);
   !handler ? : handler();
}

@end
