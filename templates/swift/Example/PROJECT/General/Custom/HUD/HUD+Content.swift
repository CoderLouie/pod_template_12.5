//
//  HUD.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import Foundation

extension HUD {
    class ContentView: HUD.BaseView {
        
        var theInputView: UIView? {
            nil
        }
        var subscribeKeyboardChangeFrameEvent: Bool {
            return false
        }
        private var originTransform: CGAffineTransform?
        
        @objc private func keyboardWillChangeFrame(_ notify: Notification) {
            guard let view = theInputView else { return }
            let rect = notify.userInfo?[UIApplication.keyboardFrameEndUserInfoKey] as? CGRect
            let keyboardH = rect?.height ?? 366
            let show: Bool = (rect?.minY ?? 0) < Screen.height
            let duration: TimeInterval = notify.userInfo?[UIApplication.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
            
            UIView.animate(withDuration: max(duration, 0.25)) {
                if show {
                    let crect = view.convert(view.bounds, to: nil)
                    let delta = keyboardH - (Screen.height - crect.maxY) + 10
                    guard delta > 0 else { return }
                    let transform = self.contentView.transform
                    self.originTransform = transform
                    self.contentView.transform = transform.translatedBy(x: 0, y: -delta)
                } else {
                    guard let transform = self.originTransform else {
                        return
                    }
                    self.contentView.transform  = transform
                    self.originTransform = nil
                }
            }
        }
        
        internal override func setup() {
            super.setup()
            
            if subscribeKeyboardChangeFrameEvent {
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIApplication.keyboardWillChangeFrameNotification, object: nil)
            }
            
            backgroundColor = UIColor(gray: 0, alpha: 0.4)

            contentView = UIView().then {
                $0.layer.masksToBounds = true
                $0.layer.cornerRadius = 15.fit
                $0.backgroundColor = .white
                addSubview($0)
            }
        }
        
        func show(on view: UIView) {
            frame = view.bounds
            view.addSubview(self)
            
            var size = contentView.bounds.size
            if size.isEmpty {
                layoutIfNeeded()
                size = contentView.bounds.size
            }
            
            doAnimation(true, contentSize: size) {
                
            }
        }
        func dismiss(completion: @escaping () -> Void) {
            let size = contentView.bounds.size
            doAnimation(false, contentSize: size) {
                completion()
                self.removeFromSuperview()
            }
        }
        
        func doAnimation(_ show: Bool,
                         contentSize size: CGSize,
                         completion: @escaping () -> Void) {
            completion()
        }
        private(set) unowned var contentView: UIView!
    }
    
    enum Content {
        static func show<T: HUD.ContentView>(
            topLevel: Bool = false,
            careteFactory: () -> T) {
            guard let window = HUD.window(topLevel: topLevel) else { return }
            if window.isHidden {
                Console.trace("HUD.show failed, window.isHidden = true")
                return
            }
            let view = careteFactory()
            view.show(on: window)
        }
    }
}
