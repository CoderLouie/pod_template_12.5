//
//  App.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import UIKit

extension App {
    struct Environment: OptionSet {
        let rawValue: Int
        init(rawValue: Int) {
            self.rawValue = rawValue
        }
        static var debug: Environment { .init(rawValue: 1 << 0) }
        static var release: Environment { .init(rawValue: 1 << 1) }
        static var development: Environment { .init(rawValue: 1 << 2) }
        static var distributed: Environment { .init(rawValue: 1 << 3) }
    }
    
    static var environment: Environment = {
        var envir: Environment = []
        #if DEBUG
        envir.formUnion(.debug)
        #else
        envir.formUnion(.release)
        #endif
        
        #if DEVELOPMENT
        envir.formUnion(.development)
        #else
        envir.formUnion(.distributed)
        #endif
        
        return envir
    }()
     
    /// 用于Release环境输出日志(true), 正式包需设置为false
    static var logEnable: Bool {
        #if DEVELOPMENT
        return true
        #else
        return false
        #endif
    }
    
}

import SwiftyUserDefaults

fileprivate extension DefaultsKeys {
    var appInstallTimestamp: DefaultsKey<TimeInterval> {
        .init("appInstallTimestamp", defaultValue: 0)
    }
    var appIsFirstLauch: DefaultsKey<Bool> {
        .init("appIsFirstLauch", defaultValue: true)
    }
}

extension App {
    
   public static var installTimestamp: TimeInterval {
       var installTime = Defaults[\.appInstallTimestamp]
       if installTime > 0 { return installTime }
       installTime = Date().timeIntervalSince1970
       Defaults[\.appInstallTimestamp] = installTime
       return installTime
   }
   public static var isFirstLaunch: Bool {
       let isFirst = Defaults[\.appIsFirstLauch]
       if isFirst { return true }
       Defaults[\.appIsFirstLauch] = false
       return false
   }
}
