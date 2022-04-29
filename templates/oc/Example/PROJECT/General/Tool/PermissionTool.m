//
//  PermissionTool.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import "PermissionTool.h"
#import <Photos/Photos.h>
#import <Photos/PHImageManager.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <EventKit/EventKit.h>
#import <CoreLocation/CoreLocation.h>

typedef NSString *const PermissionKey;

static PermissionKey kCameraPermission = @"NSCameraUsageDescription";
// 麦克风
static PermissionKey kMicrophonePermission = @"NSMicrophoneUsageDescription";
static PermissionKey kPhotoLibrayPermission = @"NSPhotoLibraryUsageDescription";
static PermissionKey kAddPhotoToLibraryPermission = @"NSPhotoLibraryAddUsageDescription";
static PermissionKey kContactsPermission = @"NSContactsUsageDescription";
static PermissionKey kCalendarsPermission = @"NSCalendarsUsageDescription";
static PermissionKey kRemindersPermission = @"NSRemindersUsageDescription";
static PermissionKey kLocationWhenInUsePermission = @"NSLocationWhenInUseUsageDescription";
static PermissionKey kLocationAlwaysPermission = @"NSLocationAlwaysAndWhenInUseUsageDescription";
static PermissionKey kAppleMusicPermission = @"NSAppleMusicUsageDescription";
static PermissionKey kSpeechRecognitionPermission = @"NSSpeechRecognitionUsageDescription";
static PermissionKey kMotionPermission = @"NSMotionUsageDescription";
static PermissionKey kHealthUpdatePermission = @"NSHealthUpdateUsageDescription";
static PermissionKey kHealthSharePermission = @"NSHealthShareUsageDescription";

static const NSInteger AuthorizationStatusNotDetermined = -1;

void exec_on_main_queue(void(^block)(void)) {
    dispatch_async(dispatch_get_main_queue(), block);
}

static AuthorizationStatus statusFromLocation(CLAuthorizationStatus status) {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
            return AuthorizationStatusAlways;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            return AuthorizationStatusWhenInUse;
        case kCLAuthorizationStatusNotDetermined:
            return AuthorizationStatusNotDetermined;
        case kCLAuthorizationStatusRestricted:
            return AuthorizationStatusRestricted;
        case kCLAuthorizationStatusDenied:
            return AuthorizationStatusDenied;
    }
}

@interface LocationManager : NSObject <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, copy) void (^authorizationBlock)(AuthorizationStatus status);
@property (nonatomic, copy) void (^updateBlock)(NSDictionary *, NSError *);
@property (atomic, assign) BOOL duringProcess;
@end
@implementation LocationManager
- (CLLocationManager *)manager {
    if (_manager) return _manager;
    CLLocationManager *mgr = [[CLLocationManager alloc] init];
    mgr.delegate = self;
    _manager = mgr;
    return _manager;
}

- (void)requestAlwaysAuthorizationWithBlock:(void(^)(AuthorizationStatus status))block {
    self.authorizationBlock = block;
    [self.manager requestAlwaysAuthorization];
}
- (void)requestWhenInUseAuthorizationWithBlock:(void(^)(AuthorizationStatus status))block {
    self.authorizationBlock = block;
    [self.manager requestWhenInUseAuthorization];
}
- (void)updateLocationWithBlock:(void (^)(NSDictionary *info, NSError *error))block {
    if (self.duringProcess) return;
    self.updateBlock = block;
    self.duringProcess = YES;
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.manager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self.manager stopUpdatingLocation];
    
    if (!locations.count) {
        [self didEndUpdateWith:nil error:nil];
        return;
    }
    
    CLLocation *location = locations.firstObject;
    
    CLLocationDegrees latitude = location.coordinate.latitude;
    CLLocationDegrees longitude = location.coordinate.longitude;
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    CLLocation *geoLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    CLGeocodeCompletionHandler handler = ^(NSArray *placemarks,NSError *error) {
        if (error || !placemarks.count)
        {
            [self didEndUpdateWith:nil error:error];
            return;
        }
        //取首个placemark的城市
        CLPlacemark *placemark = placemarks.firstObject;
        NSDictionary *addressDic = placemark.addressDictionary;
        NSString *cityName = [addressDic objectForKey:@"City"];
        NSString *coordinate = [NSString stringWithFormat:@"%f,%f", latitude, longitude];
        NSDictionary *data = @{@"cityName": cityName,
                               @"coordinate": coordinate
                               };
        [self didEndUpdateWith:data error:nil];
    };
    
    if (@available(iOS 11.0, *)) {
        [geoCoder reverseGeocodeLocation:geoLocation
                         preferredLocale:[NSLocale currentLocale]
                       completionHandler:handler];
    } else {
        [geoCoder reverseGeocodeLocation:geoLocation completionHandler:handler];
    }
}
- (void)didEndUpdateWith:(NSDictionary *)info error:(NSError *)error {
    self.duringProcess = NO;
    !self.updateBlock ?: self.updateBlock(info, error);
    self.updateBlock = nil;
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.manager stopUpdatingLocation];
    [self didEndUpdateWith:nil error:error];
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusNotDetermined) return;
    !self.authorizationBlock ?:
    self.authorizationBlock(statusFromLocation(status));
}
@end

