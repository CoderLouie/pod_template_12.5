//
//  ViewBuilder.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import "ViewBuilder.h"
#import <Masonry/Masonry.h>

@implementation ViewBuilder

+ (UIView *)separatorView {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = RGB(46, 52, 84);
    return line;
}
+ (UIView *)separatorViewWithSuperView:(UIView *)view {
    UIView *line = [self separatorView];
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    return line;
}

+ (UIImageView *)rightArrowImageView {
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.image = [UIImage imageNamed:@"icon_more_settings"];
    imgView.size = CGSizeMake(13, 13);
    return imgView;
}

+ (UILabel *)labelWithFontSize:(CGFloat)size {
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:size];
    return label;
}
+ (UILabel *)label18 {
    return [ViewBuilder labelWithFontSize:18];
}
+ (UILabel *)label14 {
    return [ViewBuilder labelWithFontSize:14];
}
+ (UILabel *)label12 {
    return [ViewBuilder labelWithFontSize:12];
}

@end
