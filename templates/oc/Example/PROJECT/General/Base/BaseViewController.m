//
//  BaseViewController.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
    [self setupViews];
}

- (void)setup {
    
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)setupViews {}

- (void)dealloc {
    CPDLogFunc;
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
