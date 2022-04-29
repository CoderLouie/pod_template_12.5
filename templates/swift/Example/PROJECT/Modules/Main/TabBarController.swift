//
//  TabBarController.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import UIKit
 

class TabBarController: UITabBarController {
    
    private var lastSelectedVC: UIViewController?
    private var lastSelectedTimestamp: TimeInterval = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        addChild(HomeViewController.self, "tabbar_home", "首页")
        addChild(ProfileViewController.self, "tabbar_profile", "我")
    }
    
    @discardableResult
    private func addChild<T: UIViewController>(_ viewController: T.Type,
                                               _ image: String,
                                               _ title: String) -> T {
        let vc = T()
        vc.tabBarItem.image = UIImage(named: image)
        vc.tabBarItem.selectedImage = UIImage(named: image + "_selected")
        let font = UIFont.systemFont(ofSize: 11)
        vc.tabBarItem.setTitleTextAttributes([
            .font: font,
            .foregroundColor: UIColor(gray: 105)], for: .normal)
        vc.tabBarItem.setTitleTextAttributes([
            .font: font,
            .foregroundColor: UIColor(gray: 105)], for: .selected)
        vc.title = title
        addChild(NavigationController(rootViewController: vc))
        return vc
    }
    
}
extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let topVC: UIViewController? = {
            if let nav = viewController as? UINavigationController {
                return nav.topViewController
            }
            return viewController
        }()
        
        let now = Date().timeIntervalSinceReferenceDate
        if lastSelectedVC === topVC {
            if now - lastSelectedTimestamp < 0.5 { topVC?.tabbarButtonItemDidSelectAgain()
            }
        } else {
            topVC?.tabbarButtonItemDidSelect()
            lastSelectedVC?.tabbarButtonItemDidDeselect()
        }
        lastSelectedVC = topVC
        lastSelectedTimestamp = now
    }
}


extension UIViewController {
    @objc func tabbarButtonItemDidSelect() {}
    @objc func tabbarButtonItemDidDeselect() {}
    @objc func tabbarButtonItemDidSelectAgain() {}
}
