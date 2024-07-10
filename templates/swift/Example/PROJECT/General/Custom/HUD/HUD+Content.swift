//
//  HUD.swift
//  PROJECT
//
//  Created by 李阳 on 2023/06/07.
//

import UIKit
import SnapKit
import SwifterKnife


protocol HUDDismissable: AnyObject {
    func dismiss(completion: (() -> Void)?)
}

extension HUD {
    class ContentView: HUD.BaseView, HUDDismissable {
        
        var theInputView: UIView? {
            nil
        }
        var subscribeKeyboardChangeFrameEvent: Bool {
            return false
        }
        private var originTransform: CGAffineTransform?
        
        @objc private func keyboardWillChangeFrame(_ notify: Notification) {
            guard let event = KeyboardEvent(notification: notify),
                  let view = theInputView else { return }
            let isPresented = event.isPresented
            
            if isPresented, originTransform != nil { return }
            if !isPresented, originTransform == nil { return }
            
            UIView.animate(withDuration: event.duration, delay: 0, options: event.options) {
                if isPresented {
                    if let _ = self.originTransform { return }
                    let crect = view.convert(view.bounds, to: nil)
                    let delta = event.endFrame.minY - crect.maxY - h10
                    guard delta < 0 else { return }
                    let transform = self.contentView.transform
                    self.originTransform = transform
                    self.contentView.transform = transform.translatedBy(x: 0, y: delta)
                } else {
                    guard let transform = self.originTransform else {
                        return
                    }
                    self.contentView.transform = transform
                    self.originTransform = nil
                }
            }
        }
        
        var tapBackgroundToDismiss: Bool = false
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard tapBackgroundToDismiss else { return }
            guard let touch = touches.first else { return }
            let point = touch.location(in: self)
            switch (self, point, event) {
            case self.contentView: break
            default:
                dismiss { }
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
            
            doAnimation(true) {
                
            }
        }
        func dismiss(completion: (() -> Void)?) {
            doAnimation(false) {
                completion?()
                self.removeFromSuperview()
            }
        }
        
        func doAnimation(_ show: Bool,
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
