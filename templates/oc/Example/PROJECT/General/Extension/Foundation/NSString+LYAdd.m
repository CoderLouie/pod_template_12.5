//
//  NSString+LYAdd.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "NSString+LYAdd.h" 

@implementation NSString (BRAdd)

- (NSString *)firstCharacter {
    NSMutableString *str = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pinyin = [str capitalizedString];
    return [pinyin substringToIndex:1];
}

/// 按顺序字符串中数字出现的书序保留数字
- (NSString *)retainOfNumbers {
    return [self retainOccurrencesInSet:@".0123456789"];
}

- (NSString *)retainOccurrencesInSet:(NSString *)setString {
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:setString] invertedSet];
    return [[self componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
}

- (NSString *)subStringToString:(NSString *)str {
    NSUInteger location = [self rangeOfString:str].location;
    if (location == NSNotFound) return nil;
    return [self substringToIndex:location];
}
/// 生成从指定字符开始的字符串
- (NSString *)subStringFromString:(NSString *)str {
    NSUInteger location = [self rangeOfString:str].location;
    if (location == NSNotFound) return nil;
    return [self substringFromIndex:location];
}
- (NSString *)removeString:(NSString *)str {
    NSRange range = [self rangeOfString:str];
    if (range.location == NSNotFound) return self;
    return [self stringByReplacingCharactersInRange:range withString:@""];
}

- (NSString *)substringFromString:(NSString *)fromString toString:(NSString *)toString
{
    if (!self.length) return nil;
    NSString *copy = self.copy;
    NSUInteger loc = 0;
    if (fromString.length) {
        NSRange from = [copy rangeOfString:fromString];
        if (from.location != NSNotFound) {
            loc = from.location + from.length;
            copy = [copy substringFromIndex:loc];
        }
    }
    if (toString.length) {
        NSRange to = [copy rangeOfString:toString];
        if (to.location != NSNotFound) {
            copy = [copy substringToIndex:to.location];
        }
    }
    return copy;
}

- (void)enumerateSequenceCharacterUsingBlock:(void (^)(NSString *, NSRange, BOOL *))block
{
    NSParameterAssert(block);
    NSRange range = NSMakeRange(0, 0);
    BOOL flag = NO;
    for (NSInteger i = 0; i < self.length; i += range.length)
    {
        range = [self rangeOfComposedCharacterSequenceAtIndex:i];
        NSString *s = [self substringWithRange:range];
        block(s, range, &flag);
        if (flag)
        {
            break;
        }
    }
}


/// 表情编码
- (NSString *)stringByEmojiEncode {
    NSString *uniStr = [NSString stringWithUTF8String:[self UTF8String]];
    NSData *uniData = [uniStr dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    return [[NSString alloc] initWithData:uniData encoding:NSUTF8StringEncoding];
}
/// 表情解码
- (NSString *)stringByEmojiDecode {
    const char *jsonString = [self UTF8String];
    NSData *jsonData = [NSData dataWithBytes:jsonString length:strlen(jsonString)];
    return [[NSString alloc] initWithData:jsonData encoding:NSNonLossyASCIIStringEncoding];
}

- (BOOL)matchesRegular:(NSString *)regular {
    if (regular.length < 1) return NO;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    return [predicate evaluateWithObject:self];
}
/// 邮箱验证
- (BOOL)isEmail { 
    NSString *regular = @"^([A-Za-z0-9_\\-\\.])+\\@([A-Za-z0-9_\\-\\.])+\\.([A-Za-z]{2,4})$";
    return [self matchesRegular:regular];
}


- (BOOL)containsEmoji {
    if (!self.length) return NO;
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     *stop = returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 *stop = returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 *stop = returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 *stop = returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 *stop = returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 *stop = returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 *stop = returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

- (BOOL)containsSudokuNumber {
    if (!self.length) return NO;
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         
         if (0x2100 <= hs && hs <= 0x27ff) {
             // U+278b ➋ ~ U+2792➒"
             if (0x278b <= hs && hs <= 0x2792) {
                 *stop = returnValue = YES;
             } else if (0x263b == hs) {// U+263b u'☻'
                 *stop = returnValue = YES;
             }
         }
     }];
    return returnValue;
}


- (int)wordsCount {
    NSInteger n = self.length;
    int i;
    int l = 0, a = 0, b = 0;
    unichar c;
    for (i = 0; i < n; i++) {
        c = [self characterAtIndex:i];
        if (isblank(c)) {
            b++;
        } else if (isascii(c)) {
            a++;
        } else {
            l++;
        }
    }
    if (a == 0 && l == 0) return 0;
    return l + (int)ceilf((float)(a + b) / 2.0);
}

- (NSDictionary *)splitByDictionary:(NSDictionary<NSString *, NSString *> *)info {
    NSMutableCharacterSet *letterSet = [NSMutableCharacterSet letterCharacterSet];
    NSString *type = nil;
    NSString *value = nil;
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    while (![scanner isAtEnd]) {
        if (![scanner scanCharactersFromSet:letterSet intoString:&type]) {
            scanner.scanLocation++; continue;
        }
        NSString *key = info[type];
        if (!key.length) continue;
        if (![scanner scanUpToCharactersFromSet:letterSet intoString:&value]) {
            scanner.scanLocation++; continue;
        }
        result[key] = value;
    }
    return result;
}
@end
