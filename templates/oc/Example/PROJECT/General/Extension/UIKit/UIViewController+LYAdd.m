//
//  UIViewController+LYAdd.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import "UIViewController+IVAdd.h" 


@implementation UIViewController (IVAdd)

- (MASViewAttribute *)iv_safe_top {
    if (@available(iOS 11.0, *)) {
        return self.view.mas_safeAreaLayoutGuideTop;
    } else {
        // Fallback on earlier versions
        return self.mas_topLayoutGuideBottom;
    }
}

- (MASViewAttribute *)iv_safe_bottom {
    if (@available(iOS 11.0, *)) {
        return self.view.mas_safeAreaLayoutGuideBottom;
    } else {
        // Fallback on earlier versions
        return self.mas_bottomLayoutGuideTop;
    }
}

@end

@implementation UIViewController (LYAdd)

- (UIAlertController *)presentAlertWithStyle:(UIAlertControllerStyle)style
                         make:(void (^)(UIAlertController *alert))make {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:style];
    make(alert);
    [self presentViewController:alert animated:YES completion:nil];
    return alert;
}

/// 从SB中加载指定的控制器
+ (instancetype)loadFromStoryboardWithName:(NSString *)name {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:name bundle:nil];
    return [sb instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}
+ (instancetype)loadFromMainStoryboard {
    return [self loadFromStoryboardWithName:@"Main"];
}

@end
@implementation UIAlertController (LYAdd)

- (UIAlertAction *)addActionWithTitle:(NSString *)title
                     style:(UIAlertActionStyle)style
                   handler:(void (^)(UIAlertAction *action))handler {
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:style handler:handler];
    [self addAction:action];
    return action;
}

@end
