//
//  Permission.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import UIKit
import Photos
 
public enum Permission {
    public enum AuthorizationStatus {
        case authorized
        case denied
        case restricted
        case notSupport
        
        #if ImportLocation
        public enum LocationWay {
            case always
            case whenInUse
        }
        case location(LocationWay)
        
        fileprivate init?(locationStatus: CLAuthorizationStatus) {
            switch locationStatus {
            case .authorizedAlways:
                self = .location(.always)
            case .authorizedWhenInUse:
                self = .location(.whenInUse)
            case .restricted:
                self = .restricted
            case .denied:
                self = .denied
            default: return nil
            }
        }
        #endif
        
        var authorized: Bool {
            if case .authorized = self { return true }
            #if ImportLocation
            if case .location = self { return true }
            #endif
            return false
        }
        #if ImportLocation
        var clWhenInUse: Bool {
            if case let .location(way) = self,
               way == .whenInUse { return true }
            return false
        }
        var clAlways: Bool {
            if case let .location(way) = self,
               way == .always { return true }
            return false
        }
        #endif
    }
    public typealias CompletionHandler = (_ status: AuthorizationStatus, _ isFirst: Bool) -> Void
    
    // MARK: - Photo
    public static var photoStatus: AuthorizationStatus {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            return .notSupport
        }
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .restricted: return .restricted
        case .denied: return .denied
        case .notDetermined:
            fatalError("misuse API, you should use requestPhoto method")
        default: return .authorized
        }
    }
    public static func requestPhoto(completion: @escaping CompletionHandler) {
        assert(for: .photoUsage)
        _requestPhoto { status, isFirst in
            DispatchQueue.main.async {
                completion(status, isFirst)
            }
        }
    }

    private static func _requestPhoto(completion: @escaping CompletionHandler) {
        assert(for: .photoUsage)
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            completion(.notSupport, false)
            return
        }
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .restricted:
            completion(.restricted, false)
        case .denied:
            completion(.denied, false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                var tmpStatus: AuthorizationStatus = .authorized
                if newStatus == .restricted {
                    tmpStatus = .restricted
                } else if newStatus == .denied {
                    tmpStatus = .denied
                }
                completion(tmpStatus, true)
            }
        default:
            completion(.authorized, false)
        }
    }
    
    // MARK: - Camera
    public static var cameraStatus: AuthorizationStatus {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return .notSupport
        }
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .restricted: return .restricted
        case .denied: return .denied
        case .notDetermined:
            fatalError("misuse API, you should use requestCamera method")
        default: return .authorized
        }
    }
    public static func requestCamera(completion: @escaping CompletionHandler) {
        assert(for: .camera)
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            completion(.notSupport, false)
            return
        }
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .restricted:
            completion(.restricted, false)
        case .denied:
            completion(.denied, false)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                let tmpStatus: AuthorizationStatus = granted ? .authorized : .denied
                DispatchQueue.main.async {
                    completion(tmpStatus, true)
                }
            }
        default:
            completion(.authorized, false)
        }
    }
    
    // MARK: - ......
    
    private static func assert(for kind: PermissionKind) {
        let key = kind.bundleKey
        precondition(Bundle.main.object(forInfoDictionaryKey: key) != nil, "\(key) not found in Info.plist")
    }
    private enum PermissionKind {
        case camera
        case photoUsage
        case addPhotoToLibrary
        case locationWhenInUse
        case locationAlways
        
        var bundleKey: String {
            switch self {
            case .camera:
                return "NSCameraUsageDescription"
            case .photoUsage:
                return "NSPhotoLibraryUsageDescription"
            case .addPhotoToLibrary:
                return "NSPhotoLibraryAddUsageDescription"
            case .locationAlways:
                return "NSLocationAlwaysAndWhenInUseUsageDescription"
            case .locationWhenInUse:
                return "NSLocationWhenInUseUsageDescription"
            }
        }
    }
}


#if ImportLocation

// MARK: - Location
import CoreLocation
extension Permission {
    
    public static var locationStatus: AuthorizationStatus {
        guard CLLocationManager.locationServicesEnabled() else {
            return .denied
        }
        let status = CLLocationManager.authorizationStatus()
        guard let res = AuthorizationStatus(locationStatus: status) else { fatalError("misuse API, you should use requestLocation method") }
        return res
    }
    
