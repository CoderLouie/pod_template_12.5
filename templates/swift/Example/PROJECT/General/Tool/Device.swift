//
//  Device.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import Foundation
 
enum Device {
    
    enum Area {
        case china, other
    }
    /// 是否为国区
    static var isDomestic: Bool {
        area == .china
    }
    static var area: Area {
        return .china
//        if ATIssued.isIpDomestic() {
//            return .china
//        }
//        return .other
    }
}
