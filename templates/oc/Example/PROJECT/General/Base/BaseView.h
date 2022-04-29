//
//  BaseView.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseView : UIView

- (void)setup; 

@end

@interface BaseTableCell : UITableViewCell

- (void)setup;

@end

@interface BaseCollectionCell : UICollectionViewCell

- (void)setup;

@end

NS_ASSUME_NONNULL_END
