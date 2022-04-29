//
//  TabBarController.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import "TabBarController.h"

#import <UIColor+YYAdd.h>

#import "NavigationController.h"

#import "CPDHomeViewController.h"
#import "CPDProfileViewController.h"

@implementation UIViewController (TabBarControllerAdded)

- (void)tabbarItemDidSelect {}
- (void)tabbarItemDidDeselect {}
- (void)tabbarItemDidSelectAgain {}

@end

@interface TabBarController ()
<UITabBarControllerDelegate>

@property (nonatomic, unsafe_unretained) UIViewController *lastSelectedVC;
@property (nonatomic, assign) NSTimeInterval lastSelectedTimestamp;
@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    [self addChildVCWithClass:[CPDHomeViewController class] iconName:@"tabbar_home" title:@"首页"];
    [self addChildVCWithClass:[CPDProfileViewController class] iconName:@"tabbar_profile" title:@"我"];
}


- (__kindof UIViewController *)addChildVCWithClass:(Class)cls iconName:(NSString *)iconName title:(NSString *)title {
    UIViewController *vc = [cls new];
    vc.tabBarItem.image = [UIImage imageNamed:iconName];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:[iconName stringByAppendingString:@"_selected"]];
    UIFont *font = [UIFont systemFontOfSize:11];
    
    [vc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor colorWithHexString:@"0x6D6D6D"]} forState:UIControlStateNormal];
    [vc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor colorWithHexString:@"0x696969"]} forState:UIControlStateSelected];
    
    vc.title = title;
    [self addChildViewController:[[NavigationController alloc] initWithRootViewController:vc]];
    return vc;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    UIViewController *(^findOp)(void) = ^{
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)viewController;
            return nav.topViewController;
        }
        return viewController;
    };
    UIViewController *topVC = findOp();
    NSTimeInterval now = [NSDate date].timeIntervalSinceReferenceDate;
    if (_lastSelectedVC == topVC) {
        if (now - _lastSelectedTimestamp < 0.5) {
            [topVC tabbarItemDidSelectAgain];
        }
    } else {
        [topVC tabbarItemDidSelect];
        [_lastSelectedVC tabbarItemDidDeselect];
    }
    _lastSelectedVC = topVC;
    _lastSelectedTimestamp = now;
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
