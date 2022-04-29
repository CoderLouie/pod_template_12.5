//
//  ViewBuilder.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewBuilder : NSObject

+ (UIView *)separatorView;

+ (UIView *)separatorViewWithSuperView:(UIView *)view;
/// 白色
+ (UILabel *)labelWithFontSize:(CGFloat)size;

+ (UIImageView *)rightArrowImageView;

+ (UILabel *)label18;
+ (UILabel *)label14;
+ (UILabel *)label12; 

@end

NS_ASSUME_NONNULL_END
