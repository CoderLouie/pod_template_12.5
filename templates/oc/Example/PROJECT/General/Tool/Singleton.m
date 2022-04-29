//
//  Singleton.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import "Singleton.h"

 
@implementation Singleton
 
+ (instancetype)shared {
    static Singleton *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[super allocWithZone:NULL] init];
    });
    return singleton;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self shared];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    return self;
}
@end


