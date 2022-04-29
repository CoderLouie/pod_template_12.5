//
//  DispatchQueue.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DispatchQueue : NSObject

+ (instancetype)mainQueue;
+ (instancetype)highGlobalQueue;
+ (instancetype)globalQueue;
+ (instancetype)lowGlobalQueue;
+ (instancetype)backgroundGlobalQueue;

+ (instancetype)concurrentQueueWithLabel:(nullable NSString *)label;
+ (instancetype)serialQueueWithLabel:(nullable NSString *)label;

- (void)suspend;
- (void)resume;

- (void)async:(void (^)(void))block;
- (nullable id)sync:(id _Nullable (^)(void))block;
- (void)barrierAsync:(void (^)(void))block;
- (nullable id)barrierSync:(id _Nullable (^)(void))block;

- (void)delay:(NSTimeInterval)seconds work:(void (^)(void))work;

- (void)iterate:(size_t)count work:(void (^)(size_t index))work;

@end

NS_ASSUME_NONNULL_END
