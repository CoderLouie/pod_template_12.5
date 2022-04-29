//
//  NavigationViewController.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
    }
    
    override func pushViewController(_ vc: UIViewController, animated: Bool) {
        defer { super.pushViewController(vc, animated: animated) }
        guard viewControllers.count > 0 else { return }
        vc.hidesBottomBarWhenPushed = true
        
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "navigationbar_back_withtext"), for: .normal)
        backBtn.setImage(UIImage(named: "navigationbar_back_withtext_highlighted"), for: .highlighted)
        backBtn.setTitle(viewControllers.last?.title, for: .normal)
        backBtn.sizeToFit()
        backBtn.addTarget(vc, action: #selector(backBarButtonItemClicked), for: .touchUpInside)
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
    }

}


extension NavigationController: UINavigationControllerDelegate {
    
}


extension UIViewController {
    @objc func backBarButtonItemClicked() {
        navigationController?.popViewController(animated: true)
    }
}

