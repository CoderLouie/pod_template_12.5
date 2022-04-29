//
//  NSTimer+LYAdd.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (LYAdd)
/// 暂停
- (void)pause;

/// 继续
- (void)resume;

/// 一段时间间隔后继续
- (void)resumeAfterDelay:(NSTimeInterval)interval;
@end

NS_ASSUME_NONNULL_END
