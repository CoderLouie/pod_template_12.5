//
//  HUD+Alert.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import UIKit

// MARK: - Alert
extension HUD {
    class AlertView: HUD.ActionView {
        override func setup() {
            super.setup()
            
            contentView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.leading.equalTo(h20)
                make.trailing.equalTo(-h20)
            }
            imageView = UIImageView().then {
                topContainer.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.top.equalTo(0)
                    make.centerX.equalToSuperview()
                }
            }
            
            label = UILabel().then {
                $0.textColor = .gray34
                $0.numberOfLines = 0
                $0.textAlignment = .center
                $0.font = .system20
                topContainer.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.top.equalTo(imageView.snp.bottom).offset(h30)
                    make.centerX.equalToSuperview()
                    make.leading.greaterThanOrEqualTo(h30)
                    make.trailing.lessThanOrEqualTo(-h30)
                    make.bottom.equalTo(0)
                }
            }
        }
        fileprivate unowned var label: UILabel!
        fileprivate unowned var imageView: UIImageView!
    }
    
    enum Alert {
        static func show(
            topLevel: Bool = false,
            image: UIImage? = nil,
            message: String,
            actionTitle: String = "OK".localized,
            action: (() -> Void)? = nil) {                 HUD.Content.show(topLevel: topLevel) {
                    let view = HUD.AlertView()
                    view.imageView.image = image
                    view.label.text = message
//                view.addAction(actionTitle, closure: action)
                    return view
                }
            }
        
        static func showIAPError(_ tip: String? = nil, action: (() -> Void)? = nil) {
            let tips = tip ?? "iap_error".localized
            show(topLevel: true, image: UIImage(named: "img_wifierror"), message: tips, action: action)
        }
    }
}
