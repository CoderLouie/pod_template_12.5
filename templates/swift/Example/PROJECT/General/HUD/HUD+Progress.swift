//
//  HUD+Progress.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import UIKit

// MARK: - Progress
extension HUD {
    fileprivate final class LineProgress: HUD.BaseView {
        override func setup() {
            super.setup()
            layer.cornerRadius = 3.fit
            clipsToBounds = true
            backgroundColor = UIColor(gray: 255, alpha: 0.3)
            
            progressView = UIView().then {
                $0.layer.cornerRadius = 3.fit
                $0.clipsToBounds = true
                $0.backgroundColor = .white
                
                addSubview($0)
                $0.snp.makeConstraints { make in
                    make.leading.top.bottom.equalToSuperview()
                    make.width.equalTo(0)
                }
            }
        }
        override var intrinsicContentSize: CGSize {
            let size = super.intrinsicContentSize
            return CGSize(width: size.width, height: 6.fit)
        }
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            intrinsicContentSize
        }
        var progress: Int = 0 {
            didSet {
                progressView.snp.updateConstraints { make in
                    make.width.equalTo(bounds.size.width * (CGFloat(progress) / 100.0))
                }
            }
        }
        private unowned var progressView: UIView!
    }
    
    fileprivate final class CircleProgress: HUD.BaseView {
        private let wh: CGFloat = 86.fit
        private let progressWidth = 7.fit
        private var radius: CGFloat {
            (wh - progressWidth) * 0.5
        }
        private var trackWidth: CGFloat {
            progressWidth
        }
        override func setup() {
            super.setup()
            
            let bounds = CGRect(x: 0, y: 0, width: wh, height: wh)
            let path = UIBezierPath.init(arcCenter: CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5), radius: radius, startAngle: -.pi*0.5, endAngle: .pi*1.5, clockwise: true)
            CAShapeLayer().do {
                $0.frame = bounds
                $0.path = path.cgPath
                $0.fillColor = UIColor.clear.cgColor
                $0.strokeColor = UIColor.gray.cgColor
                $0.lineWidth = trackWidth
                $0.lineCap = .round
                
                layer.addSublayer($0)
            }
            progressLayer = CAShapeLayer().then {
                $0.frame = bounds
                $0.path = path.cgPath
                $0.fillColor = UIColor.clear.cgColor
                $0.strokeColor = UIColor.red.cgColor
                $0.lineWidth = progressWidth
//                $0.lineCap = .round
                $0.strokeEnd = 0
            }
             
            let midColor = UIColor(hexString: "#9AEE98")!
            CALayer().do {
                // 右边
                $0.addSublayer(CAGradientLayer().then {
                    $0.frame = CGRect(x: wh * 0.5, y: 0, width: wh * 0.5, height: wh)
//                    $0.colors = [UIColor.Main.gradients[0], midColor].map { $0.cgColor }
                    $0.startPoint = CGPoint(x: 0, y: 0)
                    $0.endPoint = CGPoint(x: 0, y: 1)
                })
                // 左边
                $0.addSublayer(CAGradientLayer().then {
                    $0.frame = CGRect(x: 0, y: 0, width: wh * 0.5, height: wh)
//                    $0.colors = [midColor, UIColor.Main.gradients[1]].map { $0.cgColor }
                    $0.startPoint = CGPoint(x: 1, y: 1)
                    $0.endPoint = CGPoint(x: 1, y: 0)
                })
                $0.frame = bounds
                $0.mask = progressLayer
                layer.addSublayer($0)
            }
            
            titleLabel = UILabel().then {
                $0.textColor = .white
                $0.textAlignment = .center
                $0.font = .system20
                addSubview($0)
                $0.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                }
            }
        }
        override var intrinsicContentSize: CGSize {
            let wh = 86.fit
            return CGSize(width: wh, height: wh)
        }
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            intrinsicContentSize
        }
        var progress: Int = 0 {
            didSet {
                let newValue = CGFloat(progress) / 100.0
                progressLayer.strokeEnd = newValue
                titleLabel.text = "\(progress)%"
            }
        }
        private unowned var progressLayer: CAShapeLayer!
        private var titleLabel: UILabel!
    }
    final class ProgressView<R>: HUD.BaseView {
        
        enum Action {
            case timeout(interval: TimeInterval, tips: String?, position: HUD.Tips.Position = .center)
            case prepare(tips: String)
            enum Progress {
                case system
                case custom(Int)
            }
            case progress(type: Progress)
            case finish(value: R)
            case stop(error: String?, position: HUD.Tips.Position = .center)
            case stopAndAlert(_ title: String)
        }
        private enum Status {
            case prepare
            case progress
            case dismissing
        }
        typealias ProgressTitle = (Int) -> String
        typealias ActionControl = (Action) -> Void
         
        internal override func setup() {
            super.setup() 
            backgroundColor = UIColor(gray: 255, alpha: 0.3)
            UIVisualEffectView(effect: UIBlurEffect(style: .dark)).do {
                $0.alpha = 0.99
                addSubview($0)
                $0.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
            let content = UIView().then { box in
                addSubview(box)
                box.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                    make.leading.trailing.equalToSuperview()
                }
            }

            progressView = CircleProgress().then {
                content.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.top.centerX.equalToSuperview()
                }
            }
            titleLabel = UILabel().then {
                $0.textColor = .white
                $0.font = .system18
                $0.text = " "
                $0.textAlignment = .center
                $0.numberOfLines = 0
                content.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.top.equalTo(progressView.snp.bottom).offset(30.fitH)
                    make.bottom.equalTo(0)
                    make.centerX.equalToSuperview()
                    make.leading.greaterThanOrEqualTo(h30)
                    make.trailing.lessThanOrEqualTo(-h30)
                }
            }
        }
        func show(title: ProgressTitle?,
                  action: (@escaping ActionControl) -> Void,
                  done: ((R) -> Void)?,
                  on view: UIView)  {
            self.progressTitle = title
            action(doAction(_:))
            doneHandler = done
            
            frame = view.bounds
            view.addSubview(self)
        }
        deinit {
            NSLog("ProgressView deinit")
        }
        private func doAction(_ result: Action) {
            if case let .timeout(interval: interval, tips: tips, position: pos) = result {
                DispatchQueue.main.after(interval) {[weak self] in
                    guard self?.status != .dismissing else { return }
                    self?.doAction(.stop(error: tips, position: pos))
                }
                return
            }
            switch result {
            case let .prepare(tips: tips):
                titleLabel.text = tips
            case let .progress(type: type):
                guard status != .dismissing else { return }
                switch type {
                case .system:
                    // 如果已经开始过进度，则重置进度
                    if progress > 0 {
                        progress = 0; index = 0
                    }
                    createTimer(interval: 0.1,
                                selector: #selector(progeressFast))
                case let .custom(progress):
                    // 确保不受定时器影响
                    removeTimer()
                    if progress < 100 { self.progress = progress }
                }
            case let .finish(value: value):
                guard status != .dismissing else { return }
                status = .dismissing
                /// 停止定时器
                removeTimer()
                progress = 100
                DispatchQueue.main.after(1) {
                    self.doneHandler?(value)
                    self.dismiss()
                }
            case let .stop(error: tips, position: pos):
                guard status != .dismissing else { return }
                status = .dismissing
                guard let tip = tips else {
                    dismiss()
                    return
                }
                removeTimer()
                HUD.Tips.show(tip, pos) {
                    self.dismiss()
                }
            case let .stopAndAlert(title):
                guard status != .dismissing else { return }
                status = .dismissing
                dismiss()
//                HUD.Alert.show(title)
            default: break
            }
        }
        private func dismiss() {
            removeTimer()
            removeFromSuperview()
        }
        private func removeTimer() {
            self.timer?.invalidate()
            self.timer = nil
        }
        private func createTimer(interval: TimeInterval, selector: Selector) {
            removeTimer()
            let timer = Timer(timeInterval: interval, target: self, selector: selector, userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: .common)
            self.timer = timer
        }
        @objc private func progeressFast() {
            if index < steps.count {
                progress = steps[index]
                index += 1
            } else {
                createTimer(interval: 1, selector: #selector(progeressSlow))
            }
        }
        @objc private func progeressSlow() {
            if progress < 99 { progress += 1 }
        }
        private var status: Status = .prepare
        private var index: Int = 0
        private unowned var progressView: CircleProgress!
        private(set) unowned var titleLabel: UILabel!
        
        private var progressTitle: ProgressTitle?
        private var doneHandler: ((R) -> Void)?
        private var timer: Timer?
        
        private var progress: Int = 0 {
            didSet {
//               titleLabel.text = progressTitle?(progress)
                progressView.progress = progress
            }
        }
        private lazy var steps: [Int] = {
            var steps: [Int] = []
            for i in 0..<20 {
                if i == 19 { steps.append(95) }
                else { steps.append(i * 5 + (Int(arc4random())%5)) }
            }
            return steps
        }()
    }
    enum Progress {
//        static func show<R>(resultType: R.Type,
//                            title: (ProgressView<R>.ProgressTitle)?,
//                            action: (@escaping ProgressView<R>.ActionControl) -> Void,
//                            done: ((R) -> Void)?) {
//            let view = ProgressView<R>()
//            view.show(title: title,
//                      action: action,
//                      done: done)
//        }
        static func show<R>(resultType: R.Type,
                            action: (@escaping ProgressView<R>.ActionControl) -> Void,
                            done: ((R) -> Void)?) {
            guard let window = HUD.window else { return }
            let view = ProgressView<R>()
            view.show(title: nil,
                      action: action,
                      done: done,
                      on: window)
        }
    }
}
