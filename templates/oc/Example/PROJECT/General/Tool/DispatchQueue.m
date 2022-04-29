//
//  DispatchQueue.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "DispatchQueue.h"

typedef NS_ENUM(NSInteger, DispatchQueueType) {
    DispatchQueueTypeMain = 0,
    DispatchQueueTypeGlobal,
    DispatchQueueTypeCustomSerial,
    DispatchQueueTypeCustomConcurrent,
};
 


static inline bool dispatch_queue_current_is(dispatch_queue_t queue) {
    static void * key = &key;
    dispatch_queue_set_specific(queue, key, key, NULL);
    void *flag = dispatch_get_specific(key);
    dispatch_queue_set_specific(queue, key, NULL, NULL);
    return flag == key;
}

@implementation DispatchQueue {
    dispatch_queue_t _queue;
    BOOL _suspended;
    DispatchQueueType _queueType;
}

+ (instancetype)mainQueue {
    return [self instanceWithQueue:dispatch_get_main_queue() type:DispatchQueueTypeMain];
}
+ (instancetype)highGlobalQueue {
    return [self globalWithIdentifier:DISPATCH_QUEUE_PRIORITY_HIGH];
}
+ (instancetype)globalQueue {
    return [self globalWithIdentifier:DISPATCH_QUEUE_PRIORITY_DEFAULT];
}
+ (instancetype)lowGlobalQueue {
    return [self globalWithIdentifier:DISPATCH_QUEUE_PRIORITY_LOW];
}
+ (instancetype)backgroundGlobalQueue {
    return [self globalWithIdentifier:DISPATCH_QUEUE_PRIORITY_DEFAULT];
}
+ (instancetype)concurrentQueueWithLabel:(NSString *)label {
    return [self instanceWithQueue:dispatch_queue_create(label.UTF8String, DISPATCH_QUEUE_CONCURRENT) type:DispatchQueueTypeCustomConcurrent];
}
+ (instancetype)serialQueueWithLabel:(NSString *)label {
    return [self instanceWithQueue:dispatch_queue_create(label.UTF8String, DISPATCH_QUEUE_SERIAL) type:DispatchQueueTypeCustomSerial];
}
+ (instancetype)globalWithIdentifier:(long)identifier {
    return [self instanceWithQueue:dispatch_get_global_queue(identifier, 0) type:DispatchQueueTypeGlobal];
}
+ (instancetype)instanceWithQueue:(dispatch_queue_t)queue type:(DispatchQueueType)type {
    return [[[self class] alloc] initWithQueue:queue type:type];
}
- (instancetype)initWithQueue:(dispatch_queue_t)queue type:(DispatchQueueType)type {
    self = [super init];
    if (!self) return self;
    _queue = queue;
    _queueType = type;
    return self;
}

- (void)async:(void (^)(void))block {
    dispatch_async(_queue, block);
}
- (id)sync:(id  _Nullable (^)(void))block {
    if (dispatch_queue_current_is(_queue)) {
        return block();
    } else {
        __block id val = nil;
        dispatch_sync(_queue, ^{
            val = block();
        });
        return val;
    }
}
- (void)barrierAsync:(void (^)(void))block {
    NSAssert([self isConcurrent], @"在串行队列上使用此方法无意义");
    if (_queueType == DispatchQueueTypeGlobal) {
        NSAssert(false, @"在全局队列上使用此方法无意义");
    }
    dispatch_barrier_async(_queue, block);
}
- (id)barrierSync:(id  _Nullable (^)(void))block {
    NSAssert([self isConcurrent], @"在串行队列上使用此方法无意义");
    if (_queueType == DispatchQueueTypeGlobal) {
        NSAssert(false, @"在全局队列上使用此方法无意义");
    }
    __block id val = nil;
    dispatch_barrier_sync(_queue, ^{
        val = block();
    });
    return val;
}

- (void)delay:(NSTimeInterval)seconds work:(void (^)(void))work {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), _queue, ^{
        work();
    });
} 

- (void)iterate:(size_t)count work:(void (^)(size_t index))work {
    NSAssert([self isConcurrent], @"在串行队列上使用此方法无意义");
    dispatch_apply(count, _queue, work);
}

- (void)suspend {
    if (self.suspended) return;
    self.suspended = YES;
    dispatch_suspend(_queue);
}
- (void)resume {
    if (!self.suspended) return;
    self.suspended = NO;
    dispatch_resume(_queue);
}
- (BOOL)suspended {
    __block BOOL suspended = NO;
    dispatch_sync(_queue, ^{
        suspended = _suspended;
    });
    return suspended;
}
- (void)setSuspended:(BOOL)suspended {
    dispatch_sync(_queue, ^{
        _suspended = suspended;
    });
}
- (BOOL)isConcurrent {
    return (_queueType == DispatchQueueTypeCustomConcurrent ||
            _queueType == DispatchQueueTypeGlobal);
}
@end
