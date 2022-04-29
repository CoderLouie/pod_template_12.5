//
//  LoadingView.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import Foundation


class LoadingView: BaseView {
    private unowned var imgView: UIImageView!
    override func setup() {
        imgView = UIImageView().then {
            $0.image = UIImage(fileNamed: "ic_launch_loading")
            $0.isUserInteractionEnabled = true
            
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    func startLoading() {
        let anim = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        anim.repeatCount = HUGE
        anim.keyTimes = [0, 0.5, 1]
        anim.values = [0, Double.pi, 2 * Double.pi]
        anim.isRemovedOnCompletion = false
        anim.duration = 0.75
        layer.add(anim, forKey: "rotateAnimation")
    }
    func stopLoading() {
        layer.removeAllAnimations()
    }
}
