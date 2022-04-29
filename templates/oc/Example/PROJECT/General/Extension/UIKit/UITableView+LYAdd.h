//
//  UITableView+LYAdd.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import <UIKit/UIKit.h>

@interface UITableView (LYAdd)

/// 注册重用Cell，重用标识默认为Cell类名
- (void)registerCellWithClass:(Class)cls;

/// 注册xib 重用标识符默认为cell类名
- (void)registerCellWithXib:(Class)cls;

/// 取出重用Cell，重用标识默认为Cell类名
- (__kindof UITableViewCell *)dequeueReusableCell:(Class)cellClass;
/// section 为0
- (__kindof UITableViewCell *)cellForRow:(NSInteger)row;

- (__kindof UITableViewHeaderFooterView *)dequeueResuseHeaderFooterView:(Class)cls;

- (NSArray<__kindof UITableViewCell *> *)allCells;
@end

