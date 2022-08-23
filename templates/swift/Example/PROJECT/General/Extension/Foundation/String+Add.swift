//
//  String+Add.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import Foundation

extension String {

    /// 是否是的验证码
    /// 数字、英语结合，8个字符
    func isCaptcha() -> Bool {
        return isMatch(regEx: "[a-zA-Z0-9]{8}")
    }
    
    func isMatch(regEx: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", regEx).evaluate(with: self)
    }
}
 
