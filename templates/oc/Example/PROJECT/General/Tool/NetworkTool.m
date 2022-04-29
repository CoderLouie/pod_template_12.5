//
//  NetworkTool.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import "NetworkTool.h"

#import <AFNetworking/AFNetworking.h>

@implementation NetworkTool {
    
}

+ (AFHTTPSessionManager *)defaultManager {
    static AFHTTPSessionManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [AFHTTPSessionManager manager];
//        NSSet *set = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/html", @"text/json", nil];
//        _manager.responseSerializer.acceptableContentTypes = set;
        _manager.requestSerializer.timeoutInterval = 30.f;
    });
    return _manager;
}

+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSDictionary * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[self defaultManager] GET:URLString parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        !success ?: success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failure ?: failure(error);
    }];
}

+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSDictionary * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[self defaultManager] POST:URLString parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        !success ?: success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failure ?: failure(error);
    }];
}

static NSString *kToken = nil;
+ (void)setToken:(NSString *)token {
    kToken = [token copy];
}
+ (void)requestWithURL:(NSString *)URLString
            parameters:(id)parameters
               success:(void (^)(NSDictionary * _Nonnull))success
               failure:(void (^)(NSError * _Nonnull))failure {
    AFHTTPSessionManager *mgr = [self defaultManager];
    
    if (kToken.length) {
        NSArray *cmps = [kToken componentsSeparatedByString:@"."];
        if (cmps.count < 3) {
            NSError *error = [self tokenIsExpired];
            !failure ?: failure(error);
            return;
        }
        NSString *tokenBase64 = cmps[1];
        int left = 4 - (tokenBase64.length % 4);
        if (left < 4) {
            NSMutableString *tail = [NSMutableString string];
            for (int i = 0; i < left; i++) {
                [tail appendString:@"="];
            }
            tokenBase64 = [tokenBase64 stringByAppendingString:tail];
        }
        NSData *data = [[NSData alloc]initWithBase64EncodedString:tokenBase64 options:0];
        NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if (!string.length) {
            NSError *error = [self tokenIsExpired];
            !failure ?: failure(error);
            return;
        }
        NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        NSTimeInterval exp = [dict[@"exp"] doubleValue];
        NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
        if (exp - timestamp < 1 * 60 * 60) {
            NSError *error = [self tokenIsExpired];
            !failure ?: failure(error);
            return;
        }
        [[mgr requestSerializer] setValue:kToken forHTTPHeaderField:@"meetingToken"];
    }
    
    [mgr POST:URLString parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable data) {
        int errorCode = [data[@"errorcode"] intValue];
        if (errorCode == 0) {
            !success ?: success(data[@"content"]);
        } else {
            !failure ?: failure([NSError errorWithDomain:NSURLErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey: data[@"msg"]}]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failure ?: failure(error);
    }];
}


+ (NSError *)tokenIsExpired {
    int code = 401;
    NSString *message = @"登录信息已过期";
//    [[NSNotificationCenter defaultCenter] postNotificationName:ACDidDisconnectNotification object:result userInfo:@{@"result": result}];
    kToken = nil;
    return [NSError errorWithDomain:NSURLErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey: message}];
}
@end
