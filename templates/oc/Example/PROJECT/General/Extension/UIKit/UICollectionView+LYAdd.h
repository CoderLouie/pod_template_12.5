//
//  UICollectionView+LYAdd.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (LYAdd)

/// 注册重用Cell，重用标识默认为Cell类名
- (void)registerCellWithClass:(Class)cls;

/// 注册xib 重用标识符默认为cell类名
- (void)registerCellWithXib:(Class)cls;

- (void)registerHeaderXib:(Class)cls;
- (void)registerHeaderWithClass:(Class)cls;

- (void)registerFooterWithClass:(Class)cls;
- (void)registerFooterXib:(Class)cls;

/// 取出重用Cell，重用标识默认为Cell类名
- (__kindof UICollectionViewCell *)dequeueReusableCell:(Class)cls forIndexPath:(NSIndexPath *)indexPath;

/// 取出重用头部视图，重用标识默认为Cell类名
- (__kindof UICollectionReusableView *)dequeueReuseHeder:(Class)cls forIndexPath:(NSIndexPath *)indexPath;
/// 取出重用尾部视图，重用标识默认为Cell类名
- (__kindof UICollectionReusableView *)dequeueReuseFooter:(Class)cls forIndexPath:(NSIndexPath *)indexPath;

///
- (__kindof UICollectionViewCell *)cellForRow:(NSInteger)row;

@end
