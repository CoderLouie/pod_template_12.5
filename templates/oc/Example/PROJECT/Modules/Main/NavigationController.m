//
//  NavigationController.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "NavigationController.h"

@implementation UIViewController (NavigationControllerAdded)

- (void)backNavigationItemDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

@interface NavigationController ()
<UINavigationControllerDelegate>
/// 手势代理
@property (nonatomic, strong)id popDelegate;

@end

@implementation NavigationController

+ (void)initialize {
    
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _popDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"navigationbar_back_withtext"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"navigationbar_back_withtext_highlighted"] forState:UIControlStateHighlighted];
        [btn sizeToFit];
        
        [btn addTarget:viewController action:@selector(backNavigationItemDidClick) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    if ([self.viewControllers indexOfObject:viewController] == 0) {
        //根控制器
        //还原滑动返回手势代理
        self.interactivePopGestureRecognizer.delegate = _popDelegate;
    } else {
        //实现滑动返回功能
        //清空滑动返回手势代理，就能实现滑动返回功能
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