    private static var locationManager: LocationManager = LocationManager()
    private static func _requestLocation(
        way: AuthorizationStatus.LocationWay,
        completion: @escaping CompletionHandler) {
        guard CLLocationManager.locationServicesEnabled() else {
            completion(.denied, false)
            return
        }
        let status = CLLocationManager.authorizationStatus()
        switch way {
        case .whenInUse:
            assert(for: .locationWhenInUse)
            if status == .notDetermined {
                locationManager.requestPermission(way: .whenInUse) { newStatus in
                    completion(newStatus, true)
                }
            } else if let newStatus = AuthorizationStatus(locationStatus: status) {
                completion(newStatus, false)
            }
        case .always:
            assert(for: .locationWhenInUse)
            assert(for: .locationAlways)
            if status == .notDetermined ||
                status == .authorizedWhenInUse {
                locationManager.requestPermission(way: .always) { newStatus in
                    completion(newStatus, true)
                }
            } else if let newStatus = AuthorizationStatus(locationStatus: status) {
                completion(newStatus, false)
            }
        }
    }
    public static func requestLocation(
        way: AuthorizationStatus.LocationWay,
        completion: @escaping CompletionHandler) {
        _requestLocation(way: way) { status, isFirst in
            DispatchQueue.main.async {
                completion(status, isFirst)
            }
        }
    }
    
    public enum UpdateLocationError: Error {
        case core(Error)
        case authority(AuthorizationStatus)
    }
    public struct Placemark: CustomStringConvertible {
        public let coordinate: CLLocationCoordinate2D
        public let placemark: CLPlacemark
        public var description: String {
            "coordinate: \(coordinate), placemark: \(placemark)"
        }
    }
    public static func updateLocation(
        way: AuthorizationStatus.LocationWay,
        completion: @escaping (Result<Placemark, UpdateLocationError>, Bool) -> Void) {
        _requestLocation(way: way) { status, isFirst in
            if case .location = status {
                locationManager.updateLocation { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .failure(let error):
                            completion(.failure(.core(error)), isFirst)
                        case .success(let res):
                            completion(.success(res), isFirst)
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(.authority(status)), isFirst)
                }
            }
        }
    }
    
    
    private final class LocationManager: NSObject, CLLocationManagerDelegate {
        let manager: CLLocationManager
        var authorization: ((AuthorizationStatus) -> Void)?
        var updateLocations: [(Result<Placemark, Error>) -> Void] = []
        var isUpdating = false
        
        override init() {
            manager = CLLocationManager()
            super.init()
            manager.delegate = self
        }
        func requestPermission(
            way: AuthorizationStatus.LocationWay,
            completion: @escaping (AuthorizationStatus) -> Void) {
            guard authorization == nil else { return }
            authorization = completion
            switch way {
            case .whenInUse:
                manager.requestWhenInUseAuthorization()
            case .always:
                manager.requestAlwaysAuthorization()
            }
        }
        func updateLocation(completion: @escaping (Result<Placemark, Error>) -> Void) {
            updateLocations.append(completion)
            if isUpdating { return }
            isUpdating = true
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.startUpdatingLocation()
        }
        private func endUpdate(result: Result<Placemark, Error>) {
            isUpdating = false
            let closures = updateLocations
            updateLocations = []
            for c in closures { c(result) }
        }
        // MARK: CLLocationManagerDelegate
        func locationManager(
            _ manager: CLLocationManager,
            didChangeAuthorization status: CLAuthorizationStatus) {
            if let newStatus = AuthorizationStatus(locationStatus: status) {
                let closure = authorization
                authorization = nil
                closure?(newStatus)
            }
        }
        func clerror(_ code: CLError.Code) -> NSError {
            NSError(domain: CLError.errorDomain, code: code.rawValue, userInfo: nil)
        }
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            manager.stopUpdatingLocation()
            guard let location = locations.first else {
                endUpdate(result: .failure(clerror(.locationUnknown)))
                return
            }
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let geocoder = CLGeocoder()
            let geoLocation = CLLocation(latitude: latitude, longitude: longitude)
            
            let closure = { (placemarks: [CLPlacemark]?, error: Error?) in
                if let geoError = error {
                    self.endUpdate(result: .failure(geoError))
                    return
                }
                guard let placemark = placemarks?.first,
                let loc = placemark.location else {
                    self.endUpdate(result: .failure(self.clerror(.locationUnknown)))
                    return
                }
                
                let res = Placemark(coordinate: loc.coordinate, placemark: placemark)
                self.endUpdate(result: .success(res))
            }
             
            if #available(iOS 11.0, *) {
                geocoder.reverseGeocodeLocation(geoLocation, preferredLocale: .current, completionHandler: closure)
            } else {
                geocoder.reverseGeocodeLocation(geoLocation, completionHandler: closure)
            }
        }
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            manager.stopUpdatingLocation()
            endUpdate(result: .failure(error))
        }
    }
}
#endif
