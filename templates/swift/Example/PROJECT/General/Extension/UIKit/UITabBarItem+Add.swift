//
//  UITabBarItem+Add.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import UIKit

extension UITabBarItem {
    func placeImageCenter() {
        // https://segmentfault.com/q/1010000004488453
        // https://www.jianshu.com/p/dbc86f98b593
        // https://www.cnblogs.com/SoulKai/p/5786772.html
        imageInsets = UIEdgeInsets(top: 6.5, left: 0, bottom: -6.5, right: 0)
    }
    func resetImagePosition() {
        imageInsets = UIEdgeInsets.zero
    }
}
