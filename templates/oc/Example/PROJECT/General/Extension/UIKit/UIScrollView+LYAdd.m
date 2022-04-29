//
//  UIScrollView+LYAdd.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import "UIScrollView+LYAdd.h"
 

@implementation UIScrollView (LYAdd)


- (CGFloat)insetT {
    return self.contentInset.top;
}
- (void)setInsetT:(CGFloat)insetT {
    UIEdgeInsets inset = self.contentInset;
    inset.top = insetT;
    self.contentInset = inset;
}
- (CGFloat)insetB {
    return self.contentInset.bottom;
}
- (void)setInsetB:(CGFloat)insetB {
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = insetB;
    self.contentInset = inset;
}
- (CGFloat)insetL {
    return self.contentInset.left;
}
- (void)setInsetL:(CGFloat)insetL {
    UIEdgeInsets inset = self.contentInset;
    inset.left = insetL;
    self.contentInset = inset;
}
- (CGFloat)insetR {
    return self.contentInset.right;
}
- (void)setInsetR:(CGFloat)insetR {
    UIEdgeInsets inset = self.contentInset;
    inset.right = insetR;
    self.contentInset = inset;
}

#pragma mark - contentOffset
- (CGFloat)offsetT {
    return self.contentOffset.y;
}
- (void)setOffsetT:(CGFloat)offsetT {
    CGPoint offset = self.contentOffset;
    offset.y = offsetT;
    [self setContentOffset:offset animated:YES];
}
- (CGFloat)offsetB {
    return self.offsetT + self.frame.size.height;
}
- (void)setOffsetB:(CGFloat)offsetB {
    self.offsetT = offsetB - self.frame.size.height;
}
- (CGFloat)offsetL {
    return self.contentOffset.x;
}
- (void)setOffsetL:(CGFloat)offsetL {
    CGPoint offset = self.contentOffset;
    offset.x = offsetL;
    [self setContentOffset:offset animated:YES];
}
- (CGFloat)offsetR {
    return self.offsetL + self.frame.size.width;
}
- (void)setOffsetR:(CGFloat)offsetR {
    self.offsetL = offsetR - self.frame.size.width;
}


#pragma mark - contentSize
- (CGFloat)contentW {
    return self.contentSize.width;
}
- (void)setContentW:(CGFloat)contentW {
    CGSize size = self.contentSize;
    size.width = contentW;
    self.contentSize = size;
}
- (CGFloat)contentH {
    return self.contentSize.height;
}
- (void)setContentH:(CGFloat)contentH {
    CGSize size = self.contentSize;
    size.height = contentH;
    self.contentSize = size;
}
  

/// 可见宽度
- (CGFloat)visibleW {
    return self.contentW + self.insetL + self.insetR;
}

/// 可见高度
- (CGFloat)visibleH {
    return self.contentH + self.insetT + self.insetB;
}

- (CGFloat)offsetMinT {
    return -self.insetT;
}
- (CGFloat)offsetMaxT {
    return self.offsetMaxB - self.bounds.size.height;
}
- (CGFloat)offsetMinL {
    return -self.insetL;
}
- (CGFloat)offsetMaxL {
    return self.offsetMaxR - self.bounds.size.width;
}
- (CGFloat)offsetMinB {
    return self.offsetMinT + self.bounds.size.height;
}
- (CGFloat)offsetMaxB {
    return self.contentSize.height + self.insetB;
}
- (CGFloat)offsetMinR {
    return self.offsetMinL + self.bounds.size.width;
}
- (CGFloat)offsetMaxR {
    return self.contentSize.width + self.insetR;
}

/// 是否在最顶端
- (BOOL)atTopPosition {
    return self.offsetT == self.offsetMinT;
}
/// 是否在最底部
- (BOOL)atBottomPosition {
    return self.offsetT == self.offsetMaxT;
}
/// 是否在最左边
- (BOOL)atLeftPosition {
    return self.offsetL == self.offsetMinL;
}

/// 是否在最右边
- (BOOL)atRightPosition {
    return self.offsetL == self.offsetMaxL;
}

/// 水平滚动一段距离
- (void)horizontalRollingWithDistance:(CGFloat)distance animated:(BOOL)animated {
    CGPoint offset = self.contentOffset;
    offset.x += distance;
    [self setContentOffset:offset animated:animated];
}
/// 竖直滚动一段距离
- (void)verticalRollingWithDistance:(CGFloat)distance animated:(BOOL)animated {
    CGPoint offset = self.contentOffset;
    offset.y += distance;
    [self setContentOffset:offset animated:animated];
}

- (NSUInteger)verticalPageIndex {
    CGFloat height = self.bounds.size.height;
    return (self.offsetT + height * 0.5) / height;
}
- (NSUInteger)horizontalPageIndex {
    CGFloat width = self.bounds.size.width;
    return (self.offsetL + width * 0.5) / width;
}
/// 水平滚动到第几页
- (void)horizontalRollingToPageIndex:(NSUInteger)index animated:(BOOL)animated {
    CGFloat width = self.bounds.size.width;
    [self setContentOffset:CGPointMake(0.0f, width * index) animated:animated];
}
/// 竖直滚动到第几页
- (void)verticalRollingToPageIndex:(NSUInteger)index animated:(BOOL)animated {
    CGFloat height = self.bounds.size.height;
    [self setContentOffset:CGPointMake(0.0f, height * index) animated:animated];
}

- (LYScrollDirection)scrollDirection {
    LYScrollDirection direction = LYScrollDirectionUnknown;
    CGPoint point = [self.panGestureRecognizer translationInView:self.superview];
    if (point.y > 0.0f) {
        direction |= LYScrollDirectionUp;
    }
    if (point.y < 0.0f) {
        direction |= LYScrollDirectionDown;
    }
    if (point.x < 0.0f) {
        direction |= LYScrollDirectionLeft;
    }
    if (point.x > 0.0f) {
        direction |= LYScrollDirectionRight;
    }
    
    return direction;
}
@end
 
