//
//  UIScrollView+LYAdd.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "UIControl+LYAdd.h"
#import <objc/runtime.h>

@interface UIControl (_LYAdd)
@property (nonatomic, assign) BOOL ignoreEvent;
@end
@implementation UIControl (_LYAdd)
- (BOOL)ignoreEvent {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setIgnoreEvent:(BOOL)ignoreEvent {
    objc_setAssociatedObject(self, @selector(ignoreEvent), @(ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

@implementation UIControl (LYAdd)

+ (void)load {
//    SEL selA = @selector(sendAction:to:forEvent:);
//    SEL selB = @selector(mySendAction:to:forEvent:);
//    Method methodA =  class_getInstanceMethod(self,selA);
//    Method methodB = class_getInstanceMethod(self, selB);
//    BOOL isAdd = class_addMethod(self, selA, method_getImplementation(methodB), method_getTypeEncoding(methodB));
//    if (isAdd) {
//        class_replaceMethod(self, selB, method_getImplementation(methodA), method_getTypeEncoding(methodA));
//    } else {
//        method_exchangeImplementations(methodA, methodB);
//    }
}


- (void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (self.ignoreEvent == YES) return;
    NSTimeInterval interval = self.acceptEventInterval;
    if (interval > 0) {
        self.ignoreEvent = YES;
        [self performSelector:@selector(resetState)
                   withObject:nil
                   afterDelay:interval];
    }
    [self mySendAction:action to:target forEvent:event];
}

- (NSTimeInterval)acceptEventInterval {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}
- (void)setAcceptEventInterval:(NSTimeInterval)interval {
    if (interval <= 0) return;
    objc_setAssociatedObject(self, @selector(acceptEventInterval), @(interval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)resetState {
    [self setIgnoreEvent:NO];
}

@end


@implementation UIButton (LYAdd)
- (void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = [NSValue value:&hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, @selector(hitTestEdgeInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, _cmd);
    if (!value) return UIEdgeInsetsZero;
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    [value getValue:&edgeInsets];
    return edgeInsets;
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    UIEdgeInsets edgeInsets = self.hitTestEdgeInsets;
    //如果 button 边界值无变化  失效 隐藏 或者透明 直接返回
    if (UIEdgeInsetsEqualToEdgeInsets(edgeInsets, UIEdgeInsetsZero) ||
        !self.enabled ||
        self.hidden ||
        self.alpha < 0.01 ) {
        return [super pointInside:point withEvent:event];
    } else {
        CGRect relativeFrame = self.bounds;
        CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, edgeInsets);
        return CGRectContainsPoint(hitFrame, point);
    }
}


- (void)cutdown:(NSUInteger)interval
       progress:(void (^)(UIButton *button, NSUInteger left))progressBlock
            end:(void (^)(UIButton *button))endBlock {
    __block NSInteger timeout = interval; //倒计时时间
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0) {
            //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            !endBlock ?: endBlock(self);
        } else {
            !progressBlock ?: progressBlock(self, timeout);
            timeout--;
        }
    });
     
    dispatch_resume(_timer);
}
@end
