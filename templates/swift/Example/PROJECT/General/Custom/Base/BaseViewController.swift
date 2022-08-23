//
//  BaseViewController.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import UIKit


enum BarButtonItem {
    case close(_ target: UIViewController)
    case back(_ target: UIViewController)
    case image(_ name: String,
               _ target: UIViewController,
               _ selector: Selector)
    case title(_ text: String,
               _ target: UIViewController,
               _ selector: Selector)
    
    var button: UIControl {
        let btn = UIButton()
        switch self {
        case .close(let vc):
            btn.setImage(UIImage(named: "ic_close"), for: .normal)
            btn.addTarget(vc, action: #selector(UIViewController.closeBarButtonItemClicked), for: .touchUpInside)
        case .back(let vc):
            btn.setImage(UIImage(named: "ic_back"), for: .normal)
            btn.addTarget(vc, action: #selector(UIViewController.backBarButtonItemClicked), for: .touchUpInside)
        case let .image(imageName, vc, selector):
            btn.setImage(UIImage(named: imageName), for: .normal)
            btn.addTarget(vc, action: selector, for: .touchUpInside)
        case let .title(text, vc, selector):
            btn.titleLabel?.font = .semibold(16)
            btn.setTitle(text, for: .normal)
            btn.addTarget(vc, action: selector, for: .touchUpInside)
        }
        return btn
    }
    
    var isTitle: Bool {
        if case .title = self { return true }
        return false
    }
}
class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupViews()
        setup()
    }

    func setupViews() { }
    
    func setup() { }
    
    var leftNavItem: BarButtonItem? {
        if navigationController?.viewControllers.count ?? 0 > 1 {
            return .back(self)
        }
        return nil
    }
    var rightNavItem: BarButtonItem? { return nil }
    var navTitle: String? { nil }
    
    /// 子类需要在扩展中重写此方法,故加了dynamic关键字
    @objc dynamic func setupNavigationBar() {
        let navbarCenterY = Screen.safeAreaT + 22
        if let left = leftNavItem {
            leftBarButton = left.button.then {
                view.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.centerY.equalTo(navbarCenterY)
                    make.leading.equalTo(h16)
                }
            }
        }
        if let right = rightNavItem {
            rightBarButton = right.button.then {
                view.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.centerY.equalTo(navbarCenterY)
                    make.trailing.equalTo(-h16)
                }
            }
        }
        if let title = navTitle {
            UILabel().do {
                view.addSubview($0)
                $0.textColor = .white
                $0.font = .semibold(20).fit
                $0.text = title
                $0.snp.makeConstraints { make in
                    make.centerY.equalTo(navbarCenterY)
                    make.centerX.equalToSuperview()
                }
            }
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    deinit {
        Console.log("\(type(of: self)) deinit")
    }
}
