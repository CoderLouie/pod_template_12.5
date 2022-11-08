//
//  HUD+Popup.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import UIKit


// MARK: - Popup
// popover
// UIPopoverPresentationController

extension HUD {
    enum ArrowDirection {
        case up
        case down
    }
    class PopupView: HUD.BaseView {
        var contentEdgeInset = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
        var arrowSize = CGSize(width: 12, height: 8)
        var distanceBetweenSource: CGFloat = 5
        
        var outlineColor = UIColor(gray: 225)
        var outlineWidth: CGFloat = 1
        var outlineRadius: CGFloat = 5
        
        weak var sourceView: UIView?
        var sourceRect: CGRect?
        
        var contentBgColor: UIColor = .white
        var maskBgColor: UIColor?
        
        var automaticallyHidesWhenTapMask = true
        
        private(set) var direction: ArrowDirection?
        private(set) unowned var contentView: UIView!
        private(set) var isPresenting = false
        
        override func setup() {
            super.setup()
            shapeLayer = CAShapeLayer().then {
                layer.addSublayer($0)
            }
            contentView = UIView().then {
                $0.backgroundColor = .clear
                addSubview($0)
            }
        }
        
        func show(_ direction: ArrowDirection? = nil, on view: UIView) {
            guard let contentView = contentView else { return }
            
            if let maskBgColor = maskBgColor {
                HUD.MaskView(style: .plain).do {
                    if self.automaticallyHidesWhenTapMask {
                        $0.tapAction = { mask in
                            mask.removeFromSuperview()
                        }
                    }
                    $0.backgroundColor = maskBgColor
                    $0.frame = view.bounds
                    view.addSubview($0)
                    $0.addSubview(self)
                }
            } else {
                view.addSubview(self)
            }
            
            let screenBounds = UIScreen.main.bounds
            let screenSize = screenBounds.size
            let sourceRect: CGRect = {
                
                if let sourceView = sourceView {
                    let rect: CGRect = {
                        if let tmp = self.sourceRect,
                           !tmp.isEmpty { return tmp }
                        return sourceView.bounds
                    }()
                    return sourceView.convert(rect, to: nil)
                } else {
                    let rect: CGRect = {
                        if let tmp = self.sourceRect,
                           !tmp.isEmpty { return tmp }
                        return CGRect(x: screenBounds.midX - 1, y: screenBounds.midY - 1, width: 2, height: 2)
                    }()
                    return rect
                }
            }()
             
            
            let arrowOffset = distanceBetweenSource
            let radius = outlineRadius
            let arrowH = arrowSize.height
            let arrowW = arrowSize.width
            let arrowW2 = arrowW * 0.5
             
            let dir: ArrowDirection = direction ?? {
                sourceRect.minY > screenSize.height * 0.5 ? .down : .up
            }()
            self.direction = dir
            
            let inset = contentEdgeInset.with {
                if dir == .up {
                    $0.top += arrowH
                } else {
                    $0.bottom += arrowH
                }
            }
            contentView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(inset)
            }
            self.snp.makeConstraints { make in
                make.top.equalTo(100)
                make.leading.equalTo(100)
            }
            layoutIfNeeded()
            let contentSize = bounds.size
            let y: CGFloat = {
                if dir == .up {
                    return sourceRect.maxY + arrowOffset
                } else {
                    return sourceRect.minY - arrowOffset - contentSize.height
                }
            }()
            
            var x: CGFloat = 0
            
            let midX = sourceRect.midX
            // 弹出区域与屏幕在水平方向上需保持的间距
            let popSpace: CGFloat = 2
            // 圆角和箭头之间的最小水平直线间距
            let roundLineSpace: CGFloat = 2
            let left = midX - contentSize.width * 0.5
            if left >= popSpace {
                let w = screenSize.width
                var right = left + contentSize.width
                if right <= w - popSpace {
                    x = left
                } else {
                    let line = arrowW2 + roundLineSpace + radius
                    if midX <= w - line - popSpace {
                        right = w - popSpace
                    } else {
                        right = midX + line
                    }
                    x = right - contentSize.width
                }
            } else {
                let line = radius + arrowW2 + roundLineSpace
                if midX >= popSpace + line {
                    x = popSpace
                } else {
                    x = midX - line
                }
            }
            
