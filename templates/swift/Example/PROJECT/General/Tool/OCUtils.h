//
//  OCUtils.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 用于 暴露 用OC/C/C++实现的功能 给swift调用

FOUNDATION_EXTERN double OCBenchmark(void (^block)(void)); 

@interface _ExceptionCatcher: NSObject

+ (BOOL)catchException:(__attribute__((noescape)) void(^)(void))tryBlock error:(__autoreleasing NSError **)error;

@end

NS_ASSUME_NONNULL_END
