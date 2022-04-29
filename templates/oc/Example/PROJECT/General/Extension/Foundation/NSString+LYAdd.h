//
//  NSString+LYAdd.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (LYAdd)

/// 获取字符串(或汉字)首字母
- (NSString *)firstCharacter;

/// 按顺序保留数字和.
- (NSString *)retainOfNumbers;

/// 保留 `setString` 中出现的字符
- (NSString *)retainOccurrencesInSet:(NSString *)setString;

/// 生成到指定字符的字符串
- (nullable NSString *)subStringToString:(NSString *)str;
/// 生成从指定字符开始的字符串
- (nullable NSString *)subStringFromString:(NSString *)str;
/// 移除str
- (NSString *)removeString:(NSString *)str;

- (NSString *)substringFromString:(NSString *)fromString toString:(NSString *)toString;

- (void)enumerateSequenceCharacterUsingBlock:(void (^)(NSString *string, NSRange range, BOOL *stop))block;



/// 表情编码
- (NSString *)stringByEmojiEncode;
/// 表情解码
- (NSString *)stringByEmojiDecode;


- (BOOL)matchesRegular:(NSString *)regular;
/// 邮箱验证
- (BOOL)isEmail;

- (BOOL)containsEmoji;
- (BOOL)containsSudokuNumber;

- (int)wordsCount;

/*
 "N2.7R0.7T0.4H0.1"
 @{
 @"A":@"Apollo",
 @"B":@"Build",
 @"H":@"Heartrate",
 @"K":@"Freescale",
 @"N":@"Nordic",
 @"R":@"Picture",
 @"T":@"TouchPanel",
 @"V":@"Version"
 }
 ---->
 {
 Heartrate = "0.1";
 Nordic = "2.7";
 Picture = "0.7";
 TouchPanel = "0.4";
 }
 */
- (NSDictionary *)splitByDictionary:(NSDictionary<NSString *, NSString *> *)info;
@end

NS_ASSUME_NONNULL_END
