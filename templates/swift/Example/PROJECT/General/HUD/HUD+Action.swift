//
//  HUD+Action.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import Foundation


extension HUD {
    class ActionView: HUD.BaseView {
        enum ActionStyle {
            case theme, white, border
        }
        
        var subscribeKeyboardChangeFrameEvent: Bool {
            return false
        } 
        var topContainerEdgeInset: UIEdgeInsets {
            .init(top: 28.fit, left: h20, bottom: 0, right: h20)
        }
        var bottomContainerEdgeInset: UIEdgeInsets {
            .init(top: h20, left: h20, bottom: h20, right: h20)
        }
        var shouldAddLeftTopCloseButton: Bool {
            false
        }
        var closeAction: (() -> Void)?
        
        @objc private func keyboardWillChangeFrame(_ notify: Notification) {
            let rect = notify.userInfo?[UIApplication.keyboardFrameEndUserInfoKey] as? CGRect
            let keyboardH = rect?.height ?? 366
            let show: Bool = (rect?.minY ?? 0) < Screen.height
            let duration: TimeInterval = notify.userInfo?[UIApplication.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
            
            UIView.animate(withDuration: max(duration, 0.25)) {
                if show {
                    let frame = self.contentView.frame
                    let delta = keyboardH - (Screen.height - frame.maxY) + 10
                    guard delta > 0 else { return }
                    self.contentView.transform = CGAffineTransform(translationX: 0, y: -delta)
                } else {
                    self.contentView.transform  = .identity
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
            
            let tInset = topContainerEdgeInset
            
            topContainer = VirtualView().then {
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.top.equalTo(tInset.top)
                    make.leading.equalTo(tInset.left)
                    make.trailing.equalTo(-tInset.right)
                }
            }
            let bInset = bottomContainerEdgeInset
            bottomContainer = VirtualView().then {
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.top.equalTo(topContainer.snp.bottom).offset(bInset.top)
                    make.leading.equalTo(bInset.left)
                    make.trailing.equalTo(-bInset.right)
                    make.bottom.equalTo(-bInset.bottom)
                }
            }
            guard shouldAddLeftTopCloseButton else { return }
            
            DispatchQueue.main.async {
                UIButton().do {
                    $0.setImage(UIImage(named: "ic_close"), for: .normal)
                    $0.addBlock(for: .touchUpInside) { [unowned self] _ in
                        self.dismiss { [unowned self] in
                            self.closeAction?()
                        }
                    }
                    self.contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.leading.equalTo(h12)
                        make.top.equalTo(h12)
                        make.width.height.equalTo(26)
                    }
                }
            }
        }
        @discardableResult
        func addAction(_ title: String,
                       config: (UIButton) -> Void,
                       vOffset: CGFloat = 0,
                       closure: (() -> Void)? = nil) -> UIButton {
            UIButton().then {
                config($0)
                guard $0.allTargets.isEmpty else {
                    fatalError("use the closure param")
                }
                $0.addBlock(for: .touchUpInside) { [unowned self] _ in
                    self.dismiss {
                        closure?()
                    }
                }
                bottomContainer.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.width.equalToSuperview()
                    make.centerX.equalToSuperview()
                    make.height.equalTo(54)
                    let n = bottomContainer.subviews.count - 1
                    if n == 0 {
                        make.top.equalTo(0)
                    } else {
                        let last = bottomContainer.subviews[n - 1]
                        make.top.equalTo(last.snp.bottom).offset(vOffset)
                    }
                }
            }
        }
        
        @discardableResult
        func addAction(_ title: String,
                       style: ActionStyle = .theme,
                       vOffset: CGFloat = 0,
                       closure: (() -> Void)? = nil) -> UIButton {
            addAction(title, config: {
                switch style {
                case .theme:
                    $0.backgroundColor = .theme
                    $0.titleLabel?.font = .system20
                    $0.setTitleColor(.white, for: .normal)
                    $0.layer.cornerRadius = 27
                    $0.layer.masksToBounds = true
                case .white:
                    $0.backgroundColor = .white
                    $0.titleLabel?.font = .system16
                    $0.setTitleColor(.gray34, for: .normal)
                case .border:
                    $0.backgroundColor = .white
                    $0.titleLabel?.font = .system20
                    $0.setTitleColor(.theme, for: .normal)
                    $0.layer.cornerRadius = 27
                    $0.layer.masksToBounds = true
                    $0.layer.borderColor = UIColor.theme.cgColor
                    $0.layer.borderWidth = 1
                }
                $0.setTitle(title, for: .normal)
            }, vOffset: vOffset, closure: closure)
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
        private(set) unowned var topContainer: VirtualView!
        private(set) unowned var bottomContainer: VirtualView!
    }
    
    
    
    enum Action {
        static func show<T: HUD.ActionView>
        (config: (T) -> Void,
         actions: (T) -> Void) {
            guard let window = HUD.window else { return }
            let view = T()
            config(view)
            actions(view)
            guard let last = view.bottomContainer.subviews.last else {
                fatalError("must add at least one action button")
            }
            last.snp.makeConstraints { make in
                make.bottom.equalTo(0)
            }
            view.show(on: window)
        }
        
        static func show<T: HUD.ActionView>(
            topLevel: Bool = false,
            careteFactory: () -> T) {
            guard let window = HUD.window(topLevel: topLevel) else { return }
            if window.isHidden {
                Console.trace("HUD.show failed, window.isHidden = true")
                return
            }
            let view = careteFactory()
            guard let last = view.bottomContainer.subviews.last else {
                fatalError("must add at least one action button")
            }
            last.snp.makeConstraints { make in
                make.bottom.equalTo(0)
            }
            view.show(on: window)
        }
    }
}