@interface PermissionTool ()

+ (instancetype)shard;

@property (nonatomic, strong) LocationManager *locationManager;
@end

@implementation PermissionTool
- (LocationManager *)locationManager {
    if (_locationManager) return _locationManager;
    _locationManager = [[LocationManager alloc] init];
    return _locationManager;
}
+ (instancetype)shard {
    static PermissionTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[[self class] alloc] init];
    });
    return tool;
}

+ (void)assertForKey:(PermissionKey)key {
    NSString *desc = [NSString stringWithFormat:@"%@ not found in Info.plist.", key];
    NSAssert([[NSBundle mainBundle] objectForInfoDictionaryKey:key], desc);
}

// MARK: - Location
+ (NSString *)locationAlertTips {
    return @"";
}
+ (void)requestLocationPermissionAlwaysWithBlock:(void (^)(AuthorizationStatus, BOOL))block {
    if (!block) return;
    [self _requestLocationPermissionWay:1 block:^(AuthorizationStatus status, BOOL isFirst) {
        exec_on_main_queue(^{ block(status, isFirst); });
    }];
}

+ (void)requestLocationPermissionWhenInUseWithBlock:(void (^)(AuthorizationStatus, BOOL))block {
    if (!block) return;
    [self _requestLocationPermissionWay:0 block:^(AuthorizationStatus status, BOOL isFirst) {
        exec_on_main_queue(^{ block(status, isFirst); });
    }];
}
+ (void)_requestLocationPermissionWay:(NSInteger)way block:(void (^)(AuthorizationStatus status, BOOL isFirst))block {
    if (![CLLocationManager locationServicesEnabled]) {
        block(AuthorizationStatusDenied, NO);
        return;
    }
    [self assertForKey:kLocationWhenInUsePermission];
    CLAuthorizationStatus tmp = [CLLocationManager authorizationStatus];
    AuthorizationStatus status = statusFromLocation(tmp);
    if (way == 0) {
        if (status == AuthorizationStatusNotDetermined) {
            [[[self shard] locationManager] requestWhenInUseAuthorizationWithBlock:^(AuthorizationStatus status) {
                block(status, YES);
            }];
        } else {
            block(status, NO);
        }
    } else if (way == 1) {
        [self assertForKey:kLocationAlwaysPermission];
        if (status == AuthorizationStatusNotDetermined ||
            status == AuthorizationStatusWhenInUse) {
            [[[self shard] locationManager] requestAlwaysAuthorizationWithBlock:^(AuthorizationStatus status) {
                block(status, YES);
            }];
        } else {
            block(status, NO);
        }
    }
}
+ (void)updateLocationAlwaysWithBlock:(void (^)(AuthorizationStatus, BOOL, NSDictionary * _Nullable, NSError * _Nullable))block {
    if (!block) return;
    [self _requestLocationPermissionWay:1 block:^(AuthorizationStatus status, BOOL isFirst) {
        if (status == AuthorizationStatusAlways ||
            status == AuthorizationStatusWhenInUse) {
            [[[self shard] locationManager] updateLocationWithBlock:^(NSDictionary *info, NSError *error) {
                exec_on_main_queue(^{ block(status, isFirst, info, error); });
            }];
        } else {
            exec_on_main_queue(^{ block(status, isFirst, nil, nil); });
        }
    }];
}
+ (void)updateLocationWhenInUseWithBlock:(void (^)(AuthorizationStatus, BOOL, NSDictionary * _Nullable, NSError * _Nullable))block {
    if (!block) return;
    [self _requestLocationPermissionWay:0 block:^(AuthorizationStatus status, BOOL isFirst) {
        if (status == AuthorizationStatusAlways ||
            status == AuthorizationStatusWhenInUse) {
            [[[self shard] locationManager] updateLocationWithBlock:^(NSDictionary *info, NSError *error) {
                exec_on_main_queue(^{ block(status, isFirst, info, error); });
            }];
        } else {
            exec_on_main_queue(^{ block(status, isFirst, nil, nil); });
        }
    }];
}



