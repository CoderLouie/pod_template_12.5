//
//  NSObject+Then.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Then)

+ (instancetype)instantiate:(void (^)(id me))work;

- (instancetype)then:(void (^)(id me))work; 

@end
 

@interface NSObject (LYAdd)
 
// MARK: - Notify
/// 订阅通知
- (void)subscribeNotificationWithName:(NSString *)name
                           usingBlock:(void (^)(NSNotification *notify))block;
/// 取消订阅通知
- (void)unsubscribeNotificationWithName:(NSString *)name;
/// 取消订阅过的所有通知
- (void)unsubscribeAllNotifications;
 
// MARK: - GCD
- (void)doInBackground:(void (^)(void))work;
- (void)doInForeground:(void (^)(void))work;
- (void)doInForeground:(void (^)(void))work
            afterDelay:(NSTimeInterval)interval;

- (id)performBlock:(void (^)(void))block
        afterDelay:(NSTimeInterval)interval;
- (id)performBlock:(void (^)(id arg))block
        withObject:(id)anObject
        afterDelay:(NSTimeInterval)interval;
- (void)cancelBlock:(id)block;
@end
NS_ASSUME_NONNULL_END
