//
//  HUD+Sheet.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import UIKit

// MARK: - Sheet
/*
 [用UIPresentationController来写一个简洁漂亮的底部弹出控件](https://juejin.cn/post/6844903568026124296)
 */ 

extension HUD {
    class SheetView: HUD.ActionView {
        override var bottomContainerEdgeInset: UIEdgeInsets {
            super.bottomContainerEdgeInset.with {
                $0.bottom += Screen.safeAreaB
            }
        }
        
        internal override func setup() {
            super.setup()
            
            backgroundColor = .clear
            
            contentView.snp.makeConstraints { make in
                make.top.equalTo(self.snp.bottom)
                make.leading.trailing.equalTo(0)
            }
        }
        
        override func doAnimation(_ show: Bool,
                                  completion: @escaping () -> Void) {
            if show { layoutIfNeeded() }
            contentView.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview()
                if show {
                    make.bottom.equalToSuperview()
                } else {
                    make.top.equalTo(self.snp.bottom)
                }
            }
//            self.setNeedsUpdateConstraints()
//            self.updateConstraintsIfNeeded()
            UIView.animate(withDuration: 0.25) {
                self.layoutIfNeeded()
                self.backgroundColor = show ? UIColor(gray: 0, alpha: 0.4) : .clear
            } completion: { _ in
                completion()
            }
        }
    }
    
    enum Sheet { }
}
 
