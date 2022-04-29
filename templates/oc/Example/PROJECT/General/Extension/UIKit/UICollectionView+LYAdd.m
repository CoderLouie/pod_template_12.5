//
//  UICollectionView+LYAdd.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "UICollectionView+LYAdd.h"
 

@implementation UICollectionView (LYAdd)

/// 注册重用Cell，重用标识默认为Cell类名
- (void)registerCellWithClass:(Class)cls
{
    [self registerClass:cls forCellWithReuseIdentifier:NSStringFromClass(cls)];
}

/// 注册xib 重用标识符默认为cell类名
- (void)registerCellWithXib:(Class)cls
{
    NSString *reuseId = NSStringFromClass([cls class]);
    [self registerNib:[UINib nibWithNibName:reuseId bundle:nil] forCellWithReuseIdentifier:reuseId];
}

- (void)registerHeaderXib:(Class)cls
{
    NSString *reuseId = NSStringFromClass([cls class]);
    [self registerNib:[UINib nibWithNibName:reuseId bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseId];
}
- (void)registerHeaderWithClass:(Class)cls
{
    [self registerClass:cls forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([cls class])];
}
- (void)registerFooterWithClass:(Class)cls
{
    [self registerClass:[cls class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([cls class])];
}
- (void)registerFooterXib:(Class)cls
{
    NSString *reuseId = NSStringFromClass([cls class]);
    [self registerNib:[UINib nibWithNibName:reuseId bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseId];
}

/// 取出重用Cell，重用标识默认为Cell类名
- (__kindof UICollectionViewCell *)dequeueReusableCell:(Class)cls forIndexPath:(NSIndexPath *)indexPath
{
    return [self dequeueReusableCellWithReuseIdentifier:NSStringFromClass(cls) forIndexPath:indexPath];
}

- (__kindof UICollectionReusableView *)dequeueReuseHeder:(Class)cls forIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([cls class]) forIndexPath:indexPath];
}
- (__kindof UICollectionReusableView *)dequeueReuseFooter:(Class)cls forIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([cls class]) forIndexPath:indexPath];
}

- (UICollectionViewCell *)cellForRow:(NSInteger)row
{
    return [self cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
}

@end