// MARK: - Photo
+ (NSString *)photoAlertTips {
    return @"The photo album limited privileges, please enable in the system Settings";
}
+ (void)saveImageToAlbum:(UIImage *)image block:(void (^)(NSError * _Nullable))block {
//    UIImageWriteToSavedPhotosAlbum(image, nil, NULL, NULL);
    [self assertForKey:kAddPhotoToLibraryPermission];
    [self _requestPhotoPermissionWithBlock:^(AuthorizationStatus status, BOOL isFirst) {
        if (status == AuthorizationStatusAuthorized) {
            
            //图片存储的沙盒路径
            NSString *path = [NSTemporaryDirectory() stringByAppendingString:@"/PermissionTool/test.png"];
            [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
            
            //使用url存储到相册
            NSURL *fileUrl = [NSURL fileURLWithPath:path];
            
            PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
            [library performChanges:^{
                [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:fileUrl];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
                if (success) {
                    !block ?: block(nil);
                } else {
                    !block ?: block(error ?: [NSError errorWithDomain:@"PHPhotoLibrary" code:1 userInfo:nil]);
                }
            }];
        } else {
            
        }
    }];
}
+ (void)requestPhotoPermissionWithBlock:(void (^)(AuthorizationStatus, BOOL))block {
    if (!block) return;
    [self assertForKey:kPhotoLibrayPermission];
    [self _requestPhotoPermissionWithBlock:^(AuthorizationStatus status, BOOL isFirst) {
        if (isFirst) {
            exec_on_main_queue(^{
                block(status, YES);
            });
        } else {
            block(status, isFirst);
        }
    }];
}
+ (void)_requestPhotoPermissionWithBlock:(void (^)(AuthorizationStatus, BOOL))block {
    if (!block) return;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        block(AuthorizationStatusNotSupport, NO);
        return;
    }
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted){
        block(AuthorizationStatusRestricted, NO);
    } else if (status == PHAuthorizationStatusDenied){
        block(AuthorizationStatusDenied, NO);
    } else if (status == PHAuthorizationStatusNotDetermined) { // 用户尚未做出选择
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            AuthorizationStatus tmpStatus = AuthorizationStatusAuthorized;
            if (status == PHAuthorizationStatusRestricted){
                tmpStatus = AuthorizationStatusRestricted;
            } else if (status == PHAuthorizationStatusDenied){
                tmpStatus = AuthorizationStatusDenied;
            }
            block(tmpStatus, YES);
        }];
    } else {
        block(AuthorizationStatusAuthorized, NO);
    }
}
+ (void)requestImageWithTargetSize:(CGSize)size
                       contentMode:(PHImageContentMode)mode
                             block:(void (^)(AuthorizationStatus, UIImage * _Nullable, NSDictionary * _Nullable))block {
    if (!block) return;
    [self assertForKey:kPhotoLibrayPermission];
    [self _requestPhotoPermissionWithBlock:^(AuthorizationStatus status, BOOL isFirst) {
        if (status != AuthorizationStatusAuthorized) {
            exec_on_main_queue(^{
                block(status, nil, nil);
            });
            return;
        }
        PHFetchOptions *options = [PHFetchOptions new];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        PHAsset *asset = [[PHAsset fetchAssetsWithOptions:options] lastObject];
        if (!asset) {
            exec_on_main_queue(^{
                block(AuthorizationStatusAuthorized, nil, nil);
            });
            return;
        }
        [[PHCachingImageManager defaultManager]
         requestImageForAsset:asset
         targetSize:size
         contentMode:mode
         options:nil
         resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
             exec_on_main_queue(^{
                 block(AuthorizationStatusAuthorized, result, info);
             });
        }];
    }];
}