            let arrowX = midX - x
            let path = UIBezierPath()
            if dir == .up {
                let y1: CGFloat = arrowH;
                let y2: CGFloat = contentSize.height;
                let x1: CGFloat = 0;
                let x2: CGFloat = contentSize.width;
                let rt: CGFloat = y1 + radius;// radiusTop
                let rb: CGFloat = y2 - radius;// radiusBottom
                let rl: CGFloat = x1 + radius;// radiusLeft
                let rr: CGFloat = x2 - radius;// radiusRight
                
                path.move(to: CGPoint(x: arrowX, y: 0))
                path.addLine(to: CGPoint(x: arrowX - arrowW2, y: y1))
                
                path.addLine(to: CGPoint(x: rl, y: y1))
                path.addArc(withCenter: CGPoint(x: rl, y: rt), radius: radius, startAngle: 1.5 * .pi, endAngle: .pi, clockwise: false)
                
                path.addLine(to: CGPoint(x: x1, y: rb))
                path.addArc(withCenter: CGPoint(x: rl, y: rb), radius: radius, startAngle: .pi, endAngle: .pi * 0.5, clockwise: false)
                
                path.addLine(to: CGPoint(x: rr, y: y2))
                path.addArc(withCenter: CGPoint(x: rr, y: rb), radius: radius, startAngle: .pi * 0.5, endAngle: 0, clockwise: false)
                
                path.addLine(to: CGPoint(x: x2, y: rt))
                path.addArc(withCenter: CGPoint(x: rr, y: rt), radius: radius, startAngle: 0, endAngle: .pi * 1.5, clockwise: false)
                
                path.addLine(to: CGPoint(x: arrowX + arrowW2, y: y1))
            } else {
                let h: CGFloat = contentSize.height;
                let y1: CGFloat = 0;
                let y2: CGFloat = h - arrowH;
                let x1: CGFloat = 0;
                let x2: CGFloat = contentSize.width;
                let rt: CGFloat = radius;
                let rb: CGFloat = y2 - radius;
                let rl: CGFloat = x1 + radius;
                let rr: CGFloat = x2 - radius;
                
                path.move(to: CGPoint(x: arrowX, y: h));
                path.addLine(to: CGPoint(x: arrowX - arrowW2, y: y2))
                
                path.addLine(to: CGPoint(x: rl, y: y2))
                path.addArc(withCenter: CGPoint(x: rl, y: rb), radius: radius, startAngle: .pi * 0.5, endAngle: .pi, clockwise: true)
                
                path.addLine(to: CGPoint(x: x1, y: rt))
                path.addArc(withCenter: CGPoint(x: rl, y: rt), radius: radius, startAngle: .pi, endAngle: .pi * 1.5, clockwise: true)
                
                path.addLine(to: CGPoint(x: rr, y: y1))
                path.addArc(withCenter: CGPoint(x: rr, y: rt), radius: radius, startAngle: .pi * 1.5, endAngle: 0, clockwise: true)
                
                path.addLine(to: CGPoint(x: x2, y: rb))
                path.addArc(withCenter: CGPoint(x: rr, y: rb), radius: radius, startAngle: 0, endAngle: .pi * 0.5, clockwise: true)
                
                path.addLine(to: CGPoint(x: arrowX + arrowW2, y: y2))
            }
            path.close()
            
            shapeLayer.do {
                $0.path = path.cgPath
                $0.fillColor = contentBgColor.cgColor
                $0.strokeColor = outlineColor.cgColor
                $0.lineWidth = outlineWidth
            }
            backgroundColor = .clear
            self.snp.updateConstraints { make in
                make.leading.equalTo(x)
                make.top.equalTo(y)
            }
            isPresenting = true
        }
        func dismiss() {
            isPresenting = false
            if let mask = superview as? HUD.MaskView {
                mask.removeFromSuperview()
            } else {
                removeFromSuperview()
            }
        }
        private unowned var shapeLayer: CAShapeLayer!
    }
    
    class PopupTips: PopupView {
        override func setup() {
            super.setup()
            label = UILabel().then {
                contentView.addSubview($0)
                $0.textAlignment = .center
                $0.font = UIFont.systemFont(ofSize: 12).fit
                $0.textColor = UIColor(r: 90, g: 96, b: 113)
                $0.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        }
        private(set) unowned var label: UILabel!
    }
    
    
    class PopupMenu: PopupView {
        
    }
    
    enum Popup {
    }
}

// MARK: - Menu
extension HUD.Popup {
    static func show(menu: String) {
        
    }
    static func dismissMenu() {
        prevTips?.dismiss()
    }
}

// MARK: - Tips
extension HUD.Popup {
    private static var prevTips: HUD.PopupTips?
    static func show(tips: String, from view: UIView? = nil, in rect: CGRect? = nil, direction: HUD.ArrowDirection? = nil) {
        guard let window = HUD.window else { return }
        prevTips?.dismiss()
        let tipsView = HUD.PopupTips().then {
            $0.sourceView = view
            $0.sourceRect = rect
            $0.label.text = tips
        }
        tipsView.show(direction, on: window)
        prevTips = tipsView
    }
    static func show(tips: String, direction: HUD.ArrowDirection? = nil, config: (HUD.PopupTips) -> Void) {
        guard let window = HUD.window else { return }
        prevTips?.dismiss()
        let tipsView = HUD.PopupTips().then(config)
        tipsView.show(direction, on: window)
        prevTips = tipsView
    }
    static func dismissTips() {
        prevTips?.dismiss()
    }
}
