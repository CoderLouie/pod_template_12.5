//
//  PermissionTool.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import <UIKit/UIKit.h>
#import <Photos/PhotosTypes.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AuthorizationStatus) {
    AuthorizationStatusAuthorized = 0, ///< 已授权
    AuthorizationStatusDenied, ///< 拒绝
    // 应用没有相关权限，且当前用户无法改变这个权限，比如:家长控制
    AuthorizationStatusRestricted,
    AuthorizationStatusNotSupport, ///< 硬件等不支持
    AuthorizationStatusAlways, ///< 定位
    AuthorizationStatusWhenInUse, ///< 定位
};

@interface PermissionTool : NSObject

// MARK: - Photo
+ (NSString *)photoAlertTips;
+ (void)saveImageToAlbum:(UIImage *)image block:(void (^)(NSError *_Nullable error))block;
+ (void)requestPhotoPermissionWithBlock:(void (^)(AuthorizationStatus status, BOOL isFirst))block;
+ (void)requestImageWithTargetSize:(CGSize)size
                       contentMode:(PHImageContentMode)mode
                             block:(void(^)(AuthorizationStatus status, UIImage *_Nullable image, NSDictionary *_Nullable info))block;

// MARK: - Camera
+ (NSString *)cameraAlertTips;
+ (void)requestCameraPermissionWithBlock:(void (^)(AuthorizationStatus status, BOOL isFirst))block;


// MARK: - Calendar
+ (void)requestCalendarPermissionWithBlock:(void (^)(AuthorizationStatus status, BOOL isFirst))block;
+ (void)requestReminderPermissionWithBlock:(void (^)(AuthorizationStatus status, BOOL isFirst))block;

// MARK: - Location
+ (NSString *)locationAlertTips;
+ (void)requestLocationPermissionAlwaysWithBlock:(void (^)(AuthorizationStatus status, BOOL isFirst))block;
+ (void)requestLocationPermissionWhenInUseWithBlock:(void (^)(AuthorizationStatus status, BOOL isFirst))block;
+ (void)updateLocationAlwaysWithBlock:(void (^)(AuthorizationStatus status, BOOL isFirst, NSDictionary *info, NSError *error))block;
+ (void)updateLocationWhenInUseWithBlock:(void (^)(AuthorizationStatus status, BOOL isFirst, NSDictionary *_Nullable info, NSError *_Nullable error))block;

// MARK: - Health
+ (void)requestHealthPermissionWithBlock:(void (^)(AuthorizationStatus status, BOOL isFirst))block;

@end

NS_ASSUME_NONNULL_END
