//
//  HUD+Present.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import Foundation


// MARK: - Present
extension HUD {
    class PresentView: HUD.ActionView {
        
        internal override func setup() {
            super.setup()
            let margin = h20
            
            contentView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.leading.equalTo(margin)
                make.trailing.equalTo(-margin)
            }
        } 
    }
    
    enum Present {  }
}