// MARK: - Camera
+ (NSString *)cameraAlertTips {
    return @"The camera limited privileges, please enable in the system Settings";
}
+ (void)requestCameraPermissionWithBlock:(void (^)(AuthorizationStatus, BOOL))block {
    if (!block) return;
    [self assertForKey:kCameraPermission];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        block(AuthorizationStatusNotSupport, NO);
        return;
    }
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted){
        block(AuthorizationStatusRestricted, NO);
    } else if (status == AVAuthorizationStatusDenied){
        block(AuthorizationStatusDenied, NO);
    } else if (status == AVAuthorizationStatusNotDetermined) { // 用户尚未做出选择
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            AuthorizationStatus status = granted ?
            AuthorizationStatusAuthorized : AuthorizationStatusDenied;
            exec_on_main_queue(^{
                block(status, YES);
            });
        }];
    } else {
        block(AuthorizationStatusAuthorized, NO);
    }
}

// MARK: - Calendar
+ (void)requestCalendarPermissionWithBlock:(void (^)(AuthorizationStatus, BOOL))block {
    if (!block) return;
    [self assertForKey:kCalendarsPermission];
    EKEventStore *store = [[EKEventStore alloc] init];
    if (store == nil) {
        block(AuthorizationStatusNotSupport, NO);
        return;
    }
    
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    if (status == EKAuthorizationStatusRestricted){
        block(AuthorizationStatusRestricted, NO);
    } else if (status == EKAuthorizationStatusDenied){
        block(AuthorizationStatusDenied, NO);
    } else if (status == EKAuthorizationStatusNotDetermined) {
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
            if (error) {
                exec_on_main_queue(^{
                    block(AuthorizationStatusNotSupport, YES);
                });
                return;
            }
            
            AuthorizationStatus status = granted ?
            AuthorizationStatusAuthorized : AuthorizationStatusDenied;
            exec_on_main_queue(^{
                block(status, YES);
            });
        }];
    } else {
        block(AuthorizationStatusAuthorized, NO);
    }
}

// MARK: - Reminder
+ (void)requestReminderPermissionWithBlock:(void (^)(AuthorizationStatus, BOOL))block {
    if (!block) return;
    [self assertForKey:kRemindersPermission];
    EKEventStore *store = [[EKEventStore alloc] init];
    if (store == nil) {
        block(AuthorizationStatusNotSupport, NO);
        return;
    }
    
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    if (status == EKAuthorizationStatusRestricted){
        block(AuthorizationStatusRestricted, NO);
    } else if (status == EKAuthorizationStatusDenied){
        block(AuthorizationStatusDenied, NO);
    } else if (status == EKAuthorizationStatusNotDetermined) {
        [store requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
            if (error) {
                exec_on_main_queue(^{
                    block(AuthorizationStatusNotSupport, YES);
                });
                return;
            }
            
            AuthorizationStatus status = granted ?
            AuthorizationStatusAuthorized : AuthorizationStatusDenied;
            exec_on_main_queue(^{
                block(status, YES);
            });
        }];
    } else {
        block(AuthorizationStatusAuthorized, NO);
    }
}


// MARK: - Health
+ (void)requestHealthPermissionWithBlock:(void (^)(AuthorizationStatus, BOOL))block {
    
}


@end
