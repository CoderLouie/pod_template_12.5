//
//  FileTool.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSError *__autoreleasing __nullable * __nullable NSErrorParam;

@interface FileTool : NSObject

+ (BOOL)createDirectoryAtPath:(NSString *)path error:(NSErrorParam)error;

+ (BOOL)removeDirectoryAtPath:(NSString *)trashPath
                      progess:(nullable void(^)(NSString *path, NSError * _Nullable error, BOOL *stop))progressBlock;

+ (BOOL)removeFileAtPath:(NSString *)path error:(NSErrorParam)error;

+ (BOOL)moveFileAtPath:(NSString *)srcPath
                toPath:(NSString *)dstPath
                 error:(NSErrorParam)error;

+ (BOOL)writeData:(NSData *)data toFilePath:(NSString *)path;

+ (nullable NSData *)readDataAtPath:(NSString *)path;

+ (int64_t)diskSpaceFree;

@end

NS_ASSUME_NONNULL_END
