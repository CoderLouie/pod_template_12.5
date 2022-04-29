//
//  UIScrollView+LYAdd.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import <UIKit/UIKit.h> 

/// 滚动方向
typedef NS_OPTIONS(NSUInteger, LYScrollDirection) {
    LYScrollDirectionUnknown = 0, ///< 未知
    LYScrollDirectionUp = 1 << 0, ///< 向上
    LYScrollDirectionDown = 1 << 1, ///< 向下
    LYScrollDirectionLeft = 1 << 2, ///< 向左
    LYScrollDirectionRight = 1 << 3, ///< 向右
};

@interface UIScrollView (LYAdd) 

/// contetInset.top
@property (nonatomic, assign)CGFloat insetT;
/// contetInset.bottom
@property (nonatomic, assign)CGFloat insetB;
/// contetInset.left
@property (nonatomic, assign)CGFloat insetL;
/// contetInset.right
@property (nonatomic, assign)CGFloat insetR;

/// contentOffset.y
@property (nonatomic, assign)CGFloat offsetT;
/// contentOffset.y + self.height
@property (nonatomic, assign)CGFloat offsetB;

/// contentOffset.x
@property (nonatomic, assign)CGFloat offsetL;
/// contentOffset.x + self.width
@property (nonatomic, assign)CGFloat offsetR;

/// contentSize.width
@property (nonatomic, assign)CGFloat contentW;
/// contentSize.height
@property (nonatomic, assign)CGFloat contentH;
  

/// 可见宽度
- (CGFloat)visibleW;

/// 可见高度
- (CGFloat)visibleH;

- (CGFloat)offsetMinT;
- (CGFloat)offsetMaxT;
- (CGFloat)offsetMinL;
- (CGFloat)offsetMaxL;
- (CGFloat)offsetMinB;
- (CGFloat)offsetMaxB;
- (CGFloat)offsetMinR;
- (CGFloat)offsetMaxR;

/// 水平滚动一段距离
- (void)horizontalRollingWithDistance:(CGFloat)distance animated:(BOOL)animated;
/// 竖直滚动一段距离
- (void)verticalRollingWithDistance:(CGFloat)distance animated:(BOOL)animated;


- (NSUInteger)verticalPageIndex;
- (NSUInteger)horizontalPageIndex;
/// 水平滚动到第几页
- (void)horizontalRollingToPageIndex:(NSUInteger)index animated:(BOOL)animated;
/// 竖直滚动到第几页
- (void)verticalRollingToPageIndex:(NSUInteger)index animated:(BOOL)animated;
/// 滚动方向
- (LYScrollDirection)scrollDirection;

@end

 

 
