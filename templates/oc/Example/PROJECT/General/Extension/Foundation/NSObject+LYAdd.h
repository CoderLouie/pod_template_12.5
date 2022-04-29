//
//  NSObject+LYAdd.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Then)

- (instancetype)yy_then:(void (^)(id obj))block NS_SWIFT_UNAVAILABLE("");
+ (instancetype)yy_then:(void (^)(id obj))block NS_SWIFT_UNAVAILABLE("");

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
