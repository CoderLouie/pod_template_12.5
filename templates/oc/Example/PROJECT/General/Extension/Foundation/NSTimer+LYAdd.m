//
//  NSTimer+LYAdd.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import "NSTimer+LYAdd.h"

@implementation NSTimer (LYAdd)
- (void)pause {
    if (![self isValid]) return;
    [self setFireDate:[NSDate distantFuture]];
}

- (void)resume {
    if (![self isValid]) return;
    [self setFireDate:[NSDate date]];
}

- (void)resumeAfterDelay:(NSTimeInterval)interval {
    if (![self isValid]) return;
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}
@end
