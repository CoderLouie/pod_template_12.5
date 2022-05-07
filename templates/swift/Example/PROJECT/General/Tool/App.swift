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
    /// false表示正式环境，true表示测试服环境
    static var isDevelopment: Bool {
        #if DEVELOPMENT
        return true
        #else
        return false
        #endif
    }
     
    /// 用于Release环境输出日志(true), 正式包需设置为false
    static var logEnable: Bool {
        #if DEVELOPMENT
        return true
        #else
        return false
        #endif
    }
    /// 是否是我们平常开发写代码的调试模式
    static var isCoding: Bool {
        #if DEVELOPMENT
        #if DEBUG
        return true
        #else
        return false
        #endif
        #else
        return false
        #endif
    }
    
    /// 桌面上的应用名称，多语言
    static var desktopName: String {
        LocalizedKey("CFBundleDisplayName", "InfoPlist").localized
    }
    
    /// 以下生命周期方法 只应该在 AppDelegate 响应代理方法中调用
    static func didLaunch() {
        
        if installTime > 0 { return }
        Defaults[\.appInstallTimestamp] = Date().timeIntervalSince1970
    }
    static func didEnterBackground() { 
    }
    static func willTerminate() {
        Defaults[\.appIsFirstLauch] = false
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
