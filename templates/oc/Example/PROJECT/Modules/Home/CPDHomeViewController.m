//
//  CPDHomeViewController.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "CPDHomeViewController.h"

@interface CPDHomeViewController ()

@end

@implementation CPDHomeViewController

- (void)setupViews {
    [super setupViews];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 70, 30)];
    label.text = TR(@"home_item_photo");
    [self.view addSubview:label];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
#if DEVELOPMENT
    NSLog(@"DEVELOPMENT");
#else
    NSLog(@"APPSTORE");
#endif
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
