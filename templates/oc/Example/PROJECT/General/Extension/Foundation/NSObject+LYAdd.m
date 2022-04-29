//
//  NSObject+LYAdd.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import "NSObject+LYAdd.h"


@implementation NSObject (Then)

- (instancetype)yy_then:(void (^)(id _Nonnull))block {
    block(self);
    return self;
}
+ (instancetype)yy_then:(void (^)(id obj))block {
    return [[self new] yy_then:block];
}

@end

static inline dispatch_time_t dTimeDelay(NSTimeInterval time) {
    int64_t delta = (int64_t)(NSEC_PER_SEC * time);
    return dispatch_time(DISPATCH_TIME_NOW, delta);
}

@interface _LYNotifyBlockTarget : NSObject
@property (nonatomic, copy) void(^block)(NSNotification *notify);
- (instancetype)initWithBlock:(void(^)(NSNotification *notify))block;
@end

@implementation _LYNotifyBlockTarget
- (instancetype)initWithBlock:(void (^)(NSNotification *))block {
    self = [super init];
    if (!self) return nil;
    self.block = block;
    return self;
}
- (void)receiveNotification:(NSNotification *)notify {
    if (!self.block) return;
    self.block(notify);
}
@end


#import <objc/runtime.h>
@implementation NSObject (LYAdd)

// MARK: - Notify
/// 订阅通知
- (void)subscribeNotificationWithName:(NSString *)name
                           usingBlock:(void (^)(NSNotification *notify))block {
    if (!name.length || !block) return;
    _LYNotifyBlockTarget *target = [[_LYNotifyBlockTarget alloc]initWithBlock:block];
    NSMutableDictionary *dic = [self _ly_notifyBlocksTargetsInfo];
    NSMutableArray *arr = dic[name];
    if (!arr) {
        arr = [NSMutableArray array];
        dic[name] = arr;
    }
    [arr addObject:target];
    [[NSNotificationCenter defaultCenter]addObserver:target selector:@selector(receiveNotification:) name:name object:nil];
}
/// 取消订阅通知
- (void)unsubscribeNotificationWithName:(NSString *)name {
    if (!name.length) return;
    NSMutableDictionary *dic = [self _ly_notifyBlocksTargetsInfo];
    NSMutableArray *arr = dic[name];
    for (id obj in arr) {
        [[NSNotificationCenter defaultCenter] removeObserver:obj forKeyPath:name];
    }
    [dic removeObjectForKey:name];
}
/// 取消订阅过的所有通知
- (void)unsubscribeAllNotifications {
    NSMutableDictionary *dic = [self _ly_notifyBlocksTargetsInfo];
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSArray *arr, BOOL *stop) {
        for (id obj in arr) {
            [[NSNotificationCenter defaultCenter] removeObserver:obj forKeyPath:key];
        }
    }];
    
    [dic removeAllObjects];
}
- (NSMutableDictionary *)_ly_notifyBlocksTargetsInfo {
    NSMutableDictionary *targets = objc_getAssociatedObject(self, _cmd);
    if (!targets) {
        targets = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}


- (void)doInBackground:(void (^)(void))work {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, work);
}
- (void)doInForeground:(void (^)(void))work {
    dispatch_async(dispatch_get_main_queue(), work);
}
- (void)doInForeground:(void (^)(void))work
            afterDelay:(NSTimeInterval)interval {
    dispatch_after(dTimeDelay(interval), dispatch_get_main_queue(), work);
}

- (id)performBlock:(void (^)(void))block
        afterDelay:(NSTimeInterval)interval {
    if (!block) return nil;
    
    __block BOOL cancelled = NO;
    
    void (^wrappedBlock)(BOOL) = ^(BOOL cancel) {
        if (cancel) {
            cancelled = YES; return;
        }
        if (!cancelled) block();
    };
    
    wrappedBlock = [wrappedBlock copy];
    
    dispatch_after(dTimeDelay(interval), dispatch_get_main_queue(), ^{  wrappedBlock(NO); });
    
    return wrappedBlock;
}
- (id)performBlock:(void (^)(id arg))block
        withObject:(id)anObject
        afterDelay:(NSTimeInterval)interval {
    if (!block) return nil;
    
    __block BOOL cancelled = NO;
    
    void (^wrappedBlock)(BOOL, id) = ^(BOOL cancel, id arg) {
        if (cancel) {
            cancelled = YES; return;
        }
        if (!cancelled) block(arg);
    };
    
    wrappedBlock = [wrappedBlock copy];
    
    dispatch_after(dTimeDelay(interval), dispatch_get_main_queue(), ^{  wrappedBlock(NO, anObject); });
    
    return wrappedBlock;
}
- (void)cancelBlock:(id)block {
    if (!block) return;
    void (^aWrappingBlock)(BOOL) = (void(^)(BOOL))block;
    aWrappingBlock(YES);
}
@end
