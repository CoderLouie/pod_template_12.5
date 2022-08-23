//
//  LoadingView.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import UIKit

extension UISlider {
    func applyButlinStyle() {
        minimumValue = 0
        maximumValue = 100
        value = 50
        
        let img = UIImage(named: "ic_slider_thumb")
        setThumbImage(img, for: .normal)
        setThumbImage(img, for: .highlighted)
        
        minimumTrackTintColor = .white
        maximumTrackTintColor = .gray43
    }
    
    var intValue: Int {
        get { Int(round(value)) }
        set { value = Float(newValue) }
    }
    
    var thumbFrame: CGRect {
        let bounds = bounds
        return thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
    }
}

class Slider: UISlider {
    let attachedValueLabel: Bool
    var valueTextMap: ((Float) -> String)?
    var onValueDidChange: ((Slider) -> Void)?
    
    init(frame: CGRect, attachedValueLabel: Bool) {
        self.attachedValueLabel = attachedValueLabel
        super.init(frame: frame)
        setup()
    }
    override convenience init(frame: CGRect) {
        self.init(frame: frame, attachedValueLabel: true)
    }
    static var normal: Slider {
        .init(frame: .zero, attachedValueLabel: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setup() {
        
        applyButlinStyle()
        
        addTarget(self, action: #selector(valueDidChange), for: .valueChanged)
    }
    @objc private func valueDidChange() {
        if attachedValueLabel {
            valueLabel.text = valueTextMap?(value) ?? "\(intValue)"
            valueLabel.sizeToFit()

            valueLabel.center = thumbFrame.center.with {
                $0.y = -(valueLabel.bounds.height * 0.5 + 8)
            } 
        }
        guard firstLayout else { return }
        onValueDidChange?(self)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        guard firstLayout else { return }
        valueDidChange()
        firstLayout = false
    }
    private var firstLayout = true
    private lazy var valueLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .semibold(16)
        $0.textAlignment = .center
        addSubview($0)
    }
}
