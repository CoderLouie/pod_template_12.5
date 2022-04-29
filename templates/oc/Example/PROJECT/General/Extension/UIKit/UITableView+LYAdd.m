//
//  UITableView+LYAdd.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import "UITableView+LYAdd.h"

@implementation UITableView (LYAdd)

/// 注册重用Cell，重用标识默认为Cell类名
- (void)registerCellWithClass:(Class)cls
{
    if (!cls)
    {
        cls = [UITableViewCell class];
    }
    [self registerClass:cls forCellReuseIdentifier:NSStringFromClass(cls)];
}

/// 注册xib 重用标识符默认为cell类名
- (void)registerCellWithXib:(Class)cls
{
    NSParameterAssert(cls != NULL);
    NSString *clsString = NSStringFromClass([cls class]);
    [self registerNib:[UINib nibWithNibName:clsString bundle:nil] forCellReuseIdentifier:clsString];
}

/// 取出重用Cell，重用标识默认为Cell类名
- (__kindof UITableViewCell *)dequeueReusableCell:(Class)cls
{
    NSString *resuseID = NSStringFromClass(cls);
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:resuseID];
    if (!cell)
    {
        cell = [[cls alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:resuseID];
    }
    return cell;
}

- (__kindof UITableViewHeaderFooterView *)dequeueResuseHeaderFooterView:(Class)cls {
    if (!cls) cls = [UITableViewHeaderFooterView class];
    NSString *reuseId = NSStringFromClass([cls class]);
    UITableViewHeaderFooterView *view = [self dequeueReusableHeaderFooterViewWithIdentifier:reuseId];
    if (!view)
    {
        view = [[cls alloc]initWithReuseIdentifier:reuseId];
    }
    return view;
}

- (__kindof UITableViewCell *)cellForRow:(NSInteger)row
{
    return [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
}
- (NSArray<UITableViewCell *> *)allCells {
    NSMutableArray *cells = [NSMutableArray array];
    NSInteger sectoins = [self numberOfSections];
    for (NSInteger sectoin = 0; sectoin < sectoins; sectoin++) {
        NSInteger rows = [self numberOfRowsInSection:sectoin];
        for (NSInteger row = 0; row < rows; row++) {
            UITableViewCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:sectoin]];
            if (cell) [cells addObject:cell];
        }
    }
    return  cells;
}
@end
