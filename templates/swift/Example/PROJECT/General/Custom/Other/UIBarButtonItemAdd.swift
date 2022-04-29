//
//  UIBarButtonItemAdd.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import UIKit

extension UIBarButtonItem {
    static func settings(target: Any?, action: Selector?) -> UIBarButtonItem {
        UIBarButtonItem(image: UIImage(named: "ic_home_settings")?.original, style: .plain, target: target, action: action) 
    }
    static func close(target: Any?, action: Selector?) -> UIBarButtonItem {
        UIBarButtonItem(image: UIImage(named: "ic_nav_close")?.original, style: .plain, target: target, action: action)
    }
}
