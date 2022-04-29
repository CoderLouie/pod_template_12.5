//
//  BaseView.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseView : UIView

- (void)setup; 

@end

@interface BaseControl : UIControl

- (void)setup;

@end

@interface BaseTableCell : UITableViewCell

- (void)setup;

@end

@interface BaseCollectionCell : UICollectionViewCell

- (void)setup;

@end

NS_ASSUME_NONNULL_END
