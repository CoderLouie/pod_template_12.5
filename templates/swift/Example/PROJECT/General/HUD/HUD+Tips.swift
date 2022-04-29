//
//  HUD+Tips.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import UIKit

// MARK: - Tips
extension HUD {
    
    fileprivate class TipsView: HUD.BaseView {
        unowned var label: UILabel!
        override func setup() {
            super.setup()
            backgroundColor = UIColor(gray: 28, alpha: 0.8)
            layer.cornerRadius = 4.fit
            clipsToBounds = true
            let margin = 10.fit
            label = UILabel().then {
                $0.textColor = .white
                $0.font = .system12
                $0.numberOfLines = 0
                $0.textAlignment = .center
                addSubview($0)
                $0.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                    make.edges.equalToSuperview().inset(UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin))
                    make.width.lessThanOrEqualTo(Screen.width - 6 * margin)
                }
            }
        }
    }
    
    enum Tips {
        enum Position {
            case belowStatusBar
            case belowNavBar
            case center
            case aboveTabbar
            case aboveHomeIndicator
        }
        private static var previousTips: UIView?
        static func show(_ title: String, _ position: Position = .center, completion: (() -> Void)? = nil) {
            guard let window = HUD.window else { return } 
            let tipView = TipsView()
            tipView.label.text = title
            
            previousTips?.removeFromSuperview()
            previousTips = tipView
            window.addSubview(tipView)
            tipView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                switch position {
                case .belowStatusBar:
                    make.top.equalTo(Screen.safeAreaT)
                case .belowNavBar:
                    make.top.equalTo(Screen.navbarH)
                case .center:
                    make.centerY.equalToSuperview()
                case .aboveTabbar:
                    make.bottom.equalTo(-Screen.tabbarH)
                case .aboveHomeIndicator:
                    make.bottom.equalTo(-Screen.safeAreaB)
                }
            }
            DispatchQueue.main.after(2) { [weak tipView] in
                tipView?.removeFromSuperview()
                completion?()
                previousTips = nil
            }
        }
        
        static var isShowing: Bool {
            previousTips != nil
        }
        static func dismiss() {
            previousTips?.removeSubviews()
            previousTips = nil
        }
    }
}
