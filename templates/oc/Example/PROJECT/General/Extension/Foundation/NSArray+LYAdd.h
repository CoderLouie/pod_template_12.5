//
//  NSArray+LYAdd.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<__covariant ObjectType> (LYAdd)

- (void)each:(void (^)(ObjectType obj, NSUInteger idx))block;

- (NSArray *)map:(id _Nullable (^)(ObjectType obj, NSUInteger idx))block;

- (ObjectType)match:(BOOL (^)(ObjectType obj))block;

- (NSUInteger)filter:(BOOL (^)(ObjectType obj))block;

 
- (CGFloat)sum;
 
- (CGFloat)max;
 
- (CGFloat)min;
 
- (CGFloat)avg;
 
- (NSArray<ObjectType> *_Nullable)distinctUnionOfObjects;
- (NSArray<ObjectType> *_Nullable)reversed;

- (NSArray<NSArray<ObjectType> *> *)groupedByCount:(NSUInteger)max;
@end
NS_ASSUME_NONNULL_END
