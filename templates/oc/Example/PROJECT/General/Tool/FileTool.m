//
//  FileTool.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import "FileTool.h"

@implementation FileTool

+ (BOOL)createDirectoryAtPath:(NSString *)path error:(NSErrorParam)error {
    return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                     withIntermediateDirectories:YES
                                                      attributes:nil
                                                           error:error];
}

+ (BOOL)removeDirectoryAtPath:(NSString *)trashPath
                      progess:(void (^)(NSString * _Nonnull, NSError * _Nullable, BOOL * _Nonnull))progressBlock {
     
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *directoryContents = [manager contentsOfDirectoryAtPath:trashPath error:NULL];
    BOOL res = YES;
    BOOL stop = NO;
    for (NSString *path in directoryContents) {
        NSString *fullPath = [trashPath stringByAppendingPathComponent:path];
        NSError *error = nil;
        res &= [manager removeItemAtPath:fullPath error:&error];
        !progressBlock ?: progressBlock(path, error, &stop);
        if (stop) break;
    }
    return res;
}
+ (BOOL)removeFileAtPath:(NSString *)path error:(NSErrorParam)error {
    return [[NSFileManager defaultManager] removeItemAtPath:path error:error];
}

+ (BOOL)moveFileAtPath:(NSString *)srcPath
                toPath:(NSString *)dstPath
                 error:(NSErrorParam)error {
    return [[NSFileManager defaultManager] moveItemAtPath:srcPath toPath:dstPath error:error];
}

+ (BOOL)writeData:(NSData *)data toFilePath:(NSString *)path {
    return [data writeToFile:path atomically:NO];
}
+ (NSData *)readDataAtPath:(NSString *)path {
    if (!path.length) return nil;
    
    return [NSData dataWithContentsOfFile:path];
}

+ (int64_t)diskSpaceFree {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}
@end
