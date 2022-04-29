//
//  Singleton.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Singleton : NSObject <NSCopying, NSMutableCopying>

+ (instancetype)shared;

- (instancetype)init OBJC_UNAVAILABLE("use '+ shared' instead");
+ (instancetype)new OBJC_UNAVAILABLE("use '+ shared' instead");

@end
 

NS_ASSUME_NONNULL_END
