//
//  HUD.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import UIKit

enum HUD {
    static var window: UIWindow? {
        UIApplication.shared.delegate?.window ?? nil
    }
    static func window(topLevel: Bool = false) -> UIWindow? {
//        if topLevel, !adWindow.isHidden { return adWindow }
        return UIApplication.shared.delegate?.window ?? nil
    }
    class BaseView: UIView {
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        func setup () {}
        deinit {
            Console.log("\(type(of: self)) deinit")
        }
    }
}

