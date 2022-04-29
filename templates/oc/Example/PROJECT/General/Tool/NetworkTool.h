//
//  NetworkTool.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkTool : NSObject

+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(NSDictionary *data))success
    failure:(void (^)(NSError *error))failure;


+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(NSDictionary *data))success
     failure:(void (^)(NSError *error))failure;

+ (void)setToken:(NSString *)token;

+ (void)requestWithURL:(NSString *)URLString
            parameters:(id)parameters
               success:(void (^)(NSDictionary *data))success
               failure:(void (^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
